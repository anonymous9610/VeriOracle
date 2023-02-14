
module 17731439_0X8E24F5BBE416FC63657379E52FB977C95EEFAB9C90E13C88DD57FFEC7D6D5438
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
    <S> (UniDex in LUNA) |-> 603893511236 (UniDex in BUSD) |-> 141155197016316507880504 => ?S:Map </S>
    requires (Alpha >Int 0) andBool (Alpha <Int (603893511236 /Int 10)) 
        andBool (Beta >=Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100 *Int 8 /Int 10)) 
        andBool (Beta <Int (((Alpha *Int 28365500) *Int 10000) *Int 55 /Int 100))
    ensures {?S[Attacker in BUSD]}:>Int <Int 0
endmodule
