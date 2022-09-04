// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {
    Censor,
    CensorParameters,
    ArbitrationReq,
    CommitteeParameters
} from "../libraries/CharityStructs.sol";


interface ArbitrationInterface {

/***
 1.仲裁需要达到质押的标准??
 2.如果仲裁申请有效，将censor罚款+抵押款给申请地址
 3.申请失败，需要罚一些amount
 */
 function requestArbitration(ArbitrationReq parameters, uint256 amount)
 external returns (bool success);

/***
 维护一个仲裁委员会的 Array,
 */
 function applyForArbitrationCommittee(CommitteeParameters parameters)
  external;

/**
 发起仲裁者结项&
 或者censor结项+
 CPO结项达到项目deadline的时候结项
 仲裁没结束，超时前不允许结项
 */
function voteForArbitration(uint256 projectId, bool ticket) external;





function voteResult()external view returns(bool ret);

}