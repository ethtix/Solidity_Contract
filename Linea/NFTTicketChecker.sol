//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import {NFTEventRegister} from "./NFTEventRegister.sol";
import "./EnumerableSet.sol";

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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

abstract contract TicketEventOwnable is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    address public _eventRegister;
    mapping (uint256 => EnumerableSet.AddressSet) private _managers;

    constructor (address eventRegister_) {
        _eventRegister = eventRegister_;
    }

    function updateEventRegister(address newEventRegister) public onlyOwner {
        _eventRegister = newEventRegister;
    }

    modifier onlyManager(uint256 eventId) {
        require((NFTEventRegister(_eventRegister)._eventOwner(eventId) == _msgSender()) || _managers[eventId].contains(_msgSender()), "Caller is not event owner/manager");
        _;
    }
    
    function addManager(uint256 eventId, address manager) public {
        require(NFTEventRegister(_eventRegister)._eventOwner(eventId) == _msgSender(), "Caller is not event owner");
        _managers[eventId].add(manager);
    }
    
    function removeManager(uint256 eventId, address manager) public {
        require(NFTEventRegister(_eventRegister)._eventOwner(eventId) == _msgSender(), "Caller is not event owner");
        _managers[eventId].remove(manager);
    }

    function queryManager(uint256 eventId) public view returns (address[] memory) {
        return _managers[eventId].values();
    }

}

contract NFTTicketChecker is TicketEventOwnable {
    constructor (address eventRegister_) TicketEventOwnable(eventRegister_) {}
    // event id => token id => property => value
    mapping(uint256 => mapping(uint256 => mapping (bytes32 => uint256))) internal TicketConfig;
    function setSingleProperty(uint256 _eventId, bytes32 _property, uint256 _id, uint256 _value) external onlyManager(_eventId) {
        TicketConfig[_eventId][_id][_property] = _value;
    }
    
    function setMultipleProperty(uint256 _eventId, bytes32 _property, uint256[] calldata _id, uint256[] calldata _value) external onlyManager(_eventId) {
        //require(msg.sender == creators[_id]);
        for (uint256 i = 0; i < _id.length; ++i) {
            TicketConfig[_eventId][_id[i]][_property] = _value[i];
        }
    }
    
    function setBatchProperty(uint256 _eventId, bytes32[] calldata _property, uint256[] calldata _id, uint256[] calldata _value) external onlyManager(_eventId) {
        //require(msg.sender == creators[_id]);
        for (uint256 i = 0; i < _id.length; ++i) {
            TicketConfig[_eventId][_id[i]][_property[i]] = _value[i];
        }
    }
    
    function getSingleProperty(uint256 _eventId, bytes32 _property, uint256 _id) public view returns (uint256 _value) {
        return TicketConfig[_eventId][_id][_property];
    }
    
    function getMultipleProperty(uint256 _eventId, bytes32 _property, uint256[] calldata _id) public view returns (uint256[] memory _value) {
        uint256[] memory K = new uint256[](_id.length);
        //require(msg.sender == creators[_id]);
        for (uint256 i = 0; i < _id.length; ++i) {
            K[i] = TicketConfig[_eventId][_id[i]][_property];
        }
        
        return K;
    }
    
    function getBatchProperty(uint256[] calldata _eventId, bytes32[] calldata _property, uint256[] calldata _id) public view returns (uint256[] memory _value) {
        uint256[] memory K = new uint256[](_id.length);
        //require(msg.sender == creators[_id]);
        for (uint256 i = 0; i < _id.length; ++i) {
            K[i] = TicketConfig[_eventId[i]][_id[i]][_property[i]];
        }
        
        return K;
    }
}