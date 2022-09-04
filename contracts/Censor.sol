// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {
    ProjectState,
    CensorState
} from "./libraries/CharityEnums.sol";
import {
    Censor,
    CensorParameters
} from "./libraries/CharityStructs.sol";

import {
    CensorInterface
} from "./interfaces/CensorInterface.sol";

import "./libraries/CharityConstants.sol";
//编写censor逻辑的合约


contract Censor is CensorInterface {
    //存放id到censor的几何
    mapping(uint256 => Censor) private idToCensor;
    mapping(address => uint256) private addressToCensorId;
    uint256 private _censorIdCounter = 0;

  function applyForCensor(CensorParameters calldata parameters)
  external
  returns (bool success){
    require(msg.sender == parameters.recipient, "Censor Address Consistent");
    require(addressToCensorId[parameters.recipient] == 0 ,"Censor Address repeated");
    //todo: verifaction hash, hash 通过之后上链
    uint256 censorId = _incrementCensorId();
    Censor memory _censor = Censor(
        censorId,
        msg.sender,
        0,
        0,
        uint256(now),
        CensorState.INVALIDATE
    );
    idToCensor[censorId] = _censor;
    addressToCensorId[msg.sender] = censorId;
    //todo: 发送创建成功的事件
    success = true;
  }


 function activateWithDeposit(amount) external returns (bool success){
 

  success = true;
 }



//
function _incrementCensorId() internal returns (uint256 newCounter) {
    unchecked {
         newCounter = ++ _censorIdCounter;
    }
}



}