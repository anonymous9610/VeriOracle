module EXECUTION-SYNTAX
    imports DOMAINS-SYNTAX
    syntax Transaction ::= Transaction "fee" Int
        | Transaction "block" Int
    syntax StateEntry ::= Address "in" Address
    syntax Statement ::= Address "in" Address "gets" Int 
        | Address "in" Address "gives" Int
        | Transaction     
        | "DONE" | "FAIL"
        | "exec(" Transaction ")"
    syntax Block ::= Statement ";"
        | Block Statement ";"
    syntax Address ::= Int | "ETH" | "Attacker"
endmodule

module EXECUTION
    imports EXECUTION-SYNTAX
    imports DOMAINS

configuration
    <k> $PGM:Block </k> // Instructions left to execute
    <Block> .List </Block> // List of Block
    <State> .Map </State> // System state; mapping of all (Address in Token) to Balance (all type Integer)
    <Oracle> .Map </Oracle> // Mapping of all (Address in Token) to Price (all type Integer)

    rule <k> Address:Address in Token:Address gets _:Int ... </k>
         <State> B => B[(Address in Token) <- 0:Int] </State> 
         requires notBool((Address in Token) in keys(B))

    rule <k> Address:Address in Token:Address gets Amount:Int => .K ... </k>
         <State> ... (Address in Token) |-> (OldBalance => (Amount +Int OldBalance)) ... </State> 
         requires (Amount >=Int (0 -Int OldBalance))

    rule <k> Address:Address in Token:Address gives Amount:Int => Address in Token gets (0 -Int Amount) ... </k>

    rule <k> TX:Transaction => exec(TX) ... </k>

    rule <k> B:Block S:Statement; => B ~> S ... </k>
    rule <k> S:Statement; => S ... </k>

    rule <k> .K => DONE </k>

endmodule
