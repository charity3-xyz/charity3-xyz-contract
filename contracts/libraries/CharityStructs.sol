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