// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Mala}            from "./Mala.sol";
import {Ownable}         from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";



contract MalaCrowdsale is Ownable, ReentrancyGuard {
    /* ──────────────── events ─────────────────── */
    event TokensPurchased(address indexed buyer, uint256 weiSent, uint256 amount);
    event RefundClaimed   (address indexed buyer, uint256 weiValue);
    event CrowdsaleFinalised(bool goalReached, uint256 weiRaised);

    /* ────────── immutable config ────────── */
    uint256 public immutable priceWei;   // wei required for ONE whole token
    uint256 public immutable cap;        // hard-cap in wei
    uint256 public immutable goal;       // soft-cap in wei
    uint64  public immutable openingTime;
    uint64  public immutable closingTime;
    Mala    public immutable token;

    /* ────────── state ────────── */
    uint256 public weiRaised;
    mapping(address => uint256) public contributions;
    bool    public finalised;

    /* ──────────────── constructor ────────────── */
    constructor(
        uint256 _priceWei,                
        uint256 _cap,
        uint256 _goal,
        uint64  _open,
        uint64  _close,
        address _treasury,
        Mala    _token
    )
        Ownable(_treasury)
    {
        require(_priceWei > 0 && _goal <= _cap, "bad params");
        priceWei    = _priceWei;
        cap         = _cap;
        goal        = _goal;
        openingTime = _open;
        closingTime = _close;
        token       = _token;
    }

    /* ──────────────── external mutating ──────── */
    /// @notice Buy MALA tokens with ETH while the sale is open.
    function buyTokens() external payable nonReentrant {
        require(block.timestamp >= openingTime && block.timestamp <= closingTime,
                "sale closed");
        require(weiRaised + msg.value <= cap, "cap hit");
        require(msg.value % priceWei == 0, "must buy whole tokens");

        uint256 tokenCount = msg.value / priceWei;          // integer
        weiRaised               += msg.value;
        contributions[msg.sender] += msg.value;

        token.mint(msg.sender, tokenCount * 1e18);          // 18-dec units
        emit TokensPurchased(msg.sender, msg.value, tokenCount);
    }

    /// @notice End the sale; forward funds or unlock refunds.
    function finalise() external nonReentrant {
        require(block.timestamp > closingTime, "not closed");
        require(!finalised, "already");
        finalised = true;

        bool reached = weiRaised >= goal;
        if (reached) {
            payable(owner()).transfer(address(this).balance);
        }
        emit CrowdsaleFinalised(reached, weiRaised);
    }

    /// @notice Claim ETH back if soft-cap not reached after finalise().
    function claimRefund() external nonReentrant {
        require(finalised && weiRaised < goal, "no refund");
        uint256 value = contributions[msg.sender];
        require(value > 0, "zero");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(value);
        emit RefundClaimed(msg.sender, value);
    }

    /* ──────────────── view helpers (optional) ─ */
    function saleOpen() external view returns (bool) {
        return block.timestamp >= openingTime && block.timestamp <= closingTime;
    }
}
