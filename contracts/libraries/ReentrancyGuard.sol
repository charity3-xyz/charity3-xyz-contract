// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ReentrancyErrors } from "../interfaces/ReentrancyErrors.sol";
import "./CharityConstants.sol";



contract ReentrancyGuard is ReentrancyErrors {
    // Prevent reentrant calls on protected functions.
    uint256 private _reentrancyGuard;
    constructor() {
        _reentrancyGuard = _NOT_ENTERED;
    }

   
    function _setReentrancyGuard() internal {
        // Ensure that the reentrancy guard is not already set.
        _assertNonReentrant();

        // Set the reentrancy guard.
        _reentrancyGuard = _ENTERED;
    }

    function _clearReentrancyGuard() internal {
        // Clear the reentrancy guard.
        _reentrancyGuard = _NOT_ENTERED;
    }

    function _assertNonReentrant() internal view {
        // Ensure that the reentrancy guard is not currently set.
        if (_reentrancyGuard != _NOT_ENTERED) {
            revert NoReentrantCalls();
        }
    }
}