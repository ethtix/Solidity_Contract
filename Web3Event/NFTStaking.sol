//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import {NFTEventRegister} from "./NFTEventRegister.sol";
import {NFTTicketChecker} from "./NFTTicketChecker.sol";
import "./EnumerableMap.sol";

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

contract NFTStaking {
    using EnumerableMap for EnumerableMap.UintToUintMap;
    // Event Register
    address public _eventRegister;
    address public _ticketChecker;
    // event id => total staked amount
    mapping (uint256 => uint256) public _eventTotalStaked;
    // event id => staking amount, set by event owner
    mapping (uint256 => uint256) public _eventStakeAmount;
    // staking ERC20 token address, can not reset
    address public _defaultStakeToken;
    // event id => [nft id => staked amount]
    mapping (uint256 => EnumerableMap.UintToUintMap) private _userStaked;
    // event id => nft id => claimed?
    mapping (uint256 => mapping(uint256 => bool)) public _userClaimed;
    // event id => if event holder claime the unclaimable reward for user?
    mapping (uint256 => bool) public _eventOwnerClaimed;

    event NewStakeAmount(uint256 indexed eventId, uint256 stakeAmount);
    event Staked(uint256 eventId, uint256 nftId, uint256 stakeAmount);
    event Claimed(uint256 eventId, uint256 nftId, uint256 claimAmount);
    event EventHolderClaimed(uint256 eventId, uint256 claimAmount);

    constructor(address defaultStakeToken, address eventRegister, address ticketChecker) {
        _defaultStakeToken = defaultStakeToken;
        _eventRegister = eventRegister;
        _ticketChecker = ticketChecker;
    }

    // Event Holder set up the staked amount requirement for single user
    function setStakeAmount(uint256 _eventId, uint256 _stakeAmount) public {
        require(msg.sender == NFTEventRegister(_eventRegister)._eventOwner(_eventId), "Not Event Owner");
        _eventStakeAmount[_eventId] = _stakeAmount;
        emit NewStakeAmount(_eventId, _stakeAmount);
    }

    // User stake for a nft ticket (need pre approve of ERC20 of NFT staking contract!!)
    function stake(uint256 _eventId, uint256 _nftId) public returns (uint256) {

        require(!_userStaked[_eventId].contains(_nftId), "Already staked");
        (,uint256 startTime,,,,) = NFTEventRegister(_eventRegister)._eventInfo(_eventId);
        require(startTime > block.timestamp, "Event Already begin");

        uint256 stakeAmount = _eventStakeAmount[_eventId];
        require(stakeAmount > 0, "Stake disabled for Event");

        // Although even if you do not own the token, you can still stake for nft ticket
        IERC20(_defaultStakeToken).transferFrom(msg.sender, address(this), stakeAmount);
        _eventTotalStaked[_eventId] += stakeAmount;
        _userStaked[_eventId].set(_nftId, stakeAmount);

        emit Staked(_eventId, _nftId, stakeAmount);
        return stakeAmount;
    }

    // User claim its staked amount back after event over
    function claim(uint256 _eventId, uint256 _nftId) public returns (uint256) {
        uint256 stakeAmount = _userStaked[_eventId].get(_eventId);
        require(stakeAmount > 0, "No stake for NFT ticket");
        (address nftTicket,uint256 startTime,uint256 duration,,,) = NFTEventRegister(_eventRegister)._eventInfo(_eventId);
        require(startTime + duration < block.timestamp, "Event Not End");
        require(IERC721(nftTicket).ownerOf(_nftId) == msg.sender, "Not nft ticket owner");

        require(NFTTicketChecker(_ticketChecker).getSingleProperty(_eventId,0x7573656400000000000000000000000000000000000000000000000000000000,_nftId) == 1, "Ticket No Check In!");
        require(!_userClaimed[_eventId][_nftId], "Alreay Claimed"); 
        IERC20(_defaultStakeToken).transferFrom(address(this), msg.sender, stakeAmount);
        _userClaimed[_eventId][_nftId] = true;

        emit Claimed(_eventId, _nftId, stakeAmount);
        return stakeAmount;
    }

    // This method returns a list of event id's current TotalStaked Amount and the requirement amount of a single staked setup of event.
    function viewEventSetup(uint256[] calldata eventIds) public view returns (uint256[] memory TotalStakeds, uint256[] memory eventStakeAmounts) {
        uint256[] memory K1 = new uint256[](eventIds.length);
        uint256[] memory K2 = new uint256[](eventIds.length);
        for (uint256 i = 0; i < eventIds.length; ++i) {
            K1[i] = _eventTotalStaked[eventIds[i]];
            K2[i] = _eventStakeAmount[eventIds[i]];
        }
        return (K1, K2);
    }
    // This method returns all staked nft ticket id and their staked amount, claimed status of a single event id.
    function viewStakedByEventIds(uint256 _eventId) public view returns (uint256[] memory nftIds, uint256[] memory stakedAmounts, bool[] memory claimed) {
        uint256[] memory K1 = new uint256[](_userStaked[_eventId].length());
        uint256[] memory K2 = new uint256[](_userStaked[_eventId].length());
        bool[] memory K3 = new bool[](_userStaked[_eventId].length());
        for (uint256 i = 0; i < _userStaked[_eventId].length(); ++i) {
            (K1[i], K2[i]) = _userStaked[_eventId].at(i);
            K3[i] = _userClaimed[_eventId][K1[i]];
        }
        return (K1, K2, K3);
    }

    // This method returns staked amount and claimed status of multiple pairs of (eventId, nftId)
    // Non-existing staked amount will be zero.
    function viewStakedByNFTIds(uint256[] calldata eventIds, uint256[] calldata nftIds) public view returns (uint256[] memory stakedAmounts, bool[] memory claimed) {
        uint256[] memory K1 = new uint256[](eventIds.length);
        bool[] memory K2 = new bool[](eventIds.length);
        for (uint256 i = 0; i < eventIds.length; ++i) {
            (,K1[i]) = _userStaked[eventIds[i]].tryGet(nftIds[i]);
            K2[i] = _userClaimed[eventIds[i]][nftIds[i]];
        }
        return (K1, K2);
    }

    // Based on current checkin status, how much amount of staked amount can be claimed back
    function currentEstimateCheckInAMount(uint256[] calldata eventIds)  public view returns (uint256[] memory estaimteCheckInAmounts) {
        uint256[] memory K1 = new uint256[](eventIds.length);
        for (uint256 i = 0; i < eventIds.length; ++i) {
            uint256 tempCheckInAmount = 0;
            for (uint256 j =0; j < _userStaked[eventIds[i]].length();++j) {
                (uint256 tempNftId, uint256 tempUserStakedAmount) = _userStaked[eventIds[i]].at(j);
                if (NFTTicketChecker(_ticketChecker).getSingleProperty(eventIds[i], 0x7573656400000000000000000000000000000000000000000000000000000000, tempNftId) == 1) {
                    tempCheckInAmount += tempUserStakedAmount;
                }
            }
            K1[i] = tempCheckInAmount;
        }
        return K1;
    }

    // Event holder claim the unclaimable reward of users staked part
    function eventHolderWithdrawalUnclaimedStake(uint256 _eventId) public returns (uint256) {
        require(msg.sender == NFTEventRegister(_eventRegister)._eventOwner(_eventId), "Not Event Owner");
        require(!_eventOwnerClaimed[_eventId], "Event Holder already claimed");
        (,uint256 startTime,uint256 duration,,,) = NFTEventRegister(_eventRegister)._eventInfo(_eventId);
        require(startTime + duration < block.timestamp, "Event Not End");
        uint256 tempCheckInAmount = 0;
        for (uint256 j =0; j < _userStaked[_eventId].length();++j) {
            (uint256 tempNftId, uint256 tempUserStakedAmount) = _userStaked[_eventId].at(j);
            if (NFTTicketChecker(_ticketChecker).getSingleProperty(_eventId, 0x7573656400000000000000000000000000000000000000000000000000000000, tempNftId) == 1) {
                tempCheckInAmount += tempUserStakedAmount;
            }
        }
        uint256 claimAmount = _eventTotalStaked[_eventId] - tempCheckInAmount;
        IERC20(_defaultStakeToken).transferFrom(address(this), msg.sender, claimAmount);
        _eventOwnerClaimed[_eventId] = true;

        emit EventHolderClaimed(_eventId, claimAmount);
        return claimAmount;
    }
}