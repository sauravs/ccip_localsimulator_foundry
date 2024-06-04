// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {RPGItemNFT} from "../src/RPG.sol";

contract RPGItemNFTTest is Test {
    RPGItemNFT rpg;

    function setUp() public {
        uint8[] memory baseStats = new uint8[](2);
        baseStats[0] = 10;
        baseStats[1] = 20;

        string[] memory svgColors = new string[](2);
        svgColors[0] = "#FF0000";
        svgColors[1] = "#00FF00";

        uint8[] memory colorRanges = new uint8[](2);
        colorRanges[0] = 1;
        colorRanges[1] = 2;

        rpg = new RPGItemNFT(
            "SWORD",
            "He-man Sword",
            "HSWD",
            ["Strength","Agility"],
            baseStats,
            msg.sender,
            svgColors,
            colorRanges,
            address(0),
            1 ether,
            1
        );
    }

    function testSetMintPrice() public {
        uint256 newMintPrice = 2 ether;
        rpg.setMintPrice(newMintPrice);
        assertEq(rpg.mintPrice(), newMintPrice);
    }
}