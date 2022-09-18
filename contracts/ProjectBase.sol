// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {
    ProjectState,
    CensorState
} from "./libraries/CharityEnums.sol";
import {
    Censor,
    CensorParameters,
    Project,
    ProjectParameters
} from "./libraries/CharityStructs.sol";

import {
    ProjectInterface
} from "./interfaces/ProjectInterface.sol";

import {
ProjectEventsAndErrors
} from "./interfaces/ProjectEventsAndErrors.sol";

import {
    CensorCore
}from "./Censor.sol";



import "./libraries/CharityConstants.sol";


//todo: 需要继承审核节点，操作censor的一些方法
contract ProjectBase is ProjectInterface, ProjectEventsAndErrors, CensorCore {
//查询查询查询project的结构体
 mapping(uint256 => Project) private idToProject;
 // project 所有的押金，做一个记账
 //通过链下的project序列号关联生成的Id
 mapping(uint256 => uint256) private projectSerialNumToId;

 uint256 private _projectIdGen = 0;


   constructor(address ERC20TokenAddress) CensorCore(ERC20TokenAddress){
       
   }

/*
 申领，将项目上链
 认证动作链下处理!!!!
 上链直接捐赠!!!!
 1. msg_sender 是不是有效censor
 2. 如果是有效censor 验证签名
 3. 签名验证成功创建project
 4. 创建项目默认该censor已经被认证成功
*/
    function claimProject(ProjectParameters calldata parameters)
    external validCensor {
     //todo 1生成parameters hash,并且validate 
     //todo 2. 项目抵押的amount没有校验
     uint256 projectNum = parameters.projectNum;
     if(projectSerialNumToId[projectNum] > 0){
        uint256 projectId = projectSerialNumToId[projectNum]; 
        Project storage _project = idToProject[projectId];
        if(block.timestamp > _project.censorDeadline){
            revert CensorTimeOut(); 
        } 
        //当前是可募捐状态
        require(_project.state == ProjectState.CENSORING, "Not At CENSORING");
        uint256 currentCensorId = getCensorId(msg.sender);
        require(currentCensorId > 0, "censor should register");
        require(getCensorId(currentCensorId) == uint(CensorState.VALIDATE),
        "censor should be validation");
        uint256 amount = parameters.depositAmount;
        uint256 totalDepositBalance = censorDepositBanlance(currentCensorId);
        //如果押金不足项目额度，就从账户转入一部分到押金中
        if(totalDepositBalance < amount){
            _addDepositToActiveCensor(currentCensorId, amount - totalDepositBalance);
        } 
        //扣除押金修改censor的状态
       _deductTotalDepositToProject(currentCensorId, amount); 
       //如果对项目还没有抵押，那么将censor增加到project的censor中
       if(censorDespositOnProject[currentCensorId][projectId] == 0){
          _project.censors.push(currentCensorId);
       }
       censorDespositOnProject[currentCensorId][projectId] += amount;
       censorProjectValidation[currentCensorId][projectId] = parameters.validation;
       emit BeCensorSuccess(projectId,currentCensorId);
     }else{
        // todo: 项目还没有上链，完成项目的上链
        // todo:要验证项目的签名, 签名合法则上链
        //审核截止日期
        uint256 censorDeadline = parameters.censorDeadline;
        //项目截止日期
        uint256 dealine = parameters.deadline;
        require(censorDeadline < dealine, 
        "censor dealine illegal");
        if(block.timestamp > censorDeadline){
            // censor 超时了
            revert CensorTimeOut();
        }
        uint256 currentCensorId = getCensorId(msg.sender);
        require(currentCensorId > 0, "censor should register");
        require(getCensorId(currentCensorId) == uint(CensorState.VALIDATE),
        "censor should be validation");
        //获取项目质押金
        uint256 amount = parameters.depositAmount;
        uint256 totalDepositBalance = censorDepositBanlance(currentCensorId);
        //如果押金不足项目额度，就从账户转入一部分到押金中
        if(totalDepositBalance < amount){
            _addDepositToActiveCensor(currentCensorId, amount - totalDepositBalance);
        } 
        //扣除押金修改censor的状态
       _deductTotalDepositToProject(currentCensorId, amount);
        //将project上链
      uint256[] memory censors = new address[]();
      censors.push(currentCensorId);
      uint256 projectId = _incrementProjectId();
       Project memory _project =  Project(
        projectId,
        parameters.fundingTarget,
        0,
        0,
        parameters.supervisorAddress,
        parameters.recipient,
        ProjectState.CENSORING,
        censors,
        1,
        parameters.deadline, 
        0,
        parameters.censorDeadline
     );
      //Project 信息上链
      idToProject[projectId] = _project;
      projectSerialNumToId[projectNum] = projectId;
      censorDespositOnProject[currentCensorId][projectId] += amount;
      censorProjectValidation[currentCensorId][projectId] = parameters.validation;
      emit ProjectCreateSuccess(projectNum,projectId,currentCensorId);
      emit BeCensorSuccess(projectId,currentCensorId);
     }
    //  uint censorLen = parameters.otherCensors.length + 1;
    //  address[] memory censors = new address[](censorLen);
    //  censors[0] = getCensorId(msg.sender); //初始项目方
    //  for(uint i = 1; i < censorLen; i++){
    //     address otherCensor = parameters.otherCensors[i-1];
    //      _validCensorAddress(otherCensor);
    //      censors[i] = getCensorId(otherCensor);
    //      //todo: 划转项目押金的额度，采用平均分配的策略
    //  }
    }


/**
 1. censor 才有验证的权利，
 2. 验证后，censor就加入了项目censor的数组中了
 3. 一个censor 能否在确认期修改自己的validation结果？
 4. 一个censor 是否能够退出,censor这个项目?
 */
 function validateProject(uint256 projectId, bool validation) external{

 }


// censor,CPO都可以打款给agent
function transferToAgent(uint256 projectId) 
 external
  returns (bool success){
    //todo: 判断是不是CPO地址
    //todo: 判断是否是当前的项目方地址
    // 将当前project的募集余额打款到project中
  } 


//todo: 获取项目所有censor的Id


//todo: 获取项目的抵押金总额

function _increaseProjectAmount(uint256 projectId, uint256 amount)
 internal
{
 Project storage donatingProject = idToProject[projectId];
 require(donatingProject.state != ProjectState.DONATING, 
 "Project is not on Donating");
 //todo: 根据recuritedAmount 进行判断,是否满额度了，如果额度满了调整项目到下一个状态
 donatingProject.recuritedAmount += amount;
 donatingProject.balance += amount;
 
}


function _incrementProjectId() internal returns (uint256 newCounter){
    unchecked {
        newCounter = ++_projectIdGen; 
    }
}

}

