#!/usr/bin/env python3
"""Run Magma's trusted preparation; keep the input, log, and SHA256 manifest."""
import argparse
import os
import hashlib
import json
from pathlib import Path
import subprocess
import time

ROOT = Path('/home/mvarivoda/imc/f2_gonality')
CA_CANDIDATES = [ROOT.parent / "third_party/CurveArith",
                 ROOT.parent / "intermediate-modular-curves-lab/third_party/CurveArith"]
DEFAULT_CURVEARITH = next((p for p in CA_CANDIDATES if p.exists()), CA_CANDIDATES[-1])

def quote(p):
    return '"' + str(p).replace('\\', '\\\\').replace('"', '\\"') + '"'

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--model', type=Path, required=True,
                   help='Magma file defining X (plane polynomial or curve), or K with --kind field')
    p.add_argument('--kind', choices=['plane', 'canonical', 'field'], default='plane')
    p.add_argument('--bound', type=int, required=True)
    p.add_argument('--field-size', type=int, default=2)
    p.add_argument('--generic', action='store_true', help='Write FFJETS, including for F2')
    p.add_argument('--spectra', action='store_true', help='Validate small actual-function pole spectra')
    p.add_argument('--output', type=Path, required=True)
    p.add_argument('--curvearith', type=Path, default=DEFAULT_CURVEARITH)
    p.add_argument('--backend', choices=['fast','curvearith'], default='fast')
    p.add_argument('--checks', type=int, default=8)
    p.add_argument('--reference', action='store_true', help='Also run stock CurveArith at the requested bound')
    p.add_argument('--timeout', type=float, default=1800)
    p.add_argument('--shard', type=int, default=0)
    p.add_argument('--shards', type=int, default=1)
    a = p.parse_args()
    if a.bound < 1 or a.checks < 0:
        p.error('bound must be positive and checks nonnegative')
    if not 0 <= a.shard < a.shards:
        p.error('require 0 <= shard < shards')
    out = a.output.resolve(); out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists():
        p.error(f'output already exists: {out}; choose a new path')
    model = a.model.resolve(); ca = a.curvearith.resolve() / 'src/gonality.m'
    driver = out.with_suffix('.driver.m'); log = out.with_suffix('.log')
    snapshot = out.with_suffix('.export.m')
    generic = a.generic or a.field_size != 2
    if generic and a.shards != 1:
        p.error('generic export currently uses complete serial place enumeration')
    snapshot.write_bytes((ROOT/'magma/export_ff.m').read_bytes() if generic else (ROOT/'magma/places.m').read_bytes()+b'\n'+(ROOT/'magma/export.m').read_bytes())
    lines = ['SetQuitOnError(true);', 'SetColumns(0);',
             'vmajor,vminor,vpatch:=GetVersion();',
             'printf "MAGMA_VERSION %o.%o-%o\\n", vmajor,vminor,vpatch;',
             f'AttachSpec({quote(a.curvearith.resolve() / "CurveArith.spec")});',
             f'import {quote(ca)} : DifferentialExpansionMatrices;', f'load {quote(snapshot)};']
    if a.kind == 'plane':
        lines.append('A<x,y>:=PolynomialRing(Rationals(),2);')
    lines.append(f'load {quote(model)};')
    if a.kind == 'plane':
        lines += [f'RF<xx>:=FunctionField(GF({a.field_size})); T<yy>:=PolynomialRing(RF);',
                  f'f:=Evaluate(ChangeRing(X,GF({a.field_size})),[T!xx,yy]);',
                  'assert IsIrreducible(f); K<a>:=FunctionField(f);']
    elif a.kind == 'canonical':
        lines += [f'C:=Curve(Reduction(X,{a.field_size})); assert Genus(C) eq g;',
                  'K:=AlgorithmicFunctionField(FunctionField(C));']
    if generic:
        lines.append(f'assert #ConstantField(K) eq {a.field_size};')
        lines.append(f'ps,blocks:=ExportFiniteFieldJets(K,{a.bound},{quote(out)}:Checks:={a.checks},Spectra:={str(a.spectra).lower()});')
    else:
        lines.append(f'ps,blocks:=ExportF2Jets(K,{a.bound},{quote(out)}:Checks:={a.checks},Backend:={quote(a.backend)},Shard:={a.shard},Shards:={a.shards},PlaceEnumerator:=F2PlacesOfDegree);')
    if a.reference:
        lines += [f'ans,timing:=CAHasFunctionOfDegreeAtMost(K,{a.bound}:TimingData:=true);',
                  'printf "REFERENCE answer=%o places=%o expansions=%o search=%o divisors=%o\\n",'
                  'ans,timing`place_enumeration_time,timing`expansions_time,timing`riemann_roch_time,timing`divisors;']
    lines += ['print "EXPORT_RUN_COMPLETE";', 'quit;']
    driver.write_text('\n'.join(lines) + '\n')
    # Never accept an artifact left by an earlier failed run.
    if out.exists():
        p.error(f'output already exists: {out}; choose a new path')
    inputs = [model, ca, snapshot, driver]
    hashes = {str(x): hashlib.sha256(x.read_bytes()).hexdigest() for x in inputs}
    started = time.monotonic()
    try:
        with log.open('w') as f:
            result = subprocess.run([os.environ['X47_MAGMA_BINARY'], '-b', str(driver)], stdout=f,
                                    stderr=subprocess.STDOUT, timeout=None)
    except subprocess.TimeoutExpired:
        failure = {'status': 'timeout', 'complete': False, 'seconds': time.monotonic()-started,
                   'bound': a.bound, 'field_size': a.field_size, 'files': hashes,
                   'log': str(log)}
        out.with_suffix('.failure.json').write_text(json.dumps(failure, indent=2)+'\n')
        raise RuntimeError(f'Magma preparation timed out; no result certified. See {log}') from None
    content = log.read_text()
    if result.returncode or 'EXPORT_RUN_COMPLETE' not in content or not out.exists():
        raise RuntimeError(f'Magma export failed; see {log}\n{content[-3000:]}')
    files = [out, Path(str(out)+'.places')]
    if a.shards > 1:
        files.append(Path(str(out)+'.basis'))
    for x in inputs:
        if hashlib.sha256(x.read_bytes()).hexdigest() != hashes[str(x)]:
            raise RuntimeError(f'input changed during export: {x}')
    manifest = {'seconds': time.monotonic()-started, 'bound': a.bound,
                'status': 'complete', 'log_sha256': hashlib.sha256(log.read_bytes()).hexdigest(),
                'kind': a.kind, 'field_size': a.field_size, 'format': 'FFJETS' if generic else 'F2JETS', 'backend': 'curvearith' if generic else a.backend, 'shard': a.shard, 'shards': a.shards,
                'files': {**hashes, **{str(x): hashlib.sha256(x.read_bytes()).hexdigest() for x in files}}}
    out.with_suffix('.json').write_text(json.dumps(manifest, indent=2)+'\n')
    print(content[-2000:])

if __name__ == '__main__':
    main()
