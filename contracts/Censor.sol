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

import "./CharityAsset.sol";
import "./CharityAccessControl.sol";

contract Censor is CensorInterface, CharityAsset, CharityAccessControl {
    //存放id到censor的几何
    mapping(uint256 => Censor) private idToCensor;
    mapping(address => uint256) private addressToCensorId;
    uint256 private _censorIdCounter = 0;
    uint256 private _DepositLimit; //todo: 押金的额度

   constructor(address ERC20TokenAddress) CharityAsset(ERC20TokenAddress){
      paused = true;
      ceoAddress = msg.sender;
      cpoAddress = msg.sender;
   } 




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


 function activateWithDeposit(uint256 amount) 
 external 
 validCensor 
  returns (bool success){
  require(amount > _DepositLimit, "amount should reach DepositLimit" );
  uint256 censorId = addressToCensorId[msg.sender];
  Censor storage _censor = idToCensor[censorId];
  require(_censor.state == CensorState.INVALIDATE,"Censor should be inActivated");
   _makeAllowanceFrom(_censor.censorAddress, amount); 
  _censor.depositBalance += amount;
  _censor.state = CensorState.VALIDATE;
  //todo: 发送质押成功事件
  success = true;
 }

 
  function withdrawDeposit(uint256 amount) 
  external 
  validCensor 
  returns (bool success){
  _setReentrancyGuard();
  uint256 censorId = addressToCensorId[msg.sender];
  Censor storage _censor = idToCensor[censorId];
  require((_censor.processingNum == 0) &&(_censor.state != CensorState.LOCKED), "Censor cannot withdraw");
  require(_censor.depositBalance >= amount,"Deposit withDraw overflow");
  _transferToRecipient(_censor.censorAddress, amount);
  _censor.depositBalance -= amount;
  if((_censor.depositBalance < _DepositLimit) && (_censor.state == CensorState.VALIDATE)){
     _censor.state = CensorState.INVALIDATE; 
  }
   _clearReentrancyGuard();
  success = true;
  }


 function addDeposit(uint256 amount) 
 external
 validCensor
 {
  uint256 censorId = addressToCensorId[msg.sender];
   _makeAllowanceFrom(msg.sender, amount);
   Censor storage censor = idToCensor[censorId];
   censor.depositBalance += amount;
   //todo:event, 押金充值成功
   _activeCensor(censor);
 }


//todo: 增加判断是否能够withdraw的条件
//todo: 判断当前余额
//todo: 增加根据地址查询censorId

function getCensorState(uint256 censorId)
external
view
returns (uint) 
{
  Censor storage censor = idToCensor[censorId];
  return uint(censor.state);
}

function canWithDraw(uint256 censorId)
external
view
returns (bool){
    Censor storage _censor = idToCensor[censorId];
    return (_censor.processingNum == 0) &&(_censor.state != CensorState.LOCKED); 
}

function getCensorId()
external
view
returns (uint256)
{
   return addressToCensorId[msg.sender]; 
}

function censorDepositBanlance(uint256 censorId)
external
view
returns (uint256) 
{
    Censor storage censor = idToCensor[censorId];
     return censor.depositBalance;

}


function _activeCensor(Censor storage censor) internal returns(bool isactive){
    if((censor.depositBalance > _DepositLimit) && (censor.state == CensorState.INVALIDATE)){
      censor.state = CensorState.VALIDATE;    
    } 
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