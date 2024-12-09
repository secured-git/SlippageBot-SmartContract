// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract SlippageBot is Ownable, ReentrancyGuard {
    IUniswapV2Router02 public uniswapRouter;
    address public weth;

    event TradeExecuted(address indexed fromToken, address indexed toToken, uint256 amountIn, uint256 amountOut);

    address private constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    constructor() payable Ownable(msg.sender) {
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        weth = uniswapRouter.WETH();
    }

    receive() external payable {}

    function executeTradeWithProfitCheck(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        uint256 gasPriceInGwei
    ) external onlyOwner nonReentrant {
        require(path.length >= 2, "Invalid path");
        require(amountIn > 0, "Invalid input");

        IERC20 inputToken = IERC20(path[0]);
        require(inputToken.balanceOf(address(this)) >= amountIn, "Low balance");

        uint256[] memory expectedAmounts = uniswapRouter.getAmountsOut(amountIn, path);
        uint256 expectedAmountOut = expectedAmounts[expectedAmounts.length - 1];
        require(expectedAmountOut >= amountOutMin, "Low output");

        uint256 estimatedGas = 200000;
        uint256 gasCost = estimatedGas * gasPriceInGwei * 1e9 / 1 ether;

        uint256 profit = expectedAmountOut - amountIn;
        require(profit > gasCost, "Not profitable");

        if (inputToken.allowance(address(this), address(uniswapRouter)) < amountIn) {
            inputToken.approve(address(uniswapRouter), amountIn);
        }

        uint[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            address(this),
            block.timestamp
        );

        emit TradeExecuted(path[0], path[path.length - 1], amountIn, amounts[amounts.length - 1]);
    }

    function withdrawETH() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH");
        payable(owner()).transfer(balance);
    }

    function withdrawToken(address token) external onlyOwner nonReentrant {
        IERC20 erc20Token = IERC20(token);
        uint256 balance = erc20Token.balanceOf(address(this));
        require(balance > 0, "No tokens");
        erc20Token.transfer(owner(), balance);
    }

    function getEthBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getTokenBalance(address token) external view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function setUniswapRouter(address _newRouter) external onlyOwner {
        uniswapRouter = IUniswapV2Router02(_newRouter);
        weth = uniswapRouter.WETH();
    }
}
