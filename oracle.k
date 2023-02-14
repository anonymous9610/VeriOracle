require "execution.k"

module ORACLE-SYNTAX
    imports EXECUTION-SYNTAX
    syntax OracleTX ::= Address "updates the price of" Address "as" Int
        | Address "offers new price of" Address "as" Int
    syntax Transaction ::= OracleTX
    syntax Address ::= "Chainlink" | "USD" | "Uniswap"
endmodule

module ORACLE
    imports ORACLE-SYNTAX
    imports EXECUTION

// Blockchain Oracle
rule
    <k> exec(Oracle:Address and updates the price of ERC20Token:Address as Price:Int) => .K ... </k>
    <Oracle> O => O[(Oracle in ERC20Token) <- 、:Int] </Oracle> 
    <Block> ... .List => ListItem(Oracle updates the price of ERC20Token as Price) </Block>
    requires Price >=Int 10000000

// // Dex Oracle
// rule
//     <k> exec(Oracle:Address offers new price of ERC20Token:Address as _:Int) => .K ... </k>
//     <Oracle> O => O[(Oracle in ERC20Token) <- 0:Int] </Oracle> 

// rule
//     <k> exec(Oracle:Address offers new price of ERC20Token:Address as Price:Int) => .K ... </k>
//     <Oracle> ... (Oracle in ERC20Token) |-> (OldPrice => ((OldPrice +Int Price) /Int 2)) ... </Oracle> 
//     <B> ... .List => ListItem(Oracle offers new price of ERC20Token as Price) </B>

//    rule <k> Dex:Address GetPrice Token0:Address Token1:Address => .K ... </k>
//         <B> ... .List => ListItem(Dex GetPrice Token0 Token1) </B>
//         <S> ... (Dex in Token0) |-> Qty0 (Dex in Token1) |-> Qty1 ... </S>
//         <Oracle> Px => Px[(Token0 , Token1) <- (Qty1 /Int Qty0)][(Token1 , Token0) <- (Qty0 /Int Qty1)] </Oracle>


// // Internal Oracle
//    rule <k> MonoX:Address GetPrice Token0:Address Token1:Address delta:Int=> .K ... </k>
//         <B> ... .List => ListItem(MonoX GetPrice Token0 Token1) </B>
//         <S> ... (Dex in Token0) |-> Qty0 (Dex in Token1) |-> Qty1 ... </S>
//         <Oracle> Px => Px[(Token0 , Token1) |-> (OldPrice => (OldPrice *Int Qty1 / Int(Qty0 + Int delta)))][(Token1 , Token0) |-> (OldPrice => (OldPrice *Int Qty0 / Int(Qty1 - Int delta)))] </Oracle>

endmodule