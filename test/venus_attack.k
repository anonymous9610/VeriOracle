module VENUS_ATTACK
    imports TOOL
    claim <k>
            Attacker in BUSD swaps Alpha:Int for LUNA output;
            Attacker deposits Alpha:Int LUNA to Venus;
            Attacker borrows Beta:Int BUSD from Venus;
        => . ...
     </k>
    <B> .List => ?_  </B>
    <Vault> .Map => ?_  </Vault>
    <Oracle> (Chainlink in LUNA) |-> 10736482 => ?_  </Oracle>
    <CFactor> (Venus in LUNA) |-> 55 => ?_  </CFactor>
    <S> (UniDex in LUNA) |-> 3372337286219 (UniDex in BUSD) |-> 104189822328757653088062 => ?S:Map </S>
    requires (Alpha >Int 0) andBool (Alpha <Int (3372337286219 /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int 10736482) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int 10736482) *Int 10000) *Int 55 /Int 100))
    ensures {?S[Attacker in BUSD]}:>Int >Int 0
endmodule
