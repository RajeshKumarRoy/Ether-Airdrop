// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

interface iDropper
{
    event SetAirdrop(bool isSet, uint256 timestamp);
    event AirdropActivation(bool isActive, uint256 timestamp);
    event Airdrop(address indexed from, address indexed to, uint256 amount);

    function setAirdrop(uint16 drops) external returns (bool);
    function isAirdropActive() external view returns (bool);
    function enableAirdrop() external returns (bool);
    function disableAirdrop() external returns (bool);
    function airdrop(address[] memory account) external returns (bool);

    receive() external payable;
}
