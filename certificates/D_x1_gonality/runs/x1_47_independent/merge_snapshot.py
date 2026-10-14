#!/usr/bin/env python3
"""Partition complete Magma place enumeration by base prime, then merge jets.

Partial exports carry F2JETS_PART, which the C++ loader rejects. Merging
requires identical function fields, differential bases, and rational blocks.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parse(path):
    lines = path.read_text().splitlines()
    header = lines[0].split()
    assert header[0] == 'F2JETS_PART' and header[1] == '2'
    g, c, bound, nr, md, count = map(int, header[2:])
    assert c == 1 and lines[1].split()[0] == 'COUNTS'
    identities = Path(str(path) + '.places').read_text().splitlines()
    assert len(identities) == 2 + 3 * count
    blocks, cursor = [], 2
    for index in range(count):
        tag, old, degree, limit = lines[cursor].split()
        degree, limit = int(degree), int(limit)
        assert tag == 'PLACE' and int(old) == index
        rows = lines[cursor + 1:cursor + 1 + degree * limit]
        assert len(rows) == degree * limit
        identity = identities[2 + 3 * index:5 + 3 * index]
        assert identity[0].split()[:3] == ['PLACE', str(index), str(degree)]
        blocks.append((degree, limit, rows, identity))
        cursor += 1 + degree * limit
    checks = []
    while cursor < len(lines) and lines[cursor].startswith('CHECK '):
        tokens = lines[cursor].split()
        length, dimension = int(tokens[1]), int(tokens[2])
        assert len(tokens) == 3 + 2 * length
        checks.append((dimension, [(int(tokens[i]), int(tokens[i + 1]))
                                  for i in range(3, len(tokens), 2)]))
        cursor += 1
    assert lines[cursor:] == ['END']
    assert [sum(b[0] == e for b in blocks) for e in range(1, md + 1)] == list(map(int, lines[1].split()[1:]))
    return (g, c, bound, nr, md), identities[:2], blocks, checks


def merge(parts, output, elapsed):
    records = [parse(p) for p in parts]
    metadata, identity_header, first_blocks, _ = records[0]
    g, c, bound, nr, md = metadata
    basis = Path(str(parts[0]) + '.basis').read_bytes()
    manifests = [json.loads(p.with_suffix('.json').read_text()) for p in parts]
    for index, (part, manifest) in enumerate(zip(parts, manifests)):
        assert manifest['shard'] == index and manifest['shards'] == len(parts)
        for filename, digest in manifest['files'].items():
            assert sha(Path(filename)) == digest, filename
        assert Path(str(part) + '.basis').read_bytes() == basis, 'differential bases differ'
    blocks = [(0, i, b) for i, b in enumerate(first_blocks[:nr])]
    for shard, (meta, ids, bs, _) in enumerate(records):
        assert meta == metadata and ids == identity_header
        assert bs[:nr] == first_blocks[:nr], 'rational blocks differ'
        blocks.extend((shard, i, b) for i, b in enumerate(bs) if i >= nr)
    blocks.sort(key=lambda item: item[2][0])
    mapping = {(shard, i): i for shard in range(len(parts)) for i in range(nr)}
    rows, identities = [], identity_header[:]
    counts = [0] * md
    for index, (shard, old, (degree, limit, coefficients, identity)) in enumerate(blocks):
        mapping[shard, old] = index
        counts[degree - 1] += 1
        rows.append(f'PLACE {index} {degree} {limit}')
        rows.extend(coefficients)
        identities.append(f'PLACE {index} {degree} {identity[0].split()[3]}')
        identities.extend(identity[1:])
    for shard, (_, _, _, checks) in enumerate(records):
        for dimension, terms in checks:
            translated = sorted((mapping[shard, p], m) for p, m in terms)
            rows.append(f'CHECK {len(terms)} {dimension} ' + ' '.join(f'{p} {m}' for p, m in translated))
    rows.append('END')
    rows = [f'F2JETS 2 {g} {c} {bound} {nr} {md} {len(blocks)}',
            'COUNTS ' + ' '.join(map(str, counts))] + rows
    output.write_text('\n'.join(rows) + '\n')
    placefile = Path(str(output) + '.places')
    placefile.write_text('\n'.join(identities) + '\n')
    files = {str(p.with_suffix('.json')): sha(p.with_suffix('.json')) for p in parts}
    files.update({str(p): sha(p) for p in [output, placefile]})
    manifest = {'seconds': elapsed(), 'bound': bound, 'backend': 'parallel-magma-roots',
                'shards': len(parts), 'files': files, 'place_counts': counts,
                'basis_sha256': hashlib.sha256(basis).hexdigest()}
    output.with_suffix('.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps(manifest), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--model', type=Path, required=True)
    parser.add_argument('--kind', choices=['plane', 'field', 'canonical'], default='plane')
    parser.add_argument('--bound', type=int, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--jobs', type=int, default=8)
    parser.add_argument('--checks', type=int, default=8)
    args = parser.parse_args()
    if args.jobs < 2:
        parser.error('parallel export needs at least two jobs')
    output = args.output.resolve()
    if output.exists():
        parser.error('output already exists')
    directory = output.parent / (output.stem + '_parts')
    directory.mkdir(parents=True, exist_ok=True)
    parts = [directory / f'part_{i}.jets' for i in range(args.jobs)]
    started = time.monotonic()
    reused = [p for p in parts if p.with_suffix('.json').exists()]

    def run(index):
        part = parts[index]
        # Completed shards are reusable; merge rechecks every recorded hash.
        if part.with_suffix('.json').exists():
            previous = json.loads(part.with_suffix('.json').read_text())
            assert previous['bound'] == args.bound and previous['kind'] == args.kind
            assert previous['shard'] == index and previous['shards'] == args.jobs
            assert previous['files'][str(args.model.resolve())] == sha(args.model.resolve())
            return
        command = [sys.executable, str(ROOT / 'export.py'), '--model', str(args.model.resolve()),
                   '--kind', args.kind, '--bound', str(args.bound), '--output', str(part),
                   '--shard', str(index), '--shards', str(args.jobs), '--checks', str(args.checks),
                   '--timeout', '14400']
        with part.with_suffix('.process.log').open('w') as log:
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
        print(f'SHARD_COMPLETE {index}', flush=True)

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        list(pool.map(run, range(args.jobs)))
    merge(parts, output, lambda: time.monotonic() - started)
    if reused:
        # A resumed invocation cannot reconstruct the original wall time.
        # Never publish the short merge/resume time as complete preparation.
        manifest_path = output.with_suffix('.json')
        manifest = json.loads(manifest_path.read_text())
        manifest['resume_seconds'] = manifest.pop('seconds')
        manifest['seconds'] = None
        manifest['reused_shards'] = len(reused)
        manifest['sum_shard_seconds'] = sum(json.loads(p.with_suffix('.json').read_text())['seconds'] for p in parts)
        manifest_path.write_text(json.dumps(manifest, indent=2)+'\n')


if __name__ == '__main__':
    main()
