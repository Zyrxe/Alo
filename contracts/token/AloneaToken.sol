// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILockVault { function depositFor(address user, uint256 amount) external; }

contract AloneaToken is ERC20, Ownable {
    uint8 private _decimals = 18;
    address public burnReserve;
    address public treasury;
    ILockVault public lockVault;

    uint256 public maxTransfer = 22_222 * (10**18);
    uint256 public maxSell = 500 * (10**18);
    uint256 public maxBuyPerAddress = 1_000 * (10**18);
    uint256 public maxWalletPercent = 2; // percent of totalSupply (2%)

    uint256 public buyFee = 300; // 3% (basis points: 10000 = 100%)
    uint256 public sellFee = 300; // 3%
    uint256 public transferFee = 1000; // 10%

    mapping(address=>bool) public isExcludedFromFee;
    mapping(address=>bool) public isBot;

    event FeesTaken(address from, uint256 amount, string kind);

    constructor(address _burnReserve, address _treasury) ERC20("ALONEA (Testnet)", "ALO") {
        burnReserve = _burnReserve;
        treasury = _treasury;
        _mint(msg.sender, 22_000_000_000 * 10**18);
        isExcludedFromFee[msg.sender] = true;
        isExcludedFromFee[address(this)] = true;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual override {
        require(!isBot[from] && !isBot[to], "Bot blocked");
        if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) {
            // basic limits
            require(amount <= maxTransfer, "exceeds max transfer");
            if (to != owner()) {
                uint256 maxWallet = (totalSupply() * maxWalletPercent) / 100;
                require(balanceOf(to) + amount <= maxWallet, "wallet limit");
            }

            uint256 fee;
            string memory kind;
            if (from == owner()) {
                // owner selling/buying not special in this simple template
                fee = (amount * transferFee) / 10000;
                kind = "transfer";
            } else {
                fee = (amount * transferFee) / 10000;
                kind = "transfer";
            }

            if (fee > 0) {
                super._transfer(from, burnReserve, fee);
                emit FeesTaken(from, fee, kind);
                amount = amount - fee;
            }
        }
        super._transfer(from, to, amount);
    }

    // Admin helpers
    function setFees(uint256 _buyBP, uint256 _sellBP, uint256 _transferBP) external onlyOwner {
        buyFee = _buyBP; sellFee = _sellBP; transferFee = _transferBP;
    }
    function setLimits(uint256 _maxTransfer, uint256 _maxSell, uint256 _maxBuyPerAddress, uint256 _maxWalletPercent) external onlyOwner {
        maxTransfer = _maxTransfer; maxSell = _maxSell; maxBuyPerAddress = _maxBuyPerAddress; maxWalletPercent = _maxWalletPercent;
    }
    function excludeFromFee(address acc, bool ex) external onlyOwner { isExcludedFromFee[acc] = ex; }
    function markBot(address acc, bool blocked) external onlyOwner { isBot[acc] = blocked; }

    // Convenience: recover tokens (test only)
    function emergencyRecoverERC20(address token, address to, uint256 amount) external onlyOwner {
        require(token != address(this), "not allowed");
        IERC20(token).transfer(to, amount);
    }
}
