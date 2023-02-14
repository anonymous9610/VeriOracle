import pandas as pd
import os
from pathlib import Path
from subprocess import Popen, PIPE
from multiprocessing import Pool

pipe = Popen("kprove --default-claim-type all-path experment/specs/17736849_0X778911E64D23341EEDB0129D3AD6B1B7F4127C1312CAB2CFCDA92250F73E6378.k", shell=True, stdout=PIPE, stderr=PIPE)
stdoutdata, stderrdata = pipe.communicate()
output = stdoutdata + stderrdata
output = str(output, 'utf8')
print(output)
print('#Top' in output)