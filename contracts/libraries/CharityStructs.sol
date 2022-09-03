// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {
    ProjectState,
    CensorState
} from "./CharityEnums.sol";


struct Censor {
    uint256 censorId; //生成censor的Id
    address censorAddress; //censor的受益与转账地址
    uint  depositBalance; //质押的余额
    uint  processingNum; //当前正在处理未结项审查的数据
    CensorState state;
}


//仲裁的请求，对一个项目发起仲裁，中心化服务器会进行签名，然后仲裁者用此次签名去验证
struct ArbitrationReq {
   uint256 arbitratorId; // 仲裁的Id,知道项目由谁进行仲裁的
   address validateAddress; //签发的地址，验证的时候判断sender的地址是否是validateAddress
   uint256 projectId; // 仲裁哪个项目的Id
   uint256 deadlineTime;//仲裁截止时间
   bytes32 requestHash;
   bytes  signature;
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
    uint256 censorsCursor;//项目审核节点的游标
    uint256 deadline; //项目的deadline
    uint numOfDonates;//项目有几笔捐赠构成
    //todo: 新增结构
}

// 表示Donation的Parameters
struct DonationParameters {
     uint256 donationId; //捐赠的项目编号
     uint256 projectId; //捐赠项目的Id
     uint256 amount; //捐赠额度
}

// censor 申请的时候需要提供项目方颁发的签名的信息,会使用EIP712去来校验
/** 签名的结构体格式:
{name:"",
 version:"",
 chainId:"",
 verifyingContract:"",
 Censor:{
    authorization:"初始化的地址",
    licenceNum:"颁发的licence号码"
 }
}
 */
struct CensorParameters {
     address censorAddress;
     uint256 censorlicenseNum;
     bytes32 censorHash;//由项目方颁发的签名
     bytes signature; //生成的数字签名用户校验

}

