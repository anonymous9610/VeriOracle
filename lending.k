require "oracle.k"

module LENDING-SYNTAX
    imports EXECUTION-SYNTAX
    imports ORACLE-SYNTAX
    syntax LENDINGTX ::= Address "deposits" Int Address "to" Address
       | Address "borrows" Int Address "from" Address
    syntax Transaction ::= LENDINGTX 
    syntax Address ::= "LUNA" | "Venus" | "BUSD"
endmodule

module LENDING
    imports LENDING-SYNTAX
    imports ORACLE


// deposit collateral to Vault
rule
    <k> exec(User:Address deposits Amount:Int ERC20Token:Address to Vault:Address) =>
        User in ERC20Token gives Amount ~>
        Vault in ERC20Token gets Amount
    ... </k>
    // <Oracle> O => O[(Chainlink in ERC20Token) <- ?Price:Int] </Oracle>
    <Block> ... .List => ListItem(User deposits Amount ERC20Token to Vault) </Block>

// borrow
rule
     <k> exec(User:Address borrows Amount:Int ERC20Token:Address from Vault:Address) => 
        User in ERC20Token gets Amount ~>
        Vault in ERC20Token gives Amount ~>
     ... </k>
     <Block> ... .List => ListItem(User borrows Amount ERC20Token from Vault) </Block>
     requires ((TotalCollateral - Amount) >Int 0) andBool (Amount >Int 0)
endmodule