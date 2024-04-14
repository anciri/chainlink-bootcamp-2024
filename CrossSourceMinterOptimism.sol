// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on Optimism Sepolia

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract CrossSourceMinterOptimism {

    // Custom errors to provide more descriptive revert messages.
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); // Used to make sure contract has enough balance to cover the fees.
    error NothingToWithdraw(); // Used when trying to withdraw but there's nothing to withdraw.

    IRouterClient public router;
    LinkTokenInterface public linkToken;
    uint64 public destinationChainSelector;
    address public owner;
    address public destinationMinter;

    event MessageSent(bytes32 messageId);

    constructor(address destMinterAddress) {
        owner = msg.sender;

        // https://docs.chain.link/ccip/supported-networks/testnet

        // from Optimism
        address routerAddressOptimism = 0x114A20A10b43D4115e5aeef7345a1A71d2a60C57;
        router = IRouterClient(routerAddressOptimism);
        linkToken = LinkTokenInterface(0xE4aB69C077896252FAFBD49EFD26B5D171A32410);
        linkToken.approve(routerAddressOptimism, type(uint256).max);

        // to Sepolia
        destinationChainSelector = 16015286601757825753;
        destinationMinter = destMinterAddress;
    }

    function mintOnSepolia() external {
        // Mint from Optimism network = chain[2]
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(destinationMinter),
            data: abi.encodeWithSignature("mintFrom(address,uint256)", msg.sender, 2),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 980_000})
            ),
            feeToken: address(linkToken)
        });        

        // Get the fee required to send the message
        uint256 fees = router.getFee(destinationChainSelector, message);

        if (fees > linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);

        bytes32 messageId;
        // Send the message through the router and store the returned message ID
        messageId = router.ccipSend(destinationChainSelector, message);
        emit MessageSent(messageId);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function linkBalance (address account) public view returns (uint256) {
        return linkToken.balanceOf(account);
    }

    function withdrawLINK(
        address beneficiary
    ) public onlyOwner {
        uint256 amount = linkToken.balanceOf(address(this));
        if (amount == 0) revert NothingToWithdraw();
        linkToken.transfer(beneficiary, amount);
    }
}
