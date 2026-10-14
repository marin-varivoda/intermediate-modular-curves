"""Rerun the central-value computations behind the rank-zero claims (classes Z and B).

central_values.json lists the levels N for which L(J_1(N),1) != 0 is used (central_value.m), and
intermediate_central.json the pairs (N, Delta) for which L(J_Delta(N),1) != 0 is used
(intermediate_central_value.m). This script reruns Magma for each of them and writes the transcripts, one
section '=== key ===' per curve, to central_values.log and intermediate_central.log in --out (by default this
folder, replacing the saved logs; with --only, --out must be another folder).

    python3 run_rank_zero.py [--out DIR] [--jobs 4] [--only KEY ...]
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent


def magma(arguments, script):
    result = subprocess.run(['magma', '-b', *arguments, script], cwd=ROOT,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    text = result.stdout
    assert result.returncode == 0 and 'SUCCESS' in text and 'error' not in text.lower(), text
    assert 'central_zero=false' in text, text
    return text


def endpoint(level):
    return f'N={level}', magma([f'N:={level}'], 'central_value.m')


def intermediate(identifier, genus):
    level, delta = identifier.split(':')
    return identifier, magma([f'N:={level}', f'g:={genus}', f'delta:={delta}'], 'intermediate_central_value.m')


def write(path, sections):
    path.write_text('\n'.join(f'=== {key} ===\n{text.rstrip()}\n' for key, text in sections))


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--out', type=Path, default=ROOT)
    parser.add_argument('--jobs', type=int, default=4)
    parser.add_argument('--only', nargs='*', help='keys such as N=29 or 35:1,6,8,13,22,27,29,34')
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    levels = sorted(json.loads((ROOT/'central_values.json').read_text()), key=int)
    pairs = json.loads((ROOT/'intermediate_central.json').read_text())
    keys = sorted(pairs, key=lambda s: (int(s.split(':')[0]), s))
    if args.only is not None:
        # A partial run must not overwrite the complete logs that the classification reads.
        if args.out.resolve() == ROOT:
            parser.error('--only needs --out with a separate directory')
        unknown = set(args.only) - {f'N={n}' for n in levels} - set(keys)
        if unknown:
            parser.error(f'unknown keys: {sorted(unknown)}')
        levels = [n for n in levels if f'N={n}' in args.only]
        keys = [k for k in keys if k in args.only]
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        first = list(pool.map(endpoint, levels))
        second = list(pool.map(lambda k: intermediate(k, pairs[k]['genus_checked']), keys))
    write(args.out/'central_values.log', first)
    write(args.out/'intermediate_central.log', second)
    print(f'SUCCESS rank zero: {len(first)} levels N with L(J_1(N),1) != 0, '
          f'{len(second)} pairs with L(J_Delta(N),1) != 0')


if __name__ == '__main__':
    main()
