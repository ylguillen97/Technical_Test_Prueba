// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vesting is Ownable {
    address public teamWallet;
    address public token;
    uint32 public cooldownTime = 30 days;

    uint256 public totalTokens = 3000000000000000000000000; //3.000.000 tokens
    uint256 public pendingBalance;
    uint256 public claimReady;

    constructor(address _teamWallet, address _token) {
        
        require(_token != address(0x0));
        require(_teamWallet != address(0x0));
        require(_teamWallet != _token);
        
        teamWallet = _teamWallet;
        token = _token;
        pendingBalance = totalTokens;
    }

    /**
     * @notice Calculate the percentage of a number.
     * @param x Number.
     * @param y Percentage of number.
     * @param scale Division.
     */
    function mulScale (uint x, uint y, uint128 scale) internal pure returns (uint) {

        require(scale > 0);

        uint a = x / scale;
        uint b = x % scale;
        uint c = y / scale;
        uint d = y % scale;

        return a * c * scale + a * d + b * c + b * d / scale;
    }

     /**
     * @notice Function that allows investors to claim their available tokens.
     */
    function claimTokens() public onlyOwner{
        uint256 _withdrawableTokens = mulScale(totalTokens, 1000, 10000); // 1000 basis points = 10%.
       
        require (_withdrawableTokens > 0);
        require (_withdrawableTokens <= pendingBalance);
        require (IERC20(token).balanceOf(token) >= _withdrawableTokens);

        claimReady += cooldownTime;

        pendingBalance -= _withdrawableTokens;

        IERC20(token).transfer(msg.sender, _withdrawableTokens);
    }
}