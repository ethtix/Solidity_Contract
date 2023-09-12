// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Ownable, NFTTicketAutoId} from "./NFTTicketAutoId.sol";
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        return msg.data;
    }
}

contract VendingMachine is Context {
    // VendingMachine commodity Id => Treasury address/ Controller
    mapping(uint256 => address) public controllers;
    // Treasury address/ Controller => VendingMachine commodity Id
    // Just for checking purpose, no overlapped treasury
    mapping(address => uint256[]) public controllersReverse;
    // The existing nft
    // NFT after purchase is given by new mint or transfer with approval by vending machine.
    // True means nft is new minted when user purchase. The NFT ticket contract need to provide minting access control
    // for vending machine contract.
    // False means nft is transferred by vending machine. The Treasury need pre-approve vending machine contract. 

    // Only one commodity is allowed to use mint method at the same time.
    // TODO: what if some bad guys occupy the slot on purpose?
    // NFT contract address => nftMintOrTransfer
    mapping(address => bool) public nftMintOrTransfer;

    // VendingMachine commodity Id => NFT ticket address
    mapping(uint256 => address) public quoteNFTs;
    // NFT ticket address => VendingMachine commodity Id
    mapping(address => uint256[]) public quoteNFTsReverse;
    uint256 public NextCommodityId = 1;
    
    // VendingMachine commodity Id => Quote Price
    mapping(uint256 => uint256) public quotePrices;
    // VendingMachine commodity Id => Quote Token Address
    // Empty/Zero address for native token by default
    mapping(uint256 => address) public quoteTokens;

    // It is NFT creator's responsiblity to make sure id for sales is availiable!!
    // Otherwise please update IdForSale info.
    struct nonPriceInfo {
        // start id of ticket sales bigger and equal to 
        uint256 _start;
        // end id of ticket sales smaller and exclude self
        uint256 _end;
        // current next id
        uint256 _current;
        // NFT after purchase is given by new mint or transfer with approval by vending machine.
        // True means nft is new minted when user purchase. The NFT ticket contract need to provide minting access control
        // for vending machine contract.
        // False means nft is transferred by vending machine. The Treasury need pre-approve vending machine contract. 
        bool _nftMintOrTransfer;
    }

    // For front end query purpose
    struct commodityQueryInfo {
        uint256 commodityId;
        address nftAddress;
        address quoteToken;
        uint256 quotePrice;
        // start id of ticket sales bigger and equal to 
        uint256 _start;
        // end id of ticket sales smaller and exclude self
        uint256 _end;
        // current next id
        uint256 _current;
        bool _nftMintOrTransfer;
    }
    // VendingMachine commodity Id => Id Info
    mapping(uint256 => nonPriceInfo) public nonPriceInfos;


    event PriceUpdate(uint256 indexed commodityId, address indexed quoteToken, uint256 quotePrice);
    event CommodityRegisted(uint256 indexed commodityId, address indexed quoteNFT, address controller);
    event Buy(address indexed buyer, address indexed quoteNFT, uint256 indexed tokenId, address quoteToken, uint256 quotePrice);
    
    // function withDrawNFT(uint256 commodityId, uint256 _price) public onlyOwner {
    //     _listToken(_uriTemplateId, _price);
    // }
    function registCommodity(address _treasury, address _quoteNFT, address _quoteToken, uint256 _quotePrice, uint256 _start, uint256 _end, bool _mintOrTransfer) public {
        uint256 _commodityId = NextCommodityId;
        bool treasuryEqualOwner = false;
        try Ownable(_quoteNFT).owner() returns (address contractOwner) {
            treasuryEqualOwner = (contractOwner==_treasury);
        } catch {
            treasuryEqualOwner = false;
        }
        require(msg.sender == _treasury || treasuryEqualOwner, "Random treasury account not allowed unless NFT contract's owner ");
        controllersReverse[_treasury].push(_commodityId);
        controllers[_commodityId] = _treasury;
        quoteNFTs[_commodityId] = _quoteNFT;
        quoteNFTsReverse[_quoteNFT].push(_commodityId);
        NextCommodityId += 1;

        emit CommodityRegisted(_commodityId, _quoteNFT, _treasury);
        _setNonPriceInfo(_commodityId, _start, _end, _start, _mintOrTransfer);
        _updateToken(_commodityId, _quoteToken, _quotePrice);
    }
    
    function _buyToken(address _buyer, uint256 _commodityId, uint256 _tokenId, address _quoteToken, uint256 _quotePrice) internal {
        address _quoteNFT = quoteNFTs[_commodityId];

        if (nonPriceInfos[_commodityId]._nftMintOrTransfer) {
            // Sometimes _tokenID is not used and nft contract has its own id logic
            NFTTicketAutoId(_quoteNFT).safeMint(_buyer);
        } else {
            address _treasury = controllers[_commodityId];
            IERC721(_quoteNFT).safeTransferFrom(_treasury, _buyer, _tokenId);
        }
        emit Buy(_buyer, _quoteNFT, _tokenId, _quoteToken, _quotePrice);
    }
    
    function safeBuyToken(uint256 _commodityId, uint256 _quantity) public {
        address _quoteToken = quoteTokens[_commodityId];
        uint256 _quotePrice = quotePrices[_commodityId];
        require(_quotePrice > 0, "No price");
        require((nonPriceInfos[_commodityId]._current + _quantity) <= nonPriceInfos[_commodityId]._end, "TokenId not enough/Close");

        uint256 _tokenId = nonPriceInfos[_commodityId]._current;
        for (uint256 i = 0; i < _quantity; ++i) {
            _buyToken(_msgSender(), _commodityId, _tokenId + i, _quoteToken, _quotePrice);
        }
        address _treasury = controllers[_commodityId];
        IERC20(_quoteToken).transferFrom(_msgSender(), _treasury, _quotePrice*_quantity);
        nonPriceInfos[_commodityId]._current += _quantity;
    }

    function _setNonPriceInfo(uint256 _commodityId, uint256 _start, uint256 _end, uint256 _current, bool _nftMintOrTransfer) internal {
        // Make sure only at most one commodity can use mint method for delivering NFT
        if (_nftMintOrTransfer) {
            if (nftMintOrTransfer[quoteNFTs[_commodityId]] == false) {
                nftMintOrTransfer[quoteNFTs[_commodityId]] = true;
            } else {
                require(nonPriceInfos[_commodityId]._nftMintOrTransfer, "Potential Mint Access Leak");
            }
        } else {
            if (nonPriceInfos[_commodityId]._nftMintOrTransfer) {
                // The NFT creator still need to remove Mint access manually
                nftMintOrTransfer[quoteNFTs[_commodityId]] = false;
            }
        }

        nonPriceInfos[_commodityId] = nonPriceInfo({ 
            _start: _start,
            _end: _end,
            _current: _current,
            _nftMintOrTransfer: _nftMintOrTransfer
        });
    }

    function setNonPriceInfo(uint256 _commodityId, uint256 _start, uint256 _end, uint256 _current, bool _nftMintOrTransfer) public {
        require(_msgSender()==controllers[_commodityId], "Not controller of commodity");
        _setNonPriceInfo(_commodityId, _start, _end, _current, _nftMintOrTransfer);
    }

    function _updateToken(uint256 _commodityId, address _token, uint256 _price) internal {
        quotePrices[_commodityId] = _price;
        quoteTokens[_commodityId] = _token;
        emit PriceUpdate(_commodityId, _token, _price);
    }

    function updateToken(uint256 _commodityId, address _token, uint256 _price) public {
        require(_msgSender()==controllers[_commodityId], "Not controller of commodity");
        _updateToken(_commodityId, _token, _price);
    }

    function closeCommodity(uint256 _commodityId) public {
        require(_msgSender()==controllers[_commodityId], "Not controller of commodity");
        _setNonPriceInfo(_commodityId, 0, 0, 0, false);
    }

    function queryCommidity(uint256 startCommodityId, uint256 endCommodityId) public view returns (commodityQueryInfo[] memory) {
        commodityQueryInfo[] memory K = new commodityQueryInfo[](endCommodityId - startCommodityId);
        for (uint256 i = startCommodityId; (i < endCommodityId && i < NextCommodityId); ++i) {
            K[i - startCommodityId] = commodityQueryInfo({
                commodityId: i,
                nftAddress: quoteNFTs[i],
                quoteToken: quoteTokens[i],
                quotePrice: quotePrices[i],
                _start: nonPriceInfos[i]._start,
                _end: nonPriceInfos[i]._end,
                _current: nonPriceInfos[i]._current,
                _nftMintOrTransfer: nonPriceInfos[i]._nftMintOrTransfer
            });
        }
        return K;
    }

    function querySelectedCommidity(address controller) public view returns (commodityQueryInfo[] memory) {
        uint256[] memory commodityIds = controllersReverse[controller];
        commodityQueryInfo[] memory K = new commodityQueryInfo[](commodityIds.length);
        for (uint256 i = 0; i < commodityIds.length; ++i) {
            K[i] = commodityQueryInfo({
                commodityId: commodityIds[i],
                nftAddress: quoteNFTs[commodityIds[i]],
                quoteToken: quoteTokens[commodityIds[i]],
                quotePrice: quotePrices[commodityIds[i]],
                _start: nonPriceInfos[commodityIds[i]]._start,
                _end: nonPriceInfos[commodityIds[i]]._end,
                _current: nonPriceInfos[commodityIds[i]]._current,
                _nftMintOrTransfer: nonPriceInfos[commodityIds[i]]._nftMintOrTransfer
            });
        }
        return K;
    }

    function queryQuoteNFTsReverse(address contractAddress) public view returns (uint256[] memory) {
        return quoteNFTsReverse[contractAddress];
    }
}