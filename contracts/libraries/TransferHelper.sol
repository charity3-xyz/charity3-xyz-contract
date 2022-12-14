// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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

   function banlanceOf(
    address token,
    address target
   )internal view returns ( uint256 balance) {
       (bool success, bytes memory data) = 
       token.staticcall(abi.encodeWithSelector(IERC20.balanceOf.selector, target));
       require(success && data.length >= 32,"Call banlence failed");
       return abi.decode(data, (uint256));
   }
   function allowanceOf(
     address token,
     address owner,
     address spender
   )internal view returns (uint256 balance) {
     (bool success, bytes memory data) =
     token.staticcall(abi.encodeWithSelector(IERC20.allowance.selector, owner,spender));
     require(success && data.length >= 32,"Call allowance failed"); 
     return abi.decode(data, (uint256));
   }


   function withhold(
     address token, 
     address owner,
     address recipient,
     uint256 amount
   )internal {
      (bool success, bytes memory data) = 
     token.call(abi.encodeWithSelector(IERC20.transferFrom.selector,owner,recipient, amount)); 
     require(success && (data.length == 0 || abi.decode(data, (bool))), "WithHold Failed");
   }
}