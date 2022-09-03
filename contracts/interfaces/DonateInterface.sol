// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {
    Censor,
    CensorParameters
} from "../libraries/CharityStructs.sol";


interface DonateInterface {


// 1.代币合约是被否授权给donating
// 2.转账是否成功
// 3.生成donateId，与porjectId关联
// 4.project状态必须是Donating的时候才能
function donating(uint256 projectId, uint256 amount) external ;

}