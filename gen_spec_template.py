def Patten1():
    BLANK_SPEC = """
    module BOUND
        imports LENDING
        claim <k>
            Chainlink updates the price of {token0} as {price};
            Attacker swap {token0} for Alpha:Int {token1} in OracleDex;
            Attacker deposits Alpha:Int {token1} to Lending;
            Attacker borrows Beta:Int {token0} from Lending;
            Attacker swap Beta:Int {token0} for {token1} in OracleDex;
            => . ...
        </k>
        <M> .Set => ?_ </M>
        <B> .List => ?_  </B>
        <Oracle> .Map => ?_  </Oracle>
        <S> (Dex in {token0}) |-> {reserve0} (Dex in {token1}) |-> {reserve1} => ?S:Map </S>
        requires (Alpha >Int 0) andBool (Beta >Int 0)
        ensures ?S[Attacker in {token1}] <Int 0
    endmodule
    """

def Patten2():
    BLANK_SPEC = """
    module BOUND
        imports LENDING
        claim <k>
            // Assume Attacker only have {token0}
            Attacker swap Alpha:Int {token0} for {token1} in OracleDex; 
            Attacker swap Alpha:Int {token0} for {token1} in OracleDex; // TWAP n=2
            Attacker deposits Beta:Int {token1} to Lending;
            Attacker borrows Gamma:Int {token0} from Lending;
            => . ...
        </k>
        <M> .Set => ?_ </M>
        <B> .List => ?_  </B>
        <P> .Map => ?_  </P>
        <Vault> .Map => ?_  </Vault>
        <Oracle> .Map => ?_  </Oracle>
        <CFactor> .Map => ?_  </CFactor>
        <S> (Dex in {token0}) |-> {reserve0} (Dex in {token1}) |-> {reserve1} => ?S:Map </S>
        requires (Alpha >Int 0) andBool (Beta >Int 0) andBool (Gamma >Int 0) andBool (Alpha <Int 10000000000000000000000)
        ensures ?S[Attacker in {token0}] <Int 0
    endmodule
    """

def Patten3():
    BLANK_SPEC = """
    module BOUND
        imports Mono
        claim <k>
            Attacker swap Alpha:Int {token0} for {token1} in Monoswap;
            Attacker swap Alpha:Int {token1} for {token0} in Monoswap;
            => . ...
        </k>
        <M> .Set => ?_ </M>
        <B> .List => ?_  </B>
        <P> .Map => ?_  </P>
        <Vault> .Map => ?_  </Vault>
        <Oracle> .Map => ?_  </Oracle>
        <CFactor> .Map => ?_  </CFactor>
        <S> .Map => ?S:Map </S>
        requires (Alpha >Int 0)
        ensures (?S[Attacker in {token0}] <Int 0) andBool (?S[Attacker in {token1}] <Int 0)
    endmodule
    """
