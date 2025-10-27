// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract ProxyAdmin {
    address public owner;
    constructor() { owner = msg.sender; }
    modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }
    function transferOwnership(address newOwner) external onlyOwner { owner = newOwner; }
}
