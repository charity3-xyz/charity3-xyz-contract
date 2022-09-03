// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


enum ProjectState {
    //0: Project 上链的初始状态，等待审核，审核中状态
    CENSORING, 
    //1: Project 募捐中,censor节点通过之后，转到Donating的状态
    DONATING,
    //2: Project 公示中，DONATING的过程当中，有人发起挑战，跳转到disclosuring的状态
    DISCLOUSURING,
    //3: Project 公示的时候，有仲裁委员会进行处理的状态
    ABITRATING,
    //4: Project 完成募集，管理员调整为项目结项，不再支持募捐
    FINISHED,
    //5: Project 被拒绝，也是结项状态
    REJECTED,
    //6: Project 被取消掉了
    CANCEL
}

enum CensorState {
    //0: 审查节点的状态，生效
     VALIDATE,
    //1: 审查节点被锁定，有仲裁的情况,锁定到临时状态,资产被合约冻结，不能转账，不能提现
     LOCKED, 
    //2: 审查节点押金不足，无法再申领项目，有项目没有结项，不支持取出押金
    INVALIDATE, 
}

enum CommitteeState {
    //0:有效
     VALIDATE,
    //1:锁定 
     LOCKED,
     //2:超时
     OVERDUE,
}