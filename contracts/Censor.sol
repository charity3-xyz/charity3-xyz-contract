// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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
import {CensorEventsAndErrors} from "./interfaces/CensorEventsAndErrors.sol";
import {CharityAsset} from "./CharityAsset.sol";
import "./CharityAccessControl.sol";


contract CensorCore is
 CensorInterface, CharityAsset, CharityAccessControl,CensorEventsAndErrors {
    //存放id到censor的集合
    mapping(uint256 => Censor) internal idToCensor;
    mapping(address => uint256) private addressToCensorId;
    //
    mapping(uint256 => mapping(uint256 => uint256)) internal censorDespositOnProject;
    //项目的validation状态 
    mapping(uint256 => mapping(uint256 => bool)) internal censorProjectValidation;
    uint256 private _censorIdCounter = 0;
    uint256 private _DepositLimit = 10000; //todo: 押金的额度
    

   constructor(address ERC20TokenAddress) CharityAsset(ERC20TokenAddress){
      paused = true;
      ceoAddress = msg.sender;
      cpoAddress = msg.sender;
   } 




  function applyForCensor(CensorParameters calldata parameters)
  external
  override
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
        uint256(block.timestamp),
        CensorState.INVALIDATE
    );
    idToCensor[censorId] = _censor;
    addressToCensorId[msg.sender] = censorId;
    emit CensorRegisterSuccess(censorId,parameters.censorlicenseNum,msg.sender);
    success = true;
  }


 function activateWithDeposit(uint256 amount) 
 external 
 override
 validCensor 
  returns (bool success){
  require(amount > _DepositLimit, "amount should reach DepositLimit" );
  uint256 censorId = addressToCensorId[msg.sender];
  Censor storage _censor = idToCensor[censorId];
  require(_censor.state == CensorState.INVALIDATE,"Censor should be inActivated");
   //直接扣款，todo: 先查询授权更好
   _makeAllowanceFrom(_censor.censorAddress, amount); 
  _censor.depositBalance += amount;
  _censor.state = CensorState.VALIDATE;
  emit CensorDepositSuccess(censorId, msg.sender,_censor.depositBalance);
  success = true;
 }

 
  function withdrawDeposit(uint256 amount) 
  external 
  override
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
   emit withDrawDepositSuccess(censorId, msg.sender,amount);
   _clearReentrancyGuard();
  success = true;
  }


 function addDeposit(uint256 amount) 
 external
 override
 validCensor
 {
  uint256 censorId = addressToCensorId[msg.sender];
   _makeAllowanceFrom(msg.sender, amount);
   Censor storage censor = idToCensor[censorId];
   censor.depositBalance += amount;
   emit CensorAddDepositSuccess(censorId, 
   msg.sender, amount,censor.depositBalance);
   _activeCensor(censor);
 }



/**
 * 查询censor 节点当前的状态
 */
function getCensorState(uint256 censorId)
public 
view
returns (uint) 
{
  Censor storage censor = idToCensor[censorId];
  return uint(censor.state);
}

/**
 * 查询censor节点能否提前
 */
function canWithdraw(uint256 censorId)
public 
view
returns (bool){
    Censor storage _censor = idToCensor[censorId];
    return (_censor.processingNum == 0) &&(_censor.state != CensorState.LOCKED); 
}

/**
 * 根据 censor的地址查询censorId
 */

function getCensorId(address censor)
public 
view
returns (uint256)
{
   return addressToCensorId[censor]; 
}


/**
 * 根据censorId 查询censor质押的余额
 *
 */
function censorDepositBanlance(uint256 censorId)
public 
view
returns (uint256) 
{
    Censor storage censor = idToCensor[censorId];
     return censor.depositBalance;

}


function _activeCensor(Censor storage censor)
 internal 
 returns(bool) {
    if(censor.state == CensorState.VALIDATE){
     return true;
    }
    if((censor.depositBalance > _DepositLimit) && (censor.state == CensorState.INVALIDATE)){
      censor.state = CensorState.VALIDATE;    
      return true;
    } 
    return false;
   
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

function _validCensorAddress(address censorAddress) internal view {
    require(addressToCensorId[censorAddress] != 0, "Address is not Censor"); 
}

function _addDepositToActiveCensor(uint256 censorId, uint256 amount)
internal {
   Censor storage censor = idToCensor[censorId];
   _makeAllowanceFrom(censor.censorAddress, amount); 
   censor.depositBalance += amount;

}

function _deductTotalDepositToProject(uint256 censorId, uint256 amount)
internal {
    Censor storage censor = idToCensor[censorId]; 
    require(censor.state == CensorState.VALIDATE,"censor shouldValidate");
    require(censor.depositBalance >= amount, "totalDeposit insufficent");
    censor.depositBalance -= amount;
    if(censor.depositBalance < _DepositLimit){
        censor.state = CensorState.INVALIDATE;
    }
}

function _resumeProjectDepositToCensor(uint256 censorId, uint256 amount)
internal
{
   Censor storage censor = idToCensor[censorId];  
    censor.depositBalance += amount; 
    if(censor.state == CensorState.INVALIDATE && censor.depositBalance >= _DepositLimit){
        censor.state = CensorState.VALIDATE;
    }
}

//todo: 增加unlock方法

}