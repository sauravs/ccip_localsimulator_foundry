// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {RPG}  from "../src/RPG.sol";


contract RPGTest is Test {
    RPG rpg;

    function setUp() public {
        rpg = new rpg(
            "Sword",
            "RPGItem",
            "RPG",
            ["Tier1", "Tier2"],
            [10, 20, 1, 5],
            msg.sender,
            ["#FF0000", "#00FF00"],
            [1, 2],
            address(0),
            1 ether,
            1
        );
    }

    function testMint() public {
        uint256 initialBalance = address(this).balance;
        payable(address(rpg)).transfer(1 ether);
        rpg.mint{value: 1 ether}();
        assertEq(rpg.balanceOf(address(this)), 1);
        assertEq(address(this).balance, initialBalance - 1 ether);
    }

    function testFailMintWithoutEther() public {
        rpg.mint();
    }

    function testUpdateStats() public {
        payable(address(rpg)).transfer(1 ether);
        rpg.mint{value: 1 ether}();
        rpg.updateStats(0, address(this), 20, 30, 2, 10);
        (uint8 stat1, uint8 stat2, uint8 specialType, uint8 specialPoints) = rpg.getTokenStats(0);
        assertEq(stat1, 20);
        assertEq(stat2, 30);
        assertEq(specialType, 2);
        assertEq(specialPoints, 10);
    }

    function testLockStatus() public {
        payable(address(rpg)).transfer(1 ether);
        rpg.mint{value: 1 ether}();
        assertFalse(rpg.lockStatus(0));
        rpg.setTokenLockStatus(0, block.timestamp + 1 days);
        assertTrue(rpg.lockStatus(0));
    }
}








}

