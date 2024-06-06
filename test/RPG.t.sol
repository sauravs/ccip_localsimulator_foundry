// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {RPGItemNFT} from "../src/RPG.sol";
//import forge-std/console2.sol;

contract RPGItemNFTTest is Test {
   
   RPGItemNFT public rpg;
   //address public myEOA = address(0x1234...);

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
        uint256 newMintPrice = 2 ether;
        rpg.setMintPrice(newMintPrice);
        assertEq(rpg.mintPrice(), newMintPrice);

        
    }


     function testFSetMintPrice() public {
        uint256 newMintPrice = 2 ether;
        vm.startPrank(address(1));
        rpg.setMintPrice(newMintPrice);

        vm.stopPrank();

        
    }


    function skiptestgetTokenStats() public {

         uint256 tokenId = 1; // The ID of the token you minted in setUp

        // Set the expected stats
        uint8 expectedStat1 = 10;
        uint8 expectedStat2 = 20;
        uint8 expectedSpecialType = 1;
        uint8 expectedSpecialPoints = 5;

        // Call getTokenStats and check the returned stats
        (uint8 stat1, uint8 stat2, uint8 specialType, uint8 specialPoints) = rpg.getTokenStats(tokenId);
        assertEq(stat1, expectedStat1, "stat1 does not match");
        assertEq(stat2, expectedStat2, "stat2 does not match");
        assertEq(specialType, expectedSpecialType, "specialType does not match");
        assertEq(specialPoints, expectedSpecialPoints, "specialPoints does not match");
      
       


    }

    function testMint() public {

        //uint256 initialTokenCount = rpg.totalSupply();

        uint256 currentTokenCount = 0;
        uint256 mintPrice = rpg.mintPrice();
         uint256 tokenId = 0;
        
        

        //assertEq(initialTokenCount, 0, "Initial token count is not 0");

        assertEq(mintPrice, 1 ether, "Mint price is not 1 Ether");

       //error is coming because transferring to zero address

       //generte new fake address and then try to mint via that address

        // Send the correct amount of Ether to the mint function
        address someUser = makeAddr("someUser");
          vm.deal(someUser, 100 ether);

        vm.prank(someUser);
        rpg.mint{value: mintPrice}();

      address newOwner = rpg.ownerOf(tokenId);
        assertEq(newOwner, someUser, "Token was not minted correctly");

        // // Check that the last token was minted to the test contract
        // assertEq(rpg.ownerOf(currentTokenCount + 1), address(this), "Last token was not minted to the test contract");
    }



     function skiptestOwnerOf() public {
        uint256 tokenId = 1; // The ID of the token you minted in setUp

        // Call ownerOf and check the returned owner
        assertEq(rpg.ownerOf(tokenId), address(this), "Owner is not correct");
    }



     function skiptestChangeCCIP() public {
        // address newAdd = address(0x123); // Replace with a real address

        // // Call changeCCIP
        // rpg.changeCCIP(newAdd);
        // // Check that _ccipHandler was updated correctly
       
        // assertEq(rpg._ccipHandler(), newAdd, "_ccipHandler was not updated correctly");
     }


      function skiptestChangeCCIPFail() public {
        // address newAdd = address(0x123); 

        // // Call changeCCIP
        // rpg.changeCCIP(newAdd);

        // // Check that _ccipHandler was updated correctly
       
        // assertEq(rpg._ccipHandler(), newAdd, "_ccipHandler was not updated correctly");

    }


    function skiptestUpdateStats() public {
        // uint256 tokenId = 1; // The ID of the token you want to update
        // address newOwner = address(this); // The new owner of the token
        // uint8 stat1 = 10;
        // uint8 stat2 = 20;
        // uint8 specialType = 30;
        // uint8 specialPoints = 40;

        // // Call updateStats
        // rpg.updateStats(tokenId, newOwner, stat1, stat2, specialType, specialPoints);

        // // Check that the stats were updated correctly
        // RPG.StatType memory stats = rpg.upgradeMapping(tokenId);
        // assertEq(stats.stat1, stat1, "stat1 was not updated correctly");
        // assertEq(stats.stat2, stat2, "stat2 was not updated correctly");
        // assertEq(stats.specialType, specialType, "specialType was not updated correctly");
        // assertEq(stats.specialPoints, specialPoints, "specialPoints was not updated correctly");
    }



    function skiptestTokenURI() public {
        // uint256 tokenId = 1; // The ID of the token you want to get the URI for

        // // Call tokenURI
        // string memory uri = rpg.tokenURI(tokenId);

        // // Check that the URI is valid
        // assertTrue(bytes(uri).length > 0, "URI is empty");

        // // Check that the URI starts with the expected prefix
        // string memory expectedPrefix = "data:application/json;base64,";
        // assertTrue(startsWith(uri, expectedPrefix), "URI does not start with the expected prefix");
    }

    function skipstartsWith(string memory str, string memory prefix) internal pure returns (bool) {
    //     bytes memory strBytes = bytes(str);
    //     bytes memory prefixBytes = bytes(prefix);
    //     if (strBytes.length < prefixBytes.length) {
    //         return false;
    //     }
    //     for (uint i = 0; i < prefixBytes.length; i++) {
    //         if (strBytes[i] != prefixBytes[i]) {
    //             return false;
    //         }
    //     }
    //     return true;
    // }

    //     function skiptestUpgrade() public {
    //     uint256 tokenId = 1; // The ID of the token you want to upgrade

    //     // Get the current stats
    //     RPG.StatType memory oldStats = rpg.upgradeMapping(tokenId);

    //     // Calculate the price for the upgrade
    //     RPG.StatType memory newStats = rpg.calculateUpgrade(oldStats);
    //     uint256 price = rpg.calculatePrice(newStats);

    //     // Call upgrade
    //     rpg.upgrade{value: price}(tokenId);

    //     RPG.StatType memory upgradedStats = rpg.upgradeMapping(tokenId);

        }





  function skiptestCalculatePrice() public {
        
        // RPG.StatType memory stat = RPG.StatType({
        //     stat1: 10,
        //     stat2: 20,
        //     specialType: 30,
        //     specialPoints: 40
        // });

        // uint256 price = rpg.calculatePrice(stat);

        // uint256 expectedPrice = rpg.BASE_PRICE_IN_MATIC() * rpg.statPriceMultiplier__(stat);
        // assertEq(price, expectedPrice, "Price is not correct");
    }


    function skiptestPowerLevel() public {
        // uint256 tokenId = 1; // The ID of the token you want to get the power level for

    
        // uint256 powerLevel = rpg.powerLevel__(tokenId);

     
        // RPG.StatType memory previousStat = rpg.upgradeMapping(tokenId);
        // RPG.StatType memory baseStat = rpg.baseStat;
        // uint256 expectedPowerLevel = ((previousStat.stat1 + baseStat.stat1) + (previousStat.stat2 + baseStat.stat2)) / 2;
        // assertEq(powerLevel, expectedPowerLevel, "Power level is not correct");
    }



   function skiptestPowerLevelColor() public {
        // uint256 tokenId = 1; 

        // string memory color = rpg.powerLevelColor(tokenId);


        // uint256 powerLevel = rpg.powerLevel__(tokenId);
        // string memory expectedColor = rpg.svgColors[0];
        // for (uint256 i = 0; i < rpg.colorRanges.length - 1; i++) {
        //     if (powerLevel >= rpg.colorRanges[i] && powerLevel < rpg.colorRanges[i + 1]) {
        //         expectedColor = rpg.svgColors[i];
        //         break;
        //     }
        // }
        // assertEq(color, expectedColor, "Color is not correct");
    }

function skiptestStatPriceMultiplier() public {
        // RPG.StatType memory stat = RPG.StatType({
        //     stat1: 10,
        //     stat2: 20,
        //     specialType: 30,
        //     specialPoints: 40
        // });

       
        // uint256 multiplier = rpg.statPriceMultiplier__(stat);

        // uint256 expectedMultiplier = ((stat.stat1 + stat.stat2) * 100) / 2;
        // assertEq(multiplier, expectedMultiplier, "Multiplier is not correct");
    }



function skiptestCalculateUpgrade() public {
        
        // RPG.StatType memory previousStat = RPG.StatType({
        //     stat1: 10,
        //     stat2: 20,
        //     specialType: 30,
        //     specialPoints: 40
        // });

        // RPG.StatType memory newStat = rpg.calculateUpgrade(previousStat);


        // bytes32 hash = rpg._generateStatHash(previousStat);
        // RPG.StatType memory expectedNewStat = rpg.newStatMap(hash);
        // if (rpg.isEmptyStat(expectedNewStat)) {
        //     expectedNewStat = rpg.calculateStat__(previousStat, 3);
        // }

        // assertEq(newStat.stat1, expectedNewStat.stat1, "stat1 is not correct");
    }


       function skiptestGetStat() public {
        // uint256 tokenId = 1; // the ID of the token you want to get the stat for
        // string memory statLabel = "stat1"; // the label of the stat you want to get

        // uint8 stat = rpg.getStat(statLabel, tokenId);

        // uint8 expectedStat = 0;
        // if (rpg.stringEqual(statLabel, rpg.statLabels[0])) {
        //     expectedStat = rpg.upgradeMapping(tokenId).stat1 + rpg.baseStat.stat1;
        // } else if (rpg.stringEqual(statLabel, rpg.statLabels[1])) {
        //     expectedStat = rpg.upgradeMapping(tokenId).stat2 + rpg.baseStat.stat2;
        // }
        // assertEq(stat, expectedStat, "Stat is not correct");
    }


     function skiptestGetSpecial() public {
        // uint256 tokenId = 1; // The ID of the token you want to get the special for

        // // Call getSpecial
        // (uint8 specialType, uint8 specialPoints) = rpg.getSpecial(tokenId);

        // // Check that the special type and special points are correct
        // // This depends on your contract's implementation
        // // If upgradeMapping is public, you can use rpg.upgradeMapping(tokenId)
        // uint8 expectedSpecialType = rpg.upgradeMapping(tokenId).specialType;
        // uint8 expectedSpecialPoints = rpg.upgradeMapping(tokenId).specialPoints;
        // assertEq(specialType, expectedSpecialType, "Special type is not correct");
        // assertEq(specialPoints, expectedSpecialPoints, "Special points are not correct");
    }

 function skiptestTransfer() public {
        // uint256 tokenId = 1; 
        // address testAddress = 0x123;

        // // Call transfer
        // rpg.transfer(testAddress, tokenId);

     
        // address newOwner = rpg.ownerOf(tokenId);
        // assertEq(newOwner, testAddress, "Token was not transferred correctly");
    }

 function skiptestGetOwner() public {
        // uint256 tokenId = 1; 

        // address owner = rpg.getOwner(tokenId);

        // address expectedOwner = rpg._ownerOf(tokenId);
        // assertEq(owner, expectedOwner, "Owner is not correct");
    }


    function skiptestTransferFrom() public {
        // uint256 tokenId = 1; 

        // rpg.transferFrom(testAddressFrom, testAddressTo, tokenId);

        // address newOwner = rpg.ownerOf(tokenId);
        // assertEq(newOwner, testAddressTo, "Token was not transferred correctly");
    }



 }











   




