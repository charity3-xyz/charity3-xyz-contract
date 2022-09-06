// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {
    ProjectState,
    CensorState
} from "./CharityEnums.sol";


struct Censor {
    uint256 censorId; //生成censor的Id
    address censorAddress; //censor的受益与转账地址
    uint256  depositBalance; //质押的余额(质押每个项目都会先抵押一部分，如果出问题就punish了，如果没出问题结项了返还)
    uint256  processingNum; //当前正在处理未结项审查的数据
    uint256  startTime; // 注册censor的时间
    CensorState state;
}


//仲裁的请求，对一个项目发起仲裁，中心化服务器会进行签名，然后仲裁者用此次签名去验证
struct ArbitrationReq {
   uint256 arbitratorId; //todo:是否需要 仲裁的Id,知道项目由谁进行仲裁的
   uint256 projectId; // 仲裁哪个项目的Id
   uint256 deadlineTime;//仲裁截止时间
}

struct Project {
    uint256 projectId; //项目的地址
    uint256 fundingTarget; //募捐的目标
    uint256 recuritedAmount; //已经募集的额度 
    uint256 balance; //当前项目的余额
    address supervisorAddress; //指定的管理员地址
    address agentAddress;//打款的代理地址
    ProjectState state; //项目的状态
    uint256[] censors; //参与项目审核的节点
    uint256 totalCensors;//有多少censor节点参与项目
    uint256 deadline; //项目的deadline
    uint numOfDonates;//项目有几笔捐赠构成
    //todo: 新增结构
}

// 表示Donation的Parameters
struct Donation {
     uint256 donationId; //捐赠的项目编号
     uint256 projectId; //捐赠项目的Id
     uint256 amount; //捐赠额度
}

struct DonationParameters{
     uint256 projectId; //捐赠项目的Id
     uint256 amount; //捐赠额度 
}

// censor 申请的时候需要提供项目方颁发的签名的信息,会使用EIP712去来校验
/** 签名的结构体格式:
{name:"",
 version:"",
 chainId:"",
 verifyingContract:"",
 censor:{
    recipient:"初始化的地址",
    licenceNum:"颁发的licence号码"
 }
}
 */
struct CensorParameters {
     uint256 censorlicenseNum;//censor的
     address recipient;
     bytes signature; //生成的数字签名用户校验

}

// 使用签名，需要使用项目指定的supervisor
// censor 可以转账，转到项目方
// supervisor 不转账，censor都被Lock可以取消项目
/** 签名的格式 
{
 name:"",
 version:"",
 chainId:"",
 verifyingContract:"",
 projectMeta:{
    projectNum:"项目的流水号"
    supervisor:"address"   
    fundingTarget:"募集的目标"
    deadlineTime: "募集截止日期"
    recipient:"项目受益人",
    "otherCensors":[xxx,xxx,xxxx],
 }

}
*/
struct ProjectParameters{
     uint256 projectNum;
     address supervisorAddress;
     uint256 fundingTarget;
     uint256 deadline; 
     address recipient;
     uint256 depositAmount; //项目质押金额
     address[] otherCensors;
     bytes signature;
}


//  申请的时候需要提供项目方颁发的签名的信息,会使用EIP712去来校验
/** 签名的结构体格式:
{name:"",
 version:"",
 chainId:"",
 verifyingContract:"",
 committee:{
    recipient:"初始化的地址",
    licenceNum:"颁发的licence号码",
    deadline:"有效期"
 }
}
 */

struct CommitteeParameters {
    uint256 licenseNum;//cmmitte licenseNum;
     bytes signature; //生成的数字签名用户校验
}

//用于Censor签名的结构体
struct CensorItem {
    address recipient;
    uint256 licenseNum; 
}
struct CommitteeItem{
    address recipient;
    uint256 licenseNum;  
    uint256 deadline;
}



