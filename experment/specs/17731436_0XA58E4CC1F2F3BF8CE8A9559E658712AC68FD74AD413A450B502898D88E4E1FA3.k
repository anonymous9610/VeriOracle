
module 17731436_0XA58E4CC1F2F3BF8CE8A9559E658712AC68FD74AD413A450B502898D88E4E1FA3
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
    <S> (UniDex in LUNA) |-> 612348779575 (UniDex in BUSD) |-> 139190714975984767702495 => ?S:Map </S>
    requires (Alpha >Int 0) andBool (Alpha <Int (612348779575 /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100))
    ensures {?S[Attacker in BUSD]}:>Int <Int 0
endmodule
