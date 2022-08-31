// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract CharityAccessControl {

    //项目管理者,帮助修改项目收益地址，block agent地址
    address public cpoAddress; 
    //有管理钱的权利,提取余额等
    address public cfoAddress;
    //项目超级管理员
    address public ceoAddress;

// 项目标识，项目有权限将所有项目暂停
bool public paused = false;

modifier whenNotPaused() {
    require(!paused,"Paused: false");
    _;
}

modifier whenPaused {
    require(paused,"Paused: true");
    _;
}

modifier onlyCEO () {
    require(msg.sender == ceoAddress,"Ownable: caller is not the CEO");
    _;
}

modifier onlyCFO (){
    require(msg.sender == cfoAddress,"Ownable: caller is not the CFO");
    _;
}

modifier onlyCPO (){
    require(msg.sender == cpoAddress,"Ownable: caller is not the CPO");
    _;
}

modifier onlyExecutor(){
       require(
            msg.sender == cpoAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress,
            "Ownable: caller is not executors"
        );
        _;
}

function setCEO(address _newCEO) external onlyCEO {
    require(_newCEO != address(0),"Ownable: new owner is the zero address");
    ceoAddress = _newCEO;
}

function setCFO(address _newCFO) external onlyCEO {
  require(_newCFO != address(0),"Ownable: new owner is the zero address");
  cfoAddress = _newCFO;
}

function setCPO(address _newCPO) external onlyCEO {
    require(_newCPO != address(0),"Ownable: new owner is the zero address"); 
    cpoAddress = _newCPO;
}
    
function pause() external onlyExecutor whenNotPaused {
    paused = true;
} 
function unpause() public onlyCEO whenPaused {
    paused = false;
}

}