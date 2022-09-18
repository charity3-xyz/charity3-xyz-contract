// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {
    ProjectState,
    CensorState
} from "./libraries/CharityEnums.sol";
import {
   Project,
   Donation,
   DonationParameters
} from "./libraries/CharityStructs.sol";

import {
    DonateInterface
} from "./interfaces/DonateInterface.sol";


import "./libraries/CharityConstants.sol";

import {ProjectBase} from "./ProjectBase.sol";
import {DonationEventsAndErrors} from "./interfaces/DonateEventsAndErrors.sol";

contract DonationBase is DonateInterface, DonationEventsAndErrors, ProjectBase  {

  mapping(uint256 => Donation) private idToDonationMap;
  uint256 private _donationIdCounter = 0;

  constructor(address ERC20TokenAddress) ProjectBase(ERC20TokenAddress){}
   function donating(uint256 projectId, uint256 amount)
    external {
        //获取账户的授权数量
      uint256 allowanceOfSender =  _allowanceOfSenderForCharity(msg.sender); 
      if(amount > allowanceOfSender){
        // Revert 是因为代币授权额度不够
        revert DonatorInsufficientApprove(
            msg.sender,
            allowanceOfSender,
            amount
        );
      }
      uint256 accountBalance = _tokenBanlanceOfAddress(msg.sender);
      if (amount > accountBalance){
        // Revert 是因为代币账户的余额不够
        revert DonatorInsufficientBalance(
            msg.sender,
            accountBalance,
            amount
        ); 
      }
      Project storage donatingProject = idToProject[projectId];
      if(donatingProject.state != ProjectState.DONATING){
        // Revert 项目不可募捐(可能因为项目不存在||项目被冻结或者以完成)
        revert InvalidateProject(projectId);
      }
      // 合约从sender账户中进行划转
      _makeAllowanceFrom(msg.sender, amount);
      _increaseProjectAmount(projectId, amount);
      uint256 serialNum = _incrementDonationSerialNum(); 
      Donation memory _donation = Donation(
        serialNum,
        projectId,
        amount
      );
      idToDonationMap[serialNum] = _donation;
      //捐赠成功事件
      emit DonationComplete(msg.sender, serialNum, projectId, amount);
    }

    function _incrementDonationSerialNum() internal returns (uint256 newCounter) {
    unchecked {
         newCounter = ++ _donationIdCounter;
    }
}

}