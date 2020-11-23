pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token
    )
        Crowdsale(rate, wallet, token)
        public
    {}
}

contract PupperCoinSaleDeployer {

    address public tokenSaleAddress;
    address public tokenAddress;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, initialSupply);
        tokenAddress = address(token);

        PupperCoinSale coinSales = new PupperCoinSale(1, wallet, token);
        coinSales.openingTime = now;
        coinSales.closingTime = now + 24 weeks;
        coinSalesAddress = address(coinSales);

        token.addMinter(coinSalesAddress);
        token.renounceMinter();
    }
}
