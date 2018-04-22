pragma solidity ^0.4.0;

contract Factorial
{
    address public owner; // 合约创建者
    uint public jc = 0;
    function factorial(uint n) returns(uint)
    {
        if(n == 0 || n == 1)
        {
            return 1;
        }
        else
        {
            jc = n *factorial(n - 1);
            return jc;
        }
    }
}