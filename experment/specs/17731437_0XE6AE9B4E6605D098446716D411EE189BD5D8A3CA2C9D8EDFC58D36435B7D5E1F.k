
module 17731437_0XE6AE9B4E6605D098446716D411EE189BD5D8A3CA2C9D8EDFC58D36435B7D5E1F
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
    <S> (UniDex in LUNA) |-> 613411390663 (UniDex in BUSD) |-> 138951257659833135207476 => ?S:Map </S>
    requires (Alpha >Int 0) andBool (Alpha <Int (613411390663 /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100))
    ensures {?S[Attacker in BUSD]}:>Int <Int 0
endmodule
