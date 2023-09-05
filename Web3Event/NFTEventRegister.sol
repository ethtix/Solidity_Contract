//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import {IERC721, NFTTicketAutoId} from "./NFTTicketAutoId.sol";
import {VendingMachine} from "./NFTVendingMachine.sol";

contract NFTTicketAutoIdFactory {
    function createNewNFTTicket(string memory name_, string memory symbol_, string memory baseUri_, address controller) public returns (address) {
        NFTTicketAutoId nftContract = new NFTTicketAutoId(name_, symbol_, baseUri_);
        nftContract.addMinter(NFTEventRegister(msg.sender)._vendingMachine());
        nftContract.transferOwnership(controller);
        return address(nftContract);
    }
}

interface INFTTicketFactory {
    function createNewNFTTicket(string memory name_, string memory symbol_, string memory baseUri_, address controller_) external returns (address);
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

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract NFTEventRegister is Ownable {
    // Vending Machine
    address public _vendingMachine;
    // event id => controller address
    mapping (uint256 => address) public _eventOwner;
    // controller address => the list of controlled event id
    mapping (address => uint256[]) public _ownerEventList;

    // event id => event metadata
    mapping(uint256 => EventMetadata) public _eventInfo;
    uint256 public NextEventId = 1;
    struct EventMetadata {
        address nftAddress;
        uint256 startTime;  // blocks.timestamp is a Unix time stamp.
        uint256 duration;   // seconds
        int256 latitude;   // Eastern for positive, Western for negative
        int256 longitude;  // Northern fro positive, Southern for negative
        string description;
    }

    struct EventQueryInfo {
        uint256 eventId;
        address nftAddress;
        uint256 startTime;  // blocks.timestamp is a Unix time stamp.
        uint256 duration;   // seconds
        int256 latitude;   // Eastern for positive, Western for negative
        int256 longitude;  // Northern fro positive, Southern for negative
        string description;
    }

    constructor(address vendingMachine) {
        _vendingMachine = vendingMachine;
    }

    function updateVendingMachine(address newVendingMachine) public onlyOwner {
        _vendingMachine = newVendingMachine;
    }
    
    function transferManager(uint256 eventId, address manager) public {
        require(_eventOwner[eventId] == _msgSender(), "Unauthorized event info change");
        _eventOwner[eventId] = manager;
    }

    function _registEvent(uint256 startTime, uint256 duration, int256 latitude, int256 longitude, string memory description, address nftAddress) private returns (address) {
        _eventInfo[NextEventId] = EventMetadata({
            nftAddress: nftAddress, 
            startTime: startTime,  // blocks.timestamp is a Unix time stamp.
            duration: duration,  // seconds
            latitude: latitude, // Eastern for positive, Western for negative
            longitude: longitude, // Northern for positive, Southern for negative
            description: description
        });
        _eventOwner[NextEventId] = _msgSender();
        _ownerEventList[_msgSender()].push(NextEventId);
        NextEventId += 1;

        return nftAddress;
    }

    function uint2str(uint256 _i) private pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function registEventWithoutNFT(uint256 startTime, uint256 duration, int256 latitude, int256 longitude, string calldata description, address nftFactoryAddress, address quoteToken, uint256 quotePrice, uint256 quantityForSale) public returns (address) {
        string memory eventName = string(abi.encodePacked("Web3Event_", uint2str(NextEventId)));
        address nftContract = INFTTicketFactory(nftFactoryAddress).createNewNFTTicket(eventName, eventName, "", _msgSender());
        _registEvent(startTime, duration, latitude, longitude, description, nftContract);
        // Our factory support minting method
        VendingMachine(_vendingMachine).registCommodity(_msgSender(), nftContract, quoteToken, quotePrice, 0, quantityForSale, true);
        return nftContract;
    }

    function registEventWithNFT(uint256 startTime, uint256 duration, int256 latitude, int256 longitude, string calldata description, address nftContract, address quoteToken, uint256 quotePrice, uint256 start, uint256 end) public {
        _registEvent(startTime, duration, latitude, longitude, description, nftContract);
        // External NFT contract require transfer method for delivering purchased NFT for user
        VendingMachine(_vendingMachine).registCommodity(_msgSender(), nftContract, quoteToken, quotePrice, start, end, false);
    }

    // Notice the vending machine info will not change accordingly!!
    function modifyEventInfo(uint256 eventId, uint256 startTime, uint256 duration, int256 latitude, int256 longitude, string calldata description, address nftContract) public {
        require(_eventOwner[eventId] == _msgSender(), "Unauthorized event info change");
        _eventInfo[NextEventId] = EventMetadata({
            nftAddress: nftContract, 
            startTime: startTime,  // blocks.timestamp is a Unix time stamp.
            duration: duration,  // seconds
            latitude: latitude, // Eastern for positive, Western for negative
            longitude: longitude, // Northern fro positive, Southern for negative
            description: description
        });
    }
    // ---------------------------
    // Below are pure query method

    function queryEventInfo(uint256 startEventId, uint256 endEventId) public view returns (EventQueryInfo[] memory) {
        EventQueryInfo[] memory K = new EventQueryInfo[](endEventId - startEventId);
        for (uint256 i = startEventId; (i < endEventId && i < NextEventId); ++i) {
            K[i - startEventId] = EventQueryInfo({
                eventId: i,
                nftAddress: _eventInfo[i].nftAddress,
                startTime: _eventInfo[i].startTime,
                duration: _eventInfo[i].duration,
                latitude: _eventInfo[i].latitude,
                longitude: _eventInfo[i].longitude,
                description: _eventInfo[i].description
            });
        }
        return K;
    }

    function querySelectedEventInfo(address controller) public view returns (EventQueryInfo[] memory) {
        uint256[] memory eventIds = _ownerEventList[controller];
        EventQueryInfo[] memory K = new EventQueryInfo[](eventIds.length);
        for (uint256 i = 0; i < eventIds.length; ++i) {
            K[i] = EventQueryInfo({
                eventId: eventIds[i],
                nftAddress: _eventInfo[eventIds[i]].nftAddress,
                startTime: _eventInfo[eventIds[i]].startTime,
                duration: _eventInfo[eventIds[i]].duration,
                latitude: _eventInfo[eventIds[i]].latitude,
                longitude: _eventInfo[eventIds[i]].longitude,
                description: _eventInfo[eventIds[i]].description
            });
        }
        return K;
    }

    function userCheckAvailability(address user, uint256 startEventId, uint256 endEventId) public view returns (uint256[] memory) {
        uint256[] memory K = new uint256[](endEventId - startEventId);
        for (uint256 i = startEventId; (i < endEventId && i < NextEventId); ++i) {
            K[i - startEventId] = IERC721(_eventInfo[i].nftAddress).balanceOf(user);
        }
        return K;
    }

    function userCheckSelectedAvailability(address user, address controller) public view returns (uint256[] memory) {
        uint256[] memory eventIds = _ownerEventList[controller];
        uint256[] memory K = new uint256[](eventIds.length);
        for (uint256 i = 0; i < eventIds.length; ++i) {
            K[i] = IERC721(_eventInfo[eventIds[i]].nftAddress).balanceOf(user);
        }
        return K;
    }

    function plainUserCheckAvailability(address user, address[] calldata nftAddress) public view returns (uint256[] memory) {
        uint256[] memory K = new uint256[](nftAddress.length);
        for (uint256 i = 0; i < nftAddress.length; ++i) {
            K[i] = IERC721(nftAddress[i]).balanceOf(user);
        }
        return K;
    }

}
   