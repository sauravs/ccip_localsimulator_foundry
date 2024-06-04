// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {RPGItemNFT} from "../src/RPG.sol";

contract RPGItemNFTTest is Test {
   
   RPGItemNFT public rpg;

    function setUp() public {
        // RPGItemNFT rpg;


        string[2] memory labels = ["Strength", "Agility"];
        uint8[] memory baseStats = new uint8[](4);
        baseStats[0] = 10;
        baseStats[1] = 20;
        baseStats[2] = 1;
        baseStats[3] = 5;
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
            labels,
            baseStats,
            msg.sender,
            svgColors,
            colorRanges,
            address(0),
            1 ether,
            1
        );
        
        // assertEq(rpg.name(),"He-man Sword");
        // assertEq(rpg.symbol(),"HSWD");
        // assertEq(rpg.owner(), msg.sender);
        //  assertEq(rpg.mintPrice(), 1 ether);
        
    }

    function testConstructor() public {


        
         assertEq(rpg.name(),"He-man Sword");
        assertEq(rpg.symbol(),"HSWD");
        assertEq(rpg.owner(), msg.sender);
         assertEq(rpg.mintPrice(), 1 ether);
    }
    

    function testSetMintPrice() public {
        // uint256 newMintPrice = 2 ether;
        // rpg.setMintPrice(newMintPrice);
        // assertEq(rpg.mintPrice(), newMintPrice);
    }
}