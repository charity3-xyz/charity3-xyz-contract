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
  uint256 censorId = addressToCensorId[msg.sender];
  require(censorId != 0, "msgSender should be Censor");
  Censor storage censor = idToCensor[censorId];
  require(censor.state == CensorState.INVALIDATE,"Censor should be inActivated");
  //todo:1. 统一判断是否有代币转账的额度
  //todo:2. 统一调用safeTransfer的转账
  

  censor.state = CensorState.VALIDATE;
  //todo: 发送质押成功事件
  success = true;
 }

 
  function withdrawDeposit(uint256 amount) external 
  returns (bool success){
  uint256 censorId = addressToCensorId[msg.sender];
  require(censorId != 0, "msgSender should be Censor");

  Censor storage censor = idToCensor[censorId];
  require((censor.processingNum == 0) &&(censor.state != CensorState.LOCKED), "Censor cannot withdraw");

    success = true;
  }


 function addDeposit(uint256 amount) external{
  uint256 censorId = addressToCensorId[msg.sender];
  require(censorId != 0, "msgSender should be Censor"); 
   //todo:1. 统一判断是否有代币转账的额度
  //todo:2. 统一调用safeTransfer的转账
   Censor storage censor = idToCensor[censorId];
   censor.depositBalance += amount;
   //todo:event, 押金充值成功
   _activeCensor(censor);
 }


//todo: 增加判断是否能够withdraw的条件
//todo: 判断当前余额
//todo: 增加根据地址查询censorId



function _activeCensor(Censor storage censor) internal returns(bool isactive){
    //todo: 判断censor的押金是否达到目标，节点是否达到激活态
    isactive = true;
}

//
function _incrementCensorId() internal returns (uint256 newCounter) {
    unchecked {
         newCounter = ++ _censorIdCounter;
    }
}

//保证是censor的操作
modifier validCensor (){
    require(addressToCensorId[msg.sender] != 0, "msgSender should be Censor");  
    _;
}

function validCensorAddress(address censorAddress) internal {
    require(addressToCensorId[censorAddress] != 0, "Address is not Censor"); 
}

function getCensorId(address censorId)
 external
view  
returns(uint censorId){
  return addressToCensorId[censorId];
}

}