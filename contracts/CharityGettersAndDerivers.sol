
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {
    Censor,
    CensorParameters,
    CensorItem,
    CommitteeItem,
    ProjectItem
} from "./libraries/CharityStructs.sol";

import {CharityBase} from "./CharityBase.sol";
import "./libraries/CharityConstants.sol";


contract CharityGettersAndDerivers is CharityBase {


//todo: 是否增加其他控制合约
constructor() CharityBase(){}



// derive EIP-712 hash for Censor item
function _hashCensorItem(CensorItem memory censorItem)
  internal
  view
  returns (bytes32)
{
    return
       keccak256(
        abi.encode(
            _CENSOR_ITEM_TYPEHASH,
           censorItem.recipient,
           censorItem.licenseNum 
        )
       );
}

function _hashCommitteeItem(CommitteeItem memory committeeItem)
 internal
 view
 returns (bytes32)
{
   return
    keccak256(
        abi.encode(
          _COMMITTEE_ITEM_TYPEHASH,
          committeeItem.recipient,
          committeeItem.licenseNum,
          committeeItem.deadline 
        )
    );
}

function _hashProjectItem(ProjectParameters memory parameters)
internal
view
returns (bytes32) {
    //生成的hash 不对 address再进行编码
   return
   keccak256(
    abi.encode(
        _PROJECT_ITEM_TYPEHASH,
        parameters.projectNum,
        parameters.supervisorAddress,
        parameters.fundingTarget,
        parameters.deadline,
        parameters.recipient,
        parameters.depositAmount,
        keccak256(abi.encodePacked(parameters.otherCensors))
    )
   );
}


function _deriveEIP712Digest( bytes32 domainSeparator, bytes32 itemHash)
internal
pure
returns (bytes32 value) {
    value = keccak256(
      abi.encodePacked(uint16(0x1901),domainSeparator,itemHash)
    );
}

function _domainSeparator() internal view returns (bytes32) {
        return block.chainid == _CHAIN_ID
            ? _DOMAIN_SEPARATOR
            : _deriveDomainSeparator(_EIP_712_DOMAIN_TYPEHASH,
            _NAME_HASH,
            _VERSION_HASH);
}

function _name() internal pure returns (string memory) {
        // Return the name of the contract.
        return _NAME;
}

}