import pandas as pd
import os
from pathlib import Path
from subprocess import Popen, PIPE
from multiprocessing import Pool

BLANK_SPEC = """
module {tx_head}
    imports TOOL
    claim <k>
            Attacker in BUSD swaps Alpha:Int for LUNA output;
            Attacker deposits Alpha:Int LUNA to Venus;
            Attacker borrows Beta:Int BUSD from Venus;
        => . ...
     </k>
    <Block> .List => ?_  </Block>
    <Vault> .Map => ?_  </Vault>
    <Oracle> (Chainlink in LUNA) |-> {oracle_price} => ?_  </Oracle>
    <CFactor> (Venus in LUNA) |-> 55 => ?_  </CFactor>
    <State> (UniDex in LUNA) |-> {reserve0} (UniDex in BUSD) |-> {reserve1} => ?S:Map </State>
    requires (Alpha >Int 0) andBool (Alpha <Int ({reserve0} /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int {oracle_price}) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int {oracle_price}) *Int 10000) *Int 55 /Int 100))
    ensures {{?S[Attacker in BUSD]}}:>Int <Int 0
endmodule
"""

def backtest_one(transaction_hash, block_number, reserve0, reserve1, price):
    row = {'transaction_hash':transaction_hash, 'block_number':block_number, 'reserve0':reserve0, 'reserve1':reserve1, 'price':price}
    tx_head = '{block}_{tx}'.format(block=row['block_number'],tx=row['transaction_hash']).upper()
    spec_file = 'experment/specs/{tx_head}.k'.format(tx_head=tx_head)
    spec = BLANK_SPEC.format(tx_head=tx_head,oracle_price=row['price'], reserve0=row['reserve0'], reserve1=row['reserve1'])
    Path(os.path.dirname(spec_file)).mkdir(parents=True, exist_ok=True)
    open(spec_file, "w").write(spec)
    pipe = Popen("kprove --default-claim-type all-path " + spec_file, shell=True, stdout=PIPE, stderr=PIPE)
    print("kprove --default-claim-type all-path " + spec_file)
    stdoutdata, stderrdata = pipe.communicate()
    output = stdoutdata + stderrdata
    output = str(output, 'utf8')
    # print(output)
    # print('#Top' in output)
    if '#Top' in output:
        row['safe_flag'] = True
    else:
        row['safe_flag'] = False
    return row


df = pd.read_csv('venus.csv')
# df = df[df['block_number'] < 17731434]
df = df.groupby('block_number').agg({
    'transaction_hash':'last',
    'block_number':'last',
    'reserve0':'last',
    'reserve1':'last',
    'price':'last',
})
arg_list = []
for index, row in df.iterrows():
    arg_list.append(row)
# arg_list = arg_list[:40]
print(len(arg_list))
with Pool(processes=40) as pl:
    # parallel verification
    result = pl.starmap(backtest_one, arg_list)
result = pd.DataFrame(result)
result.to_csv('res_test.csv', index=False)
