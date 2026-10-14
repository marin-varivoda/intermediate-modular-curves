#!/usr/bin/env python3
"""Uncapped X1(47)/F2 preparation with CurveArith, then verified C++ search."""
import concurrent.futures
import ctypes
import datetime
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time
import traceback

RUN=Path(__file__).resolve().parent
ctypes.CDLL(None).prctl(15,b'X47_pipeline',0,0,0)
START=time.monotonic()
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def status(stage, **extra):
    data=dict(stage=stage,pid=os.getpid(),utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),elapsed_seconds=time.monotonic()-START,**extra)
    tmp=RUN/'status.tmp'; tmp.write_text(json.dumps(data,indent=2)+'\n');tmp.replace(RUN/'status.json')
    print(json.dumps(data),flush=True)

def main():
    # Inherit unlimited limits. Never lower CPU, address-space, data or RSS limits.
    limits={name:resource.getrlimit(getattr(resource,name)) for name in ['RLIMIT_CPU','RLIMIT_AS','RLIMIT_DATA','RLIMIT_RSS']}
    assert all(pair==(-1,-1) for pair in limits.values()), limits
    original=Path('/opt/magma-2.29-4')
    env=os.environ.copy()
    defaults={'MAGMA_CMD':str(original/'magma'),'MAGMAPASSFILE':str(original/'magmapassfile'),
       'MAGMA_SYSTEM_SPEC':str(original/'package/spec'),'MAGMA_LIBRARY_ROOT':str(original/'libs'),
       'MAGMA_LIBRARIES':'c9lattices:examples:galpols:intro:isolgps:matgps:pergps:simgps:solgps',
       'MAGMA_HELP_DIR':str(original/'InternalHelp'),'MAGMA_HTML_DIR':str(original/'doc/html')}
    for key,value in defaults.items():env.setdefault(key,value)
    env.setdefault('MAGMA_SYSTEM_PACKAGE_ROOT',str(Path(env['MAGMA_SYSTEM_SPEC']).parent))
    if not Path(env['MAGMAPASSFILE']).exists() and Path(env['MAGMAPASSFILE']+'.txt').exists():env['MAGMAPASSFILE']+='.txt'
    startup=Path.home()/'.magmarc'
    if startup.exists():env.setdefault('MAGMA_STARTUP_FILE',str(startup))
    env.update(MKL_SERIAL='YES',OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1')
    files=[RUN/'model.m',RUN/'export_uncapped.py',RUN/'merge_snapshot.py',RUN/'bin/X47_CPP_Ph2',Path(__file__)]
    provenance={str(p):sha(p) for p in files}
    (RUN/'launch.json').write_text(json.dumps(dict(curve='X1(47)',field_size=2,bound=28,backend='curvearith',magma_workers=4,cpp_threads=8,timeout=None,memory_limit=None,resource_limits=limits,files=provenance),indent=2)+'\n')
    status('magma_export',workers=4,backend='curvearith',time_limit=None,memory_limit=None)
    parts=[RUN/'parts'/f'part_{i}.jets' for i in range(4)]
    def worker(i):
        command=[sys.executable,'-u',str(RUN/'export_uncapped.py'),'--model',str(RUN/'model.m'),'--bound','28','--field-size','2','--backend','curvearith','--checks','16','--shard',str(i),'--shards','4','--output',str(parts[i])]
        local=env.copy();local['X47_MAGMA_BINARY']=str(RUN/'bin'/f'X47_Magma_s{i}')
        print(f'MAGMA_START shard={i} log={parts[i].with_suffix(".log")}',flush=True)
        with parts[i].with_suffix('.worker.out').open('w') as log:
            subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,env=local,check=True)
        print(f'MAGMA_COMPLETE shard={i}',flush=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        list(pool.map(worker,range(4)))
    for path,digest in provenance.items():assert sha(path)==digest, f'run input changed: {path}'
    status('checking_and_merging_exports')
    spec=importlib.util.spec_from_file_location('merge_snapshot',RUN/'merge_snapshot.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    output=RUN/'x1_47_d28.jets'
    module.merge(parts,output,lambda:time.monotonic()-START)
    manifest_path=output.with_suffix('.json');manifest=json.loads(manifest_path.read_text())
    manifest.update(expansion_backend='curvearith',status='complete',time_limit=None,memory_limit=None)
    manifest_path.write_text(json.dumps(manifest,indent=2)+'\n')
    status('cpp_search',threads=8,time_limit=None)
    with (RUN/'phase2.json').open('w') as out,(RUN/'phase2.out').open('w') as err:
        subprocess.run([str(RUN/'bin/X47_CPP_Ph2'),str(output),'--degree','28','--threads','8','--seconds','0'],stdout=out,stderr=err,check=True)
    result=json.loads((RUN/'phase2.json').read_text());assert result['complete']
    status('complete',answer=result['answer'],phase1_seconds=manifest['seconds'],phase2_seconds=result['seconds'],result=str(RUN/'phase2.json'))

if __name__=='__main__':
    try: main()
    except BaseException as error:
        status('failed',error=repr(error));traceback.print_exc();sys.exit(1)
