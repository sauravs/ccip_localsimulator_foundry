

//   * can transfer the NFT
//   * Not burnable
					   


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract RPGItemNFT is ERC721, ERC721Burnable, Ownable {
    uint256 public mintPrice;
    uint256 private _nextTokenId;
    using Strings for uint256;
    string public itemType;
    string[2] public statLabels;
    string public itemImage;
    string public lockedItemImage =
        "https://plum-liable-mastodon-450.mypinata.cloud/ipfs/QmaXD4NLN9hn5cb9jTd78faMvU3RNmf34gvhLGsnq67zs3";
    string[] private svgColors;
    uint8[] private colorRanges;
    address private _ccipHandler;
    uint256 private _parentChainId;

    event NftMinted(
        address indexed recipient,
        uint256 indexed tokenId,
        uint256 indexed timestamp
    );
    event Transfer(address indexed sender, uint256 indexed amount);

    uint256 constant BASE_PRICE_IN_MATIC = 1e18 / 100;
    // No change to this stat.
    struct StatType {
        uint8 stat1;                  
        uint8 stat2;
        uint8 specialType;
        uint8 specialPoints;
    }

    StatType baseStat;

    mapping(uint256 => StatType) upgradeMapping;

    mapping(bytes32 => StatType) newStatMap;

    mapping(uint256 => uint256) tokenLockedTill;  // ccip related

    modifier onlyCCIPRouter() {
        require(msg.sender == _ccipHandler, "Caller is not the CCIP router");
        _;
    }

    //  change the name to lockStatus TODO

    function lockStatus(uint256 tokenId) public view returns (bool) {
        return (tokenLockedTill[tokenId] > block.timestamp);
    }

    // chaneg the isUnlocked to  mod and apply to all trasnsfer , TraansferFrom ,upgrade, tokenUri wale me ternry
    modifier isUnlocked(uint256 tokenId) {
        require(tokenLockedTill[tokenId] <= block.timestamp, "Token is locked");
        _;
    }

    function setTokenLockStatus(uint256 tokenId, uint256 unlockTime)
        public
        onlyCCIPRouter
    {
        tokenLockedTill[tokenId] = unlockTime;
    }

    constructor(
        string memory itemType__,
        string memory tokenName__,
        string memory tokenSymbol__,
        string[2] memory labels__,      // labels is name of statstype
        uint8[] memory baseStat__,
        address initialOwner__,
        string[] memory svgColors__,    // svgColors   0-10 : #EFFF 
        uint8[] memory colorRanges__,   // colorRanges : 0-10-20-30
        address ccipHandler,
        uint256 mintPrice__,
        uint256 parentChainId__
    ) ERC721(tokenName__, tokenSymbol__) Ownable(initialOwner__) {
        baseStat.stat1 = baseStat__[0];
        baseStat.stat2 = baseStat__[1];
        baseStat.specialType = baseStat__[2];
        baseStat.specialPoints = baseStat__[3];
        statLabels = labels__;
        itemType = itemType__;
        colorRanges = colorRanges__;
        svgColors = svgColors__;
        _ccipHandler = ccipHandler;
        mintPrice = mintPrice__;
        _parentChainId = parentChainId__;
    }

    function changeCCIP(address newAdd) external {
        _ccipHandler = newAdd;
    }

    receive() external payable {
        emit Transfer(msg.sender, msg.value);
    }

    function setMintPrice(uint256 _mintPrice) public {
        require(_mintPrice >= 0, "mint price must be greater then 0");
        mintPrice = _mintPrice;
    }

    function getTokenStats(uint256 tokenId)
        public
        view
        returns (
            uint8,
            uint8,
            uint8,
            uint8
        )
    {
        StatType memory stats = upgradeMapping[tokenId];
        return (
            stats.stat1,
            stats.stat2,
            stats.specialType,
            stats.specialPoints
        );
    }

    function updateStats(
        uint256 tokenId,
        address newOwner,
        uint8 stat1,
        uint8 stat2,
        uint8 specialType,
        uint8 specialPoints
    ) external returns (bool) {
        require(newOwner != address(0), "Invalid new owner address");

        address currentOwner = ownerOf(tokenId);

        if (currentOwner == address(0)) {
            _safeMint(newOwner, tokenId);
            tokenLockedTill[tokenId] = 0;
            emit NftMinted(newOwner, tokenId, block.timestamp);
        }

        StatType memory tokenStats = upgradeMapping[tokenId];
        tokenStats.stat1 = stat1;
        tokenStats.stat2 = stat2;
        tokenStats.specialType = specialType;
        tokenStats.specialPoints = specialPoints;

        return true;
    }

    function mint() public payable {
        // require(                        // @audit 
        //     _parentChainId == block.chainid,
        //     string(
        //         abi.encodePacked(
        //             "Mint is not allowed on this chain , You can mint on ChainId : ",
        //             _parentChainId.toString()
        //         )
        //     )
        // );
        require(msg.value == mintPrice, "Insufficient Ether sent for minting");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        tokenLockedTill[tokenId] = 0;
        emit NftMinted(msg.sender, tokenId, block.timestamp);
    }



    function generateSVG(
        string memory color,
        string memory stat1,
        string memory stat2,
        string memory image,
        string memory name
    ) internal pure returns (string memory imgSVG) {
        imgSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:svgjs='http://svgjs.com/svgjs' width='500' height='500' preserveAspectRatio='none' viewBox='0 0 500 500'> <rect width='100%' height='100%' fill='",
                color,
                stat1,
                stat2,
                name,
                "' />",
                "<image x='50%' y='50%' font-size='128' dominant-baseline='middle' text-anchor='middle'>",
                image,
                "</image>",
                "</svg>"
            )
        );
    }

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        return _ownerOf(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        bool tokenLockStatus = lockStatus(tokenId);
        string memory imgSVG = generateSVG(
            tokenLockStatus ? "#808080" : powerLevelColor(tokenId),
            tokenLockStatus
                ? "??"
                : Strings.toString(getStat(statLabels[0], tokenId)),
            tokenLockStatus
                ? "??"
                : Strings.toString(getStat(statLabels[1], tokenId)),
            tokenLockStatus ? lockedItemImage : itemImage,
            name()
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "ETH Watching SVG",',
                        '"description": "An Automated ETH tracking SVG",',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(imgSVG)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return finalTokenURI;
    }

    function upgrade(uint256 tokenId) public payable isUnlocked(tokenId) {
        StatType memory previousStat = upgradeMapping[tokenId];
        StatType memory newStat = calculateUpgrade(previousStat);
        require(msg.value >= calculatePrice(newStat));
        upgradeMapping[tokenId] = newStat;
    }

    function calculatePrice(StatType memory stat)
        public
        pure
        returns (uint256)
    {
        return (BASE_PRICE_IN_MATIC * statPriceMultiplier__(stat));
    }

    function powerLevel__(uint256 tokenId) public view returns (uint256) {
        StatType memory previousStat = upgradeMapping[tokenId];
        return
            ((previousStat.stat1 + baseStat.stat1) +
                (previousStat.stat2 + baseStat.stat2)) / 2;
    }

    function powerLevelColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 powerlevel = powerLevel__(tokenId);
        if (powerlevel == 0) return svgColors[0];
        for (uint256 i; i < colorRanges.length - 1; i++) {
            if (
                powerlevel >= colorRanges[i] && powerlevel < colorRanges[i + 1]
            ) {
                return svgColors[i];
            }
        }
        return svgColors[0];
    }

    function statPriceMultiplier__(StatType memory stat)
        public
        pure
        returns (uint256)
    {
        return ((stat.stat1 + stat.stat2) * 100) / 2;
    }

    function calculateUpgrade(StatType memory previousStat)
        public
        returns (StatType memory)
    {
        bytes32 hash = _generateStatHash(previousStat);
        StatType memory newStat = newStatMap[hash];
        if (isEmptyStat(newStat)) {
            newStat = calculateStat__(previousStat, 3);
            newStatMap[hash] = newStat;
        }
        return newStat;
    }

    function _generateStatHash(StatType memory _stat)
        internal
        pure
        returns (bytes32 hash)
    {
        assembly {
            // Calculate the size of the struct in bytes
            let size := mload(_stat)
            // Point to the memory location of the struct
            let ptr := _stat
            // Compute the hash using Keccak256
            hash := keccak256(ptr, size)
        }
        // return
        //   keccak256(
        //     abi.encode(
        //       _stat.stat1,
        //       _stat.stat2,
        //       _stat.specialType,
        //       _stat.specialPoints
        //     )
        //   );
    }

    function calculateStat__(StatType memory previousStat, uint8 _increment)
        internal
        pure
        returns (StatType memory)
    {
        previousStat.stat1 += _increment;
        previousStat.stat2 += _increment;
        return previousStat;
    }

    function getStat(string memory statLabel, uint256 tokenId)
        public
        view
        returns (uint8 stat)
    {
        if (stringEqual(statLabel, statLabels[0]))
            return upgradeMapping[tokenId].stat1 + baseStat.stat1;
        else if (stringEqual(statLabel, statLabels[1]))
            return upgradeMapping[tokenId].stat2 + baseStat.stat2;
        else return 0;
    }

    function getSpecial(uint256 tokenId) public view returns (uint8, uint8) {
        return (
            upgradeMapping[tokenId].specialType,
            upgradeMapping[tokenId].specialPoints
        );
    }

    function isEmptyStat(StatType memory newStat) internal pure returns (bool) {
        return
            newStat.stat1 == 0 &&
            newStat.stat2 == 0 &&
            newStat.specialType == 0 &&
            newStat.specialPoints == 0;
    }

    // CCIP   // @audit -> not using in this code
    // function statToString(StatType memory stat)
    //     internal
    //     pure
    //     returns (string memory)
    // {
    //     bytes memory result = new bytes(4);
    //     result[0] = bytes1(stat.stat1);
    //     result[1] = bytes1(stat.stat2);
    //     result[2] = bytes1(stat.specialType);
    //     result[3] = bytes1(stat.specialPoints);
    //     return string(result);
    // }

    function stringEqual(string memory str1, string memory str2)
        internal
        pure
        returns (bool)
    {
        return
            bytes32(keccak256(abi.encode(str1))) ==
            bytes32(keccak256(abi.encode(str2)));
    }

    function transfer(address to, uint256 tokenId) public isUnlocked(tokenId) {
        require(to != address(0), "ERC721: transfer to the zero address");

        _transfer(_msgSender(), to, tokenId);
    }

    function getOwner(uint256 tokenId) public view returns (address) {
        return _ownerOf(tokenId);
    }

    

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override isUnlocked(tokenId) {
        require(to != address(0), "ERC721: transfer to the zero address");

        _transfer(from, to, tokenId);
    }
}
