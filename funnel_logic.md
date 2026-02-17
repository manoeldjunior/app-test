# Funnel Logic: MagaluPay CDC (Digital Credit)
> **Source of Truth:** [Figma Flow - MagaluPay CDC](https://www.figma.com/design/tBHCHtHE51rIdJOXexzf0o/MPay---Carn%C3%AA-CDC--2024-?node-id=27946-5829&p=f&t=3V3OMDpR9l3dYfbN-0)

## 1. Strategic Objective
**Shift Credit Awareness Upstream.**
* **Current State:** User discovers credit eligibility only at "Checkout > Payment Selection."
* **Target State:** User sees "Pre-Approved Credit" at "Home" and "Product Detail Page (PDP)."
* **Metric:** Reduce drop-off between `PDP_VIEW` and `PAYMENT_START`.

## 2. Naming & Terminology (A/B Test Variables)
*Do not use "Carnê Digital" in the UI. Use the following variables based on user segment:*
* `VAR_A`: **"Pix Parcelado"** (Focus: Speed)
* `VAR_B`: **"Limite Magalu"** (Focus: Exclusivity)
* `VAR_C`: **"Pague Depois"** (Focus: BNPL)

## 3. Step-by-Step Flow & UI Logic

### Phase A: Top of Funnel (Discovery)
**Location:** Home Screen / Search Results
**Logic:**
- `IF` user_has_preapproved_credit == TRUE:
  - **Action:** Display "Credit Badge" on product cards.
  - **Copy:** "Parcele em até 24x sem cartão."
  - **Visual:** Use `Color.MagaluGreen` or `Color.MagaluBlue` (Test Hybrid V2).

### Phase B: Product Detail Page (Consideration)
**Location:** PDP (Above the Fold)
**Logic:**
- **Trigger:** Page Load.
- **Component:** "Simulator Widget" (See Mercado Livre Reference).
- **Behavior:**
  - Show calculated installment value immediately (e.g., "12x de R$ 49,90").
  - **Critical:** Display "Available Limit" pill next to the price.
  - **Interaction:** Tap opens a bottom sheet with a quick simulation, *without* leaving the page.

### Phase C: Cart & Checkout (Intent)
**Location:** Cart Summary
**Logic:**
- **Goal:** Reinforce the decision.
- **Display:** "Você economiza R$ XX.XX usando seu Limite Magalu."
- **Anti-Pattern:** Do not hide the credit option inside a generic "Credit Card" menu. It must be a top-level payment method.

### Phase D: Payment Selection (Conversion)
**Location:** Payment Method Screen
**Logic:**
- **State:** If credit is pre-approved, this option should be `SELECTED` by default or highlighted as `RECOMMENDED`.
- **Friction Reduction:** Remove "Upload Document" steps if user is already KYC verified (checking `User.isVerified`).

## 4. Competitor Benchmarks (for Hybrid Construction)
* **Mercado Livre Style:** Show green specific installments text directly under main price.
* **Nubank Style:** "Shopping Mode" toggle on Home Screen that reveals credit limit globally.