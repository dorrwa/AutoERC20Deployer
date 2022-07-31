// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tuli is ERC20,Ownable{
    constructor (uint256 initSply,address minteador,string memory name, string memory n) ERC20 (name,n){
        _mint(minteador,initSply);
        transferOwnership(minteador);
    }
}