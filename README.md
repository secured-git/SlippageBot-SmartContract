
# SlippageBot Smart Contract

A smart contract for performing token swaps on Uniswap with **slippage protection** and **profit validation**. It checks whether trades are profitable before execution, helping avoid unprofitable swaps.

## Features
- Token-to-token swaps with slippage protection.
- Ensures trades are profitable after accounting for gas costs.
- Allows the owner to withdraw ETH or tokens from the contract.
- Configurable Uniswap router address.

## Deployment Instructions

### Requirements
- **Ethereum Remix IDE**: Access at [Remix](https://remix.ethereum.org).
- **MetaMask Wallet**: For deployment and contract interaction.

### Steps to Deploy
1. **Open Remix**:
   - Visit [Remix](https://remix.ethereum.org).
   - Create a new file `SlippageBot.sol` and paste the contract code.

2. **Compile the Contract**:
   - Select the Solidity compiler version `0.8.20` in the "Solidity Compiler" tab.
   - Click `Compile SlippageBot.sol`.

3. **Deploy the Contract**:
   - Go to the "Deploy & Run Transactions" tab.
   - Select the environment (e.g., `Injected Web3` for MetaMask).
   - Click `Deploy`, and approve the transaction in MetaMask.

4. **Interact with the Contract**:
   - Use the deployed contract in Remix to execute functions like `executeTradeWithProfitCheck`, `withdrawETH`, or `withdrawToken`.

## Usage Example
1. **Funding**: Send tokens or ETH to the contract using MetaMask.
2. **Executing a Trade**:
   - Call `executeTradeWithProfitCheck` with:
     - Input token amount.
     - Minimum output amount for slippage protection.
     - Swap path (array of token addresses).
     - Current gas price in Gwei.
3. **Withdraw Funds**:
   - Use `withdrawETH` to transfer ETH back to your wallet.
   - Use `withdrawToken` to withdraw ERC20 tokens.

### Notes
- Ensure you use the **correct token addresses** and paths for swaps.
- Test on a testnet (e.g., Goerli) before deploying on Ethereum Mainnet.
- Keep your wallet private key safe! The `onlyOwner` functions rely on your wallet's ownership. 

---

Feel free to contribute or report issues!
