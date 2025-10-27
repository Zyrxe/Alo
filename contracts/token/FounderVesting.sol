// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FounderVesting is Ownable {
    IERC20 public token;
    address public beneficiary;
    uint256 public start;
    uint256 public cliff; // seconds
    uint256 public duration; // seconds
    uint256 public released;

    event Released(uint256 amount);

    constructor(IERC20 _token, address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration) {
        token = _token;
        beneficiary = _beneficiary;
        start = _start;
        cliff = _cliff;
        duration = _duration;
    }

    function releasableAmount() public view returns (uint256) {
        if (block.timestamp < start + cliff) return 0;
        uint256 elapsed = block.timestamp - start - cliff;
        if (elapsed > duration) elapsed = duration;
        uint256 total = token.balanceOf(address(this)) + released;
        uint256 vested = (total * elapsed) / duration;
        return vested - released;
    }

    function release() external {
        uint256 amount = releasableAmount();
        require(amount > 0, "Nothing to release");
        released += amount;
        token.transfer(beneficiary, amount);
        emit Released(amount);
    }
}
