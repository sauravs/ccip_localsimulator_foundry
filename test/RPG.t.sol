// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";

import {IRPGItemNFT} from "../src/IRPGItemNFT.sol";

contract RPGItemNFTTest is Test {
    IRPGItemNFT public rpgItemNFT;

    function setUp() public {
        rpgItemNFT = IRPGItemNFT(address(0x123));
    }

    function testGetOwner() public {
        address owner = rpgItemNFT.getOwner(1);
        console2.logAddress(owner);
    }
}

