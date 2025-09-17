// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @title Family MultiSig Wallet 
/// @notice 2-of-3 approvals, monthly allowance, emergency toggle, goal-based lock
contract FamilyWallet {
    address[3] public owners;
    mapping(address => bool) public isOwner;
    uint public required = 2;

    // tx storage
    struct Tx {
        address to;
        uint value;
        bool executed;
        uint approvals;
    }
    Tx[] public txs;
    mapping(uint => mapping(address => bool)) public approved;

    // allowance
    mapping(address => uint) public monthlyAllowance;
    mapping(address => uint) public lastClaim;

    // goal
    uint public goalAmount;
    uint public goalRelease;
    address public goalBeneficiary;

    bool public emergency;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    constructor(address[3] memory _owners) {
        for (uint i; i < 3; i++) {
            owners[i] = _owners[i];
            isOwner[_owners[i]] = true;
        }
    }

    receive() external payable {}

    // --- multisig core ---
    function propose(address to, uint value) external onlyOwner returns (uint) {
        txs.push(Tx(to, value, false, 0));
        return txs.length - 1;
    }

    function approve(uint id) external onlyOwner {
        require(!approved[id][msg.sender], "already approved");
        approved[id][msg.sender] = true;
        txs[id].approvals++;
    }

    function execute(uint id) external {
        Tx storage t = txs[id];
        require(!t.executed && t.approvals >= required, "not ready");
        t.executed = true;
        payable(t.to).transfer(t.value);
    }

    // --- allowances ---
    function setAllowance(address user, uint amount) external onlyOwner {
        monthlyAllowance[user] = amount;
    }

    function claimAllowance() external {
        require(block.timestamp >= lastClaim[msg.sender] + 30 days, "too soon");
        lastClaim[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(monthlyAllowance[msg.sender]);
    }

    // --- goals ---
    function setGoal(address beneficiary, uint amount, uint releaseDate) external onlyOwner {
        goalBeneficiary = beneficiary;
        goalAmount = amount;
        goalRelease = releaseDate;
    }

    function releaseGoal() external {
        require(address(this).balance >= goalAmount, "not funded");
        require(block.timestamp >= goalRelease, "too early");
        payable(goalBeneficiary).transfer(goalAmount);
        goalAmount = 0; // reset
    }

    // --- emergency ---
    function toggleEmergency() external onlyOwner {
        emergency = !emergency;
    }
}
