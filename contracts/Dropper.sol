// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "./iDropper.sol";

contract Dropper is iDropper
{
    address private _owner;
    bool private _isDroppable;
    uint256 private _drop;
    uint16 private _drops;
    uint16 private _dropped;

    constructor()
    {
        _owner = msg.sender;
    }

    modifier onlyOwner
    {
        require(msg.sender == _owner, "Permission Denied, You're are not the Owner!");
        _;
    }

    function setAirdrop(uint16 drops) onlyOwner external returns (bool)
    {
        require(drops !=0, "Drops can't be Zero!");
        require(drops <= 65535, "Drops can't be more than 65,535");
        _drops = drops;
        _drop = address(this).balance/_drops;
        emit SetAirdrop(true, block.timestamp);
        return true;
    }

    function isAirdropActive() external view returns (bool)
    {
        return _isDroppable;
    }

    function enableAirdrop() onlyOwner external returns (bool)
    {
        require(!_isDroppable, "Already Enabled!");
        _isDroppable = true;
        emit AirdropActivation(true, block.timestamp);
        return true;
    }

    function disableAirdrop() onlyOwner external returns (bool)
    {
        require(_isDroppable, "Already Disabled!");
        _isDroppable = false;
        emit AirdropActivation(false, block.timestamp);
        return true;
    }

    function airdrop(address[] memory account) onlyOwner external returns (bool)
    {
        require(_isDroppable, "Airdrop is Disabled!");
        require(_dropped <= _drops, "Reached Goal!");
        require(account.length <= 500, "Can't drop more than 500 drops at once!");
        require(address(this).balance > 0, "Zero Balance!");
        require(address(this).balance >= account.length*_drop, "Low Balance!");
        for(uint16 i = 0; i <= 500; i++)
        {
            payable(account[i]).transfer(_drop);
            emit Airdrop(address(this), account[i], _drop);
            _dropped++;
        }
        return true;
    }

    receive() external payable {}
}
