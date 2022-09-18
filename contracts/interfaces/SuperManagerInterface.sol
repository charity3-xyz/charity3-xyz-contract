// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {HospitalParameters} from "../libraries/CharityStructs.sol";

interface SuperManagerInterface {
    /**
    添加 hospital 医院
    1、钱包地址
    2、国家
    3、医院名称
    4、等级
   */
    function addHospital(HospitalParameters calldata parameters) external returns (bool success);
}
