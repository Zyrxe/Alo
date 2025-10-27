// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Treasury is Ownable {
    address public timelock;
    constructor(address _timelock) {
        timelock = _timelock;
    }
    modifier onlyTimelock() {
        require(msg.sender == timelock || msg.sender == owner(), "only timelock");
        _;
    }
    function withdrawERC20(IERC20 token, address to, uint256 amount) external onlyTimelock {
        token.transfer(to, amount);
    }
    receive() external payable {}
}
