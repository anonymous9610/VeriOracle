# VeriOracle

## Description

VeriOracle is a formal verification framework for automated detecting unanticipated price feed in the smart contracts.

VeriOracle can formal semantic model of the price oracle on the blockchain to detect the status of smart contracts and identify unanticipated price feed transactions in real-time.

## Usage

- Prepare requirements.
    Python environment: please use Python 3.8, which is recommended (tested).
    K-framework：https://github.com/runtimeverification/k

- Demo test
   ```shell
   sh test.sh
   ```
   
- Deploy on blockchain for runtime verification.

1. Compile VeriOracle; 
```shell
   kompile tool.k --backend java
```
2. Read parameters from Ethereum transactions;
   etherscan: https://api.etherscan.io/
   bscerscan: https://api.bscscan.com/

3. Fill in the parameters into the specification template to generate verification scripts; 
      example: https://github.com/anonymous9610/VeriOracle/blob/main/experment/specs/17731430_0X962A23A34B40E09854AC7089CBDA233463712922A0A31D76300FFC86358108B1.k

4. Execute the verification scripts.
```shell
    kprove --default-claim-type all-path {spec_file_path}
```
