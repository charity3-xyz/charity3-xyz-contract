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
    uint256 projectId
);

// 不能再成为节点了
error CensorTimeOut();





}