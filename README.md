# UTXOracle Nix Flake

This repository provides a Nix flake packaging for the original UTXOracle by @SteveSimple (Twitter).

**No modifications** have been made to the core UTXOracle algorithm - this just makes it easier to run with Nix.

Original UTXOracle: https://utxo.live/oracle/UTXOracle.py
 

# UTXOracle License

**Version 1.0** — May 2025

This is a custom license written specifically for the UTXOracle project. It reflects the unique nature of Bitcoin data: namely, that long-term confirmed data can achieve consensus across nodes, while real-time or mempool-based data inherently cannot. This license is designed to:

- Encourage wide, free use of UTXOracle for consensus-compatible purposes;
- Prevent confusion or misuse of the term "UTXOracle" for outputs not derived from consensus logic;
- Retain commercial and naming rights for live-streamed or real-time products.

This license is not OSI-approved, but it is written in good faith to balance decentralization, reproducibility, and responsible innovation.

## Section 1: Definitions

**"UTXOracle Local"** refers to the open-source software made available by the author for calculating the 24-hour average confirmed price and the recent 144-block window price using confirmed Bitcoin transactions.

**"Consensus-Compatible Use"** means:
- Running UTXOracle Local to generate the daily average confirmed block price ("UTXOracle Consensus Price"), or
- Running UTXOracle Local to generate the price from the most recent 144 confirmed blocks ("UTXOracle Block Window Price"),
- Without modifying the filtering or averaging logic that produces those prices.

**"Live or Real-Time Use"** means:
- Using mempool data,
- Using data from fewer than 6 confirmations at the chain tip,
- Generating prices that update faster than once per confirmed block,
- Producing streamed or pushed data outputs (APIs, trading bots, etc.).

**"The Author"** refers to the creator and copyright holder of UTXOracle, reachable via Twitter.com or x.com at @SteveSimple.

## Section 2: Permissions (Consensus-Compatible Use)

1. You are free to use, modify, distribute, and run UTXOracle Local for Consensus-Compatible Use without cost.

2. You may adapt UTXOracle Local to fit your local environment (e.g., paths, dependencies, node RPC settings) as long as you do not alter the price-filtering or averaging logic.

3. You may publish or share visualizations or outputs of UTXOracle Local for educational, analytical, or public benefit purposes.

4. If you are using UTXOracle Local unmodified to generate the 24-hour average or the 144-block window price, you must refer to these outputs by their canonical names:
  - "UTXOracle Consensus Price" for the 24-hour average from confirmed blocks
  - "UTXOracle Block Window Price" for the average from the most recent 144 confirmed blocks

5. You may not relabel or rebrand these outputs using alternative names when the original UTXOracle code remains unmodified for price logic.

6. You may not use the UTXOracle Consensus Price or UTXOracle Block Window Price for commercial purposes, including but not limited to financial services, paid dashboards, or subscription-based products, without prior written permission from the Author.

7. Commercial third-party node applications may integrate UTXOracle Consensus and Block Window Prices into their products so long as:
  - The integration adheres to all other conditions in this Section,
  - The price logic is unmodified,
  - The outputs are clearly labeled with the canonical names.
  - A link to the UTXOracle Live stream is included in the display.

8. Any redistribution of the UTXOracle code must retain this license in its entirety, including this Section and all usage restrictions.

9. Consensus-Compatible Use includes automated or repeated execution of UTXOracle Local logic to recalculate the UTXOracle Block Window Price on each new confirmed block, provided that:
  - Only confirmed blocks are used,
  - The logic remains unmodified,
  - The outputs are labeled with their canonical names.

## Section 3: Restrictions on Naming and Representation

1. If you modify the price logic (e.g., change filtering thresholds, averaging methods, or block selection rules), you must not use the following terms to describe your output:
  - "UTXOracle Consensus Price"
  - "UTXOracle Block Window Price"
  - Any term incorporating "UTXOracle" to describe the price output

2. These terms are reserved exclusively for outputs derived from unmodified consensus-compatible logic as defined by the Author.

3. You may not use the UTXOracle name, logo, or associated branding for any fork or derivative project without written permission.

## Section 4: Prohibited Use (Live or Commercial Streaming)

1. You may not use UTXOracle (in whole or in part), or any derivative of it, to:
  - Generate or stream a live or real-time price feed;
  - Provide price updates more frequent than once per block;
  - Operate a trading bot, financial API, or trading-related product;
  - Offer a public-facing service under the name UTXOracle.

2. These use cases are reserved exclusively for the Author under the name:
  - "UTXOracle Live"
  - "UTXOracle Live Price"
  - "Live On-Chain Price"

3. To discuss licensing for live or commercial usage, contact the Author.

## Section 5: Trademark and Branding

The following terms are being claimed as trademarks by the Author:
- UTXOracle
- UTXOracle Consensus Price
- UTXOracle Block Window Price
- UTXOracle Live
- UTXOracle Live Price
- Live On-Chain Price

Use of these names, phrases, or related branding in public-facing products or services is strictly prohibited without explicit written permission.

## Section 6: No Warranty

This software is provided "as is," without warranty of any kind. The Author shall not be liable for any claims, damages, or losses resulting from its use.
