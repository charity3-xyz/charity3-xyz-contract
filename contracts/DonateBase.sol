// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {
    ProjectState,
    CensorState
} from "./libraries/CharityEnums.sol";
import {
   Project,
   Donation,
   DonationParameters
} from "./libraries/CharityStructs.sol";

import {
    DonateInterface
} from "./interfaces/DonateInterface.sol";


import "./libraries/CharityConstants.sol";

import {ProjectBase} from "./ProjectBase.sol";


contract DonationBase is DonateInterface, ProjectBase  {

}