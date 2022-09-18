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
import {DonationEventsAndErrors} from "./interfaces/DonateEventsAndErrors.sol";

contract DonationBase is DonateInterface, ProjectBase  {


   function donating(uint256 projectId, uint256 amount)
    external {

    }
}