require "execution.k"

module AMMDEX-SYNTAX
    imports EXECUTION-SYNTAX

    syntax AmmDexTx ::= EVMAddress "in" EVMAddress "swaps" Int "input" "for" EVMAddress
                       | EVMAddress "in" EVMAddress "swaps" Int "for" EVMAddress "output"
                       | EVMAddress "adds" Int "tokens and" Int "eth of liquidity to" EVMAddress
                       | EVMAddress "removes" Int "tokens and" Int "eth of liquidity from" EVMAddress
    syntax EVMTransaction ::= AmmDexTx
    syntax EVMAddress ::= "UniDex"
    // syntax CurrencyPair ::= EVMAddress "," EVMAddress
    // syntax InternalCmd ::= "GetPrice" EVMAddress EVMAddress // Oracle query
    // syntax Statement ::= InternalCmd
endmodule

module AMMDEX
    imports AMMDEX-SYNTAX
    imports EXECUTION

    rule <k> exec(Address:EVMAddress in TokenIn:EVMAddress swaps TradeAmount:Int input for TokenOut:EVMAddress)  => 
            Address in TokenIn gets 0 -Int TradeAmount ~>
            Address in TokenOut gets (997 *Int TradeAmount *Int USwapBalanceOut) /Int (1000 *Int USwapBalanceIn +Int 997 *Int TradeAmount) ~>
            UniDex in TokenIn gets TradeAmount ~>
            UniDex in TokenOut gets 0 -Int (997 *Int TradeAmount *Int USwapBalanceOut) /Int (1000 *Int USwapBalanceIn +Int 997 *Int TradeAmount)
            ...
         </k> 
         <S> ... (UniDex in TokenOut) |-> USwapBalanceOut (UniDex in TokenIn) |-> USwapBalanceIn ... </S> 
         <B> ... .List => ListItem(Address in TokenIn swaps TradeAmount input for TokenOut) </B>
            // requires (UserBalance >=Int TradeAmount) 

    rule <k> exec(Address:EVMAddress in TokenIn:EVMAddress swaps TradeAmount:Int for TokenOut:EVMAddress output)  => 
            Address in TokenIn gets 0 -Int ((1000 *Int USwapBalanceIn *Int TradeAmount) /Int (997 *Int (USwapBalanceOut -Int TradeAmount)) +Int 1) ~>
            Address in TokenOut gets TradeAmount ~>
            UniDex in TokenIn gets ((1000 *Int USwapBalanceIn *Int TradeAmount) /Int (997 *Int (USwapBalanceOut -Int TradeAmount)) +Int 1) ~>
            UniDex in TokenOut gets 0 -Int TradeAmount
            ...
         </k> 
         <S> ... (UniDex in TokenOut) |-> USwapBalanceOut (UniDex in TokenIn) |-> USwapBalanceIn ... </S> 
         <B> ... .List => ListItem(Address in TokenIn swaps TradeAmount for TokenOut output) </B>
            // requires (UserBalance >=Int TradeAmount) 

    // todo accurate pricing rules
    // todo fees
    rule <k> exec(LiquidityProvider:EVMAddress adds TokenAmount:Int tokens and ETHAmount:Int eth of liquidity to ERC20Token:EVMAddress)  => 
             UniDex in ERC20Token gets TokenAmount ~> UniDex in 0 gets ETHAmount
             ...
         </k>
         <B> ... .List => ListItem(LiquidityProvider adds TokenAmount tokens and ETHAmount eth of liquidity to ERC20Token) </B>

    rule <k> exec(LiquidityProvider:EVMAddress removes TokenAmount:Int tokens and ETHAmount:Int eth of liquidity from ERC20Token:EVMAddress)  => 
             UniDex in ERC20Token gets 0 -Int TokenAmount ~> UniDex in 0 gets 0 -Int ETHAmount 
            ...
         </k>
         <B> ... .List => ListItem(LiquidityProvider removes TokenAmount tokens and ETHAmount eth of liquidity from ERC20Token) </B>
endmodule