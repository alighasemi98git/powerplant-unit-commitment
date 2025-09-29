# Power Plant Unit Commitment

This project addresses the **unit commitment problem** for a thermal power plant with four generation units over a 24-hour horizon. The objective is to design a **cost-optimal, cyclic scheduling strategy** that balances efficiency, startup costs, demand uncertainty, and long-term investment decisions.

## Project Overview

* **Problem Type:** Mixed-Integer Linear Programming (MILP)
* **Context:** Power generation scheduling
* **Planning Horizon:** 24 hours (5 demand periods)
* **Key Features:**

  * Deterministic model with fixed demand
  * Stochastic model with demand uncertainty (normal distribution, σ=10 MW)
  * Sensitivity to external power price fluctuations
  * Capacity expansion analysis for long-term investments

## Models

1. **Deterministic Model**

   * Fixed demand across 5 periods
   * Optimal cost: **4026.5 kkr**
   * Strategy: operate fewer units for longer durations to minimize startup costs

2. **Stochastic Model**

   * Demand modeled as normally distributed random variable
   * 100 demand scenarios sampled
   * Optimal expected cost: **4106.2 kkr**
   * Accounts for demand variability and robustness

3. **External Power Pricing**

   * Base case: 10 kkr/MWh
   * Reduced by 50% → total cost: **4056.2 kkr**
   * Increased by 50% → total cost: **4108.0 kkr**

4. **Capacity Expansion**

   * Expanding Units 1 & 3 (+15 MW each) reduced total cost to **3994.2 kkr**
   * Improves efficiency and reduces external power reliance

## Results & Insights

* **Unit Commitment:** Units 1 and 3 are most cost-effective due to high capacity and low running costs
* **Uncertainty Costs:** Stochastic optimization raises costs by ~79.7 kkr (Value of the Stochastic Solution) but ensures robustness
* **External Power Prices:** Scheduling is sensitive to market fluctuations; cheap power reduces reliance on internal units, expensive power increases it
* **Investment Strategy:** Expanding Units 1 & 3 is the most profitable long-term investment

## Repository Structure

```
.
├── models/
│   ├── deterministic.gms      # Base MILP model
│   ├── stochastic.gms         # Stochastic demand model
│   ├── sensitivity.gms        # External power price analysis
│   ├── expansion.gms          # Capacity expansion scenarios
│
├── results/
│   ├── deterministic_results.txt
│   ├── stochastic_results.txt
│   ├── sensitivity_results.txt
│   ├── expansion_results.txt
│
├── report/
│   └── PowerPlant_Project2A.pdf
│
└── README.md
```

## Usage Instructions

### Requirements

* [GAMS](https://www.gams.com/download/) with MILP solvers (e.g., **CPLEX**)

### Running the Models

1. Clone the repository:

   ```bash
   git clone https://github.com/<your-username>/powerplant-unit-commitment.git
   cd powerplant-unit-commitment/models
   ```

2. Run the **deterministic model**:

   ```bash
   gams deterministic.gms
   ```

3. Run the **stochastic model**:

   ```bash
   gams stochastic.gms
   ```

4. Run the **sensitivity analysis**:

   ```bash
   gams sensitivity.gms
   ```

5. Run the **capacity expansion model**:

   ```bash
   gams expansion.gms
   ```

6. Results will appear in the `results/` directory.

## Technologies

* **GAMS**: for MILP and stochastic optimization
* **Optimization Methods:** unit commitment, stochastic programming
* **Sensitivity Analysis:** external prices, capacity constraints

## Authors

* Ali Ghasemi ([aghasemi@kth.se](mailto:aghasemi@kth.se))
* David Selin ([dseli@kth.se](mailto:dseli@kth.se))
* Raouf Boussersoub ([raoufb@kth.se](mailto:raoufb@kth.se))

*KTH Royal Institute of Technology – SF2822 Applied Nonlinear Optimization (2025)*

---

📄 This repository contains the models, results, and report analyzing deterministic and stochastic unit commitment for power plant operations.
