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
    CensorCore
}from "./Censor.sol";

import "./libraries/CharityConstants.sol";


//todo: 需要继承审核节点，操作censor的一些方法
contract ProjectBase is ProjectInterface, CensorCore {
//查询查询查询project的结构体
 mapping(uint256 => Project) private idToProject;
 mapping(uint256 => uint256) private projectDeposit;

 uint256 private _projectIdGen = 0;
/*
 申领，将项目上链
 认证动作链下处理!!!!
 上链直接捐赠!!!!
 1. msg_sender 是不是有效censor
 2. 如果是有效censor 验证签名
 3. 签名验证成功创建project
 4. 创建项目默认该censor已经被认证成功
*/
    function claimProject(ProjectParameters parameters)
    external validCensor {
     //todo 1生成parameters hash
     //todo 项目时间有效性的校验
     //todo 调用validate校验
     //todo 校验失败发送 Error 事件

     uint censorLen = parameters.otherCensors.length + 1;
     address[] memory censors = new address[](censorLen);
     censors[0] = getCensorId(msg.sender); //初始项目方
     for(uint i = 1; i < censorLen; i++){
        address otherCensor = parameters.otherCensors[i-1];
         validCensorAddress(otherCensor);
         censors[i] = getCensorId(otherCensor);
         //todo: 划转项目押金的额度，采用平均分配的策略
     }
     uint256 projectId = ++ _projectIdGen;
     Project memory _project =  Project(
        projectId,
        parameters.fundingTarget,
        0,
        0,
        parameters.supervisorAddress,
        parameters.recipient,
        ProjectState.DONATING,
        censors,
        uint256(censorLen),
        parameters.deadline, 
        0
     );
     idToProject[projectId] = _project;
    //todo event 上链成功
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


}

