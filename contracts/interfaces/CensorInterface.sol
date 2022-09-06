// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {
    Censor,
    CensorParameters
} from "../libraries/CharityStructs.sol";

interface CensorInterface {

  /**
   提交成为节点的申请
   从项目方申请censor的牌照, 在合约里验证对应的参数
   验证通过生成Censor节点，生成censor节点为未激活状态
   */
  function applyForCensor(CensorParameters calldata parameters)
  external
  returns (bool success);


/**
 设定质押的上限
 1.调用该合约先判断当前地址是否有授权合约的额度
 如果有授权合约的额度,将amount值转到合约的账户
 找到sender地址对应的Censor将状态改为validate
 */
  function activateWithDeposit(uint256 amount)
  external
  returns (bool success);

/**
 提取押金
  1.是否censor 被仲裁
  2.是否censor 有未完成的项目
  判断是否lock
  取出之后判断余额是否满足deposit条件
 */
  function withdrawDeposit(uint256 amount) external 
  returns (bool success);


 function addDeposit(uint256 amount) external;

}