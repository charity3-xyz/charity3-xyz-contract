// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {
    Censor,
    CensorParameters
} from "../libraries/CharityStructs.sol";

interface CensorEventsAndErrors {

//censor 注册成功
event CensorRegisterSuccess(
    uint256 censorId,
    uint256 licenseNumber,
    address indexed censorAddress
);

//censor 激活成功
event CensorDepositSuccess(
    uint256 censorId,
    address indexed censorAddress,
    uint256 depositAmount
);

event withDrawDepositSuccess(
    uint256 censorId,
    address indexed censorAddress,
    uint256 amount
);

event CensorAddDepositSuccess(
    uint256 censorId,
    address indexed censorAddress,
    uint256 amount,
    uint256 depositBalance
);

//censor 签名校验失败
error CensorSignatureValidateFaild(CensorParameters parameters);

}