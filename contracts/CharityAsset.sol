// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {
    Censor,
    CensorParameters
} from "./libraries/CharityStructs.sol";
import "./libraries/CharityConstants.sol";
import {
   TransferHelper 
} from "./libraries/TransferHelper.sol";

import {CharityGettersAndDerivers} from "./CharityGettersAndDerivers.sol";

//处理
contract CharityAsset is CharityGettersAndDerivers{

    address internal immutable _ERC20TokenAddress;
    constructor(address ercTokenAddress)
    CharityGettersAndDerivers(){
       _ERC20TokenAddress = ercTokenAddress;
    }



//从给定的sender中（需要sender授权给contract地址) 扣除amount 给到contract
function _makeAllowanceFrom(address sender, uint256 amount)
  internal
 {
   TransferHelper.withhold(_ERC20TokenAddress, sender, address(this), amount);
}

//查询charity合约所有代币的余额
function _banlanceOfCharity() internal returns (uint256 balance) {
      balance = TransferHelper.banlanceOf(_ERC20TokenAddress, address(this));
}

//查询sender授权给Charity的余额
function _allowanceOfSenderForCharity(address sender) internal returns(uint256 balance){
    balance = TransferHelper.allowanceOf(_ERC20TokenAddress, sender, address(this));
} 

//从合约转款到recipient,如提取押金,分发分红奖励等
function _transferToRecipient(address recipient, uint256 amount) internal {
     TransferHelper.safeTransfer(_ERC20TokenAddress,recipient , amount);
}

}