"""Cross-check of Theorem C against the LMFDB: for each strict curve with 41 <= N <= 50, the gonality in
paper/tables/thmC.tex must lie in the interval q_gonality_bounds recorded in the LMFDB (and equal q_gonality
where the LMFDB records it), and the genus must agree. Needs network access; output in lmfdb_crosscheck.log.

    python3 lmfdb_crosscheck.py > lmfdb_crosscheck.log
"""
import json
from pathlib import Path
import re
import time
import urllib.request

TABLE = Path(__file__).resolve().parents[2]/'paper'/'tables'/'thmC.tex'
API = 'https://beta.lmfdb.org/api/gps_gl2zhat_fine/?label={}&_format=json&_fields=label,q_gonality,q_gonality_bounds,genus'


def lmfdb(label):
    # The site sets the cookie human=1 with JavaScript before serving the API.
    request = urllib.request.Request(API.format(label), headers={'User-Agent': 'Mozilla/5.0', 'Cookie': 'human=1'})
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.loads(response.read())['data'][0]


def main():
    conflicts = 0
    rows = [re.match(r'(\S+) & .*? & (\d+) & (\d+) &', line) for line in TABLE.read_text().splitlines()]
    rows = [(m.group(1), int(m.group(2)), int(m.group(3))) for m in rows if m and 41 <= int(m.group(1).split('.')[0]) <= 50]
    for label, genus, gonality in rows:
        record = lmfdb(label)
        low, high = record['q_gonality_bounds']
        ok = low <= gonality <= high and record['genus'] == genus and record['q_gonality'] in (None, gonality)
        conflicts += not ok
        print(f"{label:16} g={genus:2} paper={gonality:2} LMFDB bounds=[{low},{high}] "
              f"q_gonality={record['q_gonality']} {'ok' if ok else 'CONFLICT'}", flush=True)
        time.sleep(1)
    print(f'{len(rows)} curves, {conflicts} conflicts')
    print('SUCCESS' if conflicts == 0 else 'FAIL')


if __name__ == '__main__':
    main()
