// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {
    Censor,
    CensorParameters,
    Project
} from "../libraries/CharityStructs.sol";

interface ProjectInterface {


/*
 申领，将项目上链
 1. msg_sender 是不是有效censor
 2. 如果是有效censor 验证签名
 3. 签名验证成功创建project
 4. 创建项目默认该censor已经被认证成功
*/
 function claimProject(ProjectParameters parameters)external;


/**
 1. censor 才有验证的权利，
 2. 验证后，censor就加入了项目censor的数组中了
 3. 一个censor 能否在确认期修改自己的validation结果？
 4. 一个censor 是否能够退出,censor这个项目
 */
 function validateProject(uint256 projectId, bool validation) external;

}