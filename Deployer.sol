// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./erc20owned.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Creador is Ownable{
    constructor(uint256 _price, address tokenACobrar,address _myWallet)
    {
        price=_price*10**18;
        token=IERC20(tokenACobrar);
        myWallet=_myWallet;
    }
    uint256 price;
    event Deployed (address contrato, address duenio, uint256 supply);
    IERC20 token;
    address myWallet;
    function setPrice(uint256 newPrice)public onlyOwner{//el price va en entero y dsps le agrega los decimales solo
        price=newPrice*10**18;
    }
    function setMyWallet(address newWallet)public onlyOwner{//aca vas a setear la wallet donde vos quieras cobrar
        myWallet=newWallet; 
    }
     /* Get the allowance of the msg sender, this is used to charge in busd */
    function getAllowance() public view returns(uint256){
       return token.allowance(msg.sender, address(this));
    }
    /* Set new Interface for the IERC token */
    function stableInterface(address newStable) public onlyOwner{
        token = IERC20(newStable); //Aca agregamos una stable de 18 decimales osea todo lo que cobres lo tenes que hacer *10**18 supongamos 
                                    //que queres cobrar en busd va a ser el price*10**18 y vas a tener que pedir desde el front un approve
    }                               //que te permita gastar el price*10**18 a tu contrato
    /* Verify the token payment */
    function acceptPayment(uint256 _tokenamount, address _to) internal returns(bool) {
       token.transferFrom(msg.sender, _to, _tokenamount);
       return true;
    }
    function crearERC20(uint256 sup,string memory name, string memory n) public payable{ 
        //require(msg.value>1,"Paga GIL");
        Tuli clientToken = new Tuli(sup,msg.sender,name,n);
        require(true == acceptPayment(price,myWallet),"Failed transaction busd"); //aca vas a transferirte a tu wallet, proba poniendo no se el addres 3 de remix
        emit Deployed(address(clientToken),msg.sender,sup);
    }
    function checkBalance(address tkn, address persona)public view returns(uint256){
        return(IERC20(tkn).balanceOf(persona));
    }
}