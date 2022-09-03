// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {
    Censor,
    CensorParameters
} from "./libraries/CharityStructs.sol";
import "./libraries/CharityConstants.sol";




contract CharityBase  {
    bytes32 internal immutable _NAME_HASH;
    bytes32 internal immutable _VERSION_HASH;
    bytes32 internal immutable _EIP_712_DOMAIN_TYPEHASH;
    bytes32 internal immutable _CENSOR_ITEM_TYPEHASH;
    bytes32 internal immutable _PROJECT_ITEM_TYPEHASH;
    uint256 internal immutable _CHAIN_ID;
    bytes32 internal immutable _DOMAIN_SEPARATOR;


  constructor() {
    (
      _NAME_HASH,
      _VERSION_HASH,
      _EIP_712_DOMAIN_TYPEHASH,
      _CENSOR_ITEM_TYPEHASH,
      _PROJECT_ITEM_TYPEHASH,

    )
  }


  function _deriveTypehashes() 
  internal
   pure
   returns(
      bytes32 nameHash,
      bytes32 versionHash,
      bytes32 eip712DomainTypehash,
      bytes32 censorItemTypehash,
      bytes32 projectItemTypehash
   ){
    
   }

}