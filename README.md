# Mala ERC-20 Crowdsale

A minimal-but-production-style token + refundable crowdsale written in **Solidity 0.8.20** and tested with **Foundry**.

| Contract | Purpose |
|----------|---------|
| **`Mala.sol`**           | Simple ERC-20 (18 decimals) — owner-mint / owner-burn, no premine multiplication. |
| **`MalaCrowdsale.sol`**  | • Integer-only token sales<br>• Hard-cap & soft-cap<br>• Time-window<br>• Automatic refund vault<br>• Re-entrancy guard |

---

## ✨ Features

* **Whole-token pricing** – contributors must send an exact multiple of `priceWei` (≈ 2 USD / token).  
* **Refundable** – if the soft-cap isn’t reached, buyers can reclaim their ETH.  
* **Capped** – cannot raise above `cap`.  
* **No premine** – total supply is minted on demand by the crowdsale.

---

## Repository layout

├─ src/ # Solidity contracts
│ ├─ Mala.sol
│ └─ MalaCrowdsale.sol
├─ test/ # Foundry unit & fuzz tests
│ ├─ Mala.t.sol
│ └─ MalaCrowdsale.t.sol
├─ script/
│ └─ Deploy.s.sol # one-click deploy script
├─ lib/ # external deps (OpenZeppelin, forge-std) – auto-installed
└─ foundry.toml

## 🛠  Quick start

```bash
# 1. install foundry
curl -L https://foundry.paradigm.xyz | bash && foundryup

# 2. pull deps & run the green test suite
forge install
forge test -vv
```