// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
/// 用于ERC-20的transfer的便捷方法
library TransferHelper {
   function safeTransfer (
     address token,
     address to,
     uint256 value
   )internal {
    (bool success, bytes memory data) = 
     token.call(abi.encodeWithSelector(IERC20.transfer.selector,to,value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFailed");
   }
}