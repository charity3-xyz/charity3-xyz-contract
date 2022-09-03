// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {
    Censor,
    CensorParameters
} from "../libraries/CharityStructs.sol";


interface DonateInterface {


function donating(uint256 projectId, uint256 amount) external ;

}