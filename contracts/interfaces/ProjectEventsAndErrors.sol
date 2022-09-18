// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {
    Project,
    ProjectParameters
} from "../libraries/CharityStructs.sol";

interface ProjectEventsAndErrors {

//Project 创建成功
event ProjectCreateSuccess(
    uint256 projectNum,
    uint256 projectId,
    uint256 censorId
);

event BeCensorSuccess(
    uint256 projectId,
    uint256 censorId 
);

// 不能再成为节点了
error CensorTimeOut();





}