// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {
    Censor,
    CensorParameters,
    Donation,
    DonationParameters
} from "../libraries/CharityStructs.sol";


interface DonationEventsAndErrors {

//捐赠成功的事件
event DonationComplete(
    address indexed donationAddress,
    uint256 serialNumber,
    uint256 projectId,
    uint256 amount
);

//捐赠者余额不足
error DonatorInsufficientBalance(
    address donationAddress, //捐赠者地址
    uint256 amount, //捐赠的数量
    uint256 banlance //代币账户的余额
 );

error DonatorNotApprove(
    address token, //接受捐赠的代币地址
    address donationAddress //捐赠者地址
);

error DonatorInsufficientApprove(
    address donationAddress,
    uint256 approveBalance, //授权的余额
    uint256 amount //捐赠的额度
 );


}