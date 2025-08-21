// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external {
        // Read your PRIVATE_KEY from env (hex with 0x is fine)
        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(pk);

        // ❗ No constructor args, because your contract has none
        MyNFT nft = new MyNFT();

        console2.log("MyNFT deployed at:", address(nft));

        vm.stopBroadcast();
    }
}
