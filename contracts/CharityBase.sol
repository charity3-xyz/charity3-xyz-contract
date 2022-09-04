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
    bytes32 internal immutable _COMMITTEE_ITEM_TYPEHASH;
    uint256 internal immutable _CHAIN_ID;
    bytes32 internal immutable _DOMAIN_SEPARATOR;


  constructor() {
    (
      _NAME_HASH,
      _VERSION_HASH,
      _EIP_712_DOMAIN_TYPEHASH,
      _CENSOR_ITEM_TYPEHASH,
      _PROJECT_ITEM_TYPEHASH,
      _COMMITTEE_ITEM_TYPEHASH
    ) = _deriveTypehashes();
  }



 function _nameString() 
 internal pure virtual returns (string memory){
    return "Charity3XYZ";
 }

  function _deriveTypehashes() 
  internal
   pure
   returns(
      bytes32 nameHash,
      bytes32 versionHash,
      bytes32 eip712DomainTypehash,
      bytes32 censorItemTypehash,
      bytes32 projectItemTypehash,
      bytes32 committeItemTypehash
   ){
     nameHash = keccak256(bytes(_nameString()));
     versionHash = keccak256(bytes("1.1"));
     bytes memory censorItemString = abi.encodePacked(
        "CensorItem(",
        "address recipient,",
        "uint256 licenseNum,",
        ")"
    );
    bytes memory projectItemString = abi.encodePacked(
        "ProjectItem(",
        "address projectNum,",
        "address supervisorAddress",
        "uint256 fundingTarget",
        "uint256 deadlineTime",
        "address recipient",
        "address[] otherCensors",
        ")"
    );

    bytes memory commitItemString = abi.encodePacked(
        "CommitteeItem(",
        "address recipient,",
        "uint256 licenseNum,",
        ")" 
    );
     eip712DomainTypehash = keccak256(
            abi.encodePacked(
                "EIP712Domain(",
                    "string name,",
                    "string version,",
                    "uint256 chainId,",
                    "address verifyingContract",
                ")"
            )
        );
      censorItemTypehash = keccak256(censorItemString);
      projectItemTypehash = keccak256(projectItemString);
      committeItemTypehash = keccak256(commitItemString);


   }

}