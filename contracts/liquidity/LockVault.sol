// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockVault {
    mapping(address=>uint256) public balances;
    function depositFor(address user, uint256 amount) external {
        balances[user] += amount;
    }
    function withdrawTo(address to, uint256 amount) external {
        // test-only: allow caller to pull if enough balance
        require(balances[msg.sender] >= amount, "insufficient");
        balances[msg.sender] -= amount;
        IERC20(msg.sender).transfer(to, amount);
    }
}
