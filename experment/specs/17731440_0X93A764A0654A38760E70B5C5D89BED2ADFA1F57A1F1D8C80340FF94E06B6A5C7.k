
module 17731440_0X93A764A0654A38760E70B5C5D89BED2ADFA1F57A1F1D8C80340FF94E06B6A5C7
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
    <S> (UniDex in LUNA) |-> 606371167670 (UniDex in BUSD) |-> 140581444916354518135896 => ?S:Map </S>
    requires (Alpha >Int 0) andBool (Alpha <Int (606371167670 /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100))
    ensures {?S[Attacker in BUSD]}:>Int <Int 0
endmodule
