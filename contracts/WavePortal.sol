//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    string waveEmoji = unicode"👋";
    string celebrateEmoji = unicode"🥳";
    uint256 private seed;

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    event NewWave(address indexed from, uint256 timestamp, string message);

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log(
            "[contract] Wave Portal constructed",
            waveEmoji,
            celebrateEmoji
        );
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 10 minutes < block.timestamp,
            "Wait 10 minutes"
        );

        totalWaves += 1;
        console.log("[contract] Someone waving: %s", msg.sender);
        console.log("[contract] Got message: %s", _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
            100;
        console.log("[contract] seed: %s", seed);
        console.log("[contract] random number: %s", randomNumber);

        seed = randomNumber;

        if (randomNumber < 50) {
            console.log("[contract] %s won!", msg.sender, celebrateEmoji);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        // emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("[contract] We have %d total waves", totalWaves, waveEmoji);
        return totalWaves;
    }
}
