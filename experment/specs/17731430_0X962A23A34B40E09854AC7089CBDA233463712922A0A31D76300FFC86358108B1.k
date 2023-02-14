
module 17731430_0X962A23A34B40E09854AC7089CBDA233463712922A0A31D76300FFC86358108B1
    imports TOOL
    claim <k>
            Attacker in BUSD swaps Alpha:Int for LUNA output;
            Attacker deposits Alpha:Int LUNA to Venus;
            Attacker borrows Beta:Int BUSD from Venus;
        => . ...
     </k>
    <B> .List => ?_  </B>
    <Vault> .Map => ?_  </Vault>
    <Oracle> (Chainlink in LUNA) |-> 28365500 => ?_  </Oracle>
    <CFactor> (Venus in LUNA) |-> 55 => ?_  </CFactor>
    <S> (UniDex in LUNA) |-> 607839671743 (UniDex in BUSD) |-> 140183252859922639882897 => ?S:Map </S>
    requires (Alpha >Int 0) andBool (Alpha <Int (607839671743 /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100))
    ensures {?S[Attacker in BUSD]}:>Int <Int 0
endmodule
