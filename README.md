# 🔒 Multi-Signature Family Wallet

A simplified **2-of-3 Multi-Signature Family Wallet** smart contract designed for **families or small groups**.  
It adds extra features like **monthly allowances, goal-based savings locks, and an emergency toggle**.

---

## ✨ Features
  
### 🛡️ Multi-Signature Wallet (2-of-3)

- Any of the 3 owners can **propose** a transaction.
- Requires **at least 2 approvals** before execution.
- Prevents single-owner misuse of funds.

### 💰 Monthly Allowances

- Owners can assign **monthly allowance amounts** to family members.
- Family members can **claim funds every 30 days**.
- Helps automate **pocket money, household budgets, or savings contributions**.

### 🎯 Goal-Based Lock

- Funds can be locked for a specific purpose (e.g., education, healthcare, or travel).
- Only released once:
  - The **goal amount** is funded **and**
  - The **release date** has passed.
- Encourages **long-term financial discipline**.

### 🚨 Emergency Mode

- Owners can toggle an **emergency flag**.
- Useful for handling urgent situations or freezing spending policies.

---

## 🏗️ Contract Structure

- **Owners:** 3 addresses set at deployment time.
- **Transactions:** Proposed by owners, need 2/3 approvals to execute.
- **Allowances:** Per-user, claimable once per month.
- **Goals:** Single goal can be set with amount + release date.
- **Emergency:** Boolean flag toggled by owners.

---

## 📜 Functions Overview

### 🔑 Multi-Signature

- `propose(address to, uint value)` → Propose a transaction.
- `approve(uint id)` → Approve a pending transaction.
- `execute(uint id)` → Execute a transaction after enough approvals.

### 💰 Allowances

- `setAllowance(address user, uint amount)` → Set a monthly allowance.
- `claimAllowance()` → Claim allowance (available once every 30 days).

### 🎯 Goals

- `setGoal(address beneficiary, uint amount, uint releaseDate)` → Set a goal.
- `releaseGoal()` → Release funds when conditions are met.

### 🚨 Emergency

- `toggleEmergency()` → Flip emergency flag (on/off).

---
