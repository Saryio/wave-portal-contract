//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 private totalWaves;
  uint256 private seed;

  event NewWave(address indexed from, string message, uint256 timestamp);

  struct User {
    uint256 waves;
    uint256 lastWave;
  }

  struct Wave {
    address from;
    string message;
    uint256 timestamp;
  }
  Wave[] private waves;

  mapping(address=>User) public wavesMap;

  constructor() payable {
    console.log("WavePortal babe");

    seed = (block.timestamp + block.difficulty) % 100;
  }

  function wave(string memory _message) public {

    require(wavesMap[msg.sender].lastWave + 30 seconds < block.timestamp, "You can't wave too often");
    wavesMap[msg.sender].lastWave = block.timestamp;

    totalWaves += 1;
    wavesMap[msg.sender].waves += 1;
    console.log("%s deu tchauzinho", msg.sender);
    waves.push(Wave(msg.sender, _message, block.timestamp));    

    seed = (block.difficulty + block.timestamp + seed) % 100;
    console.log("# Seed aleatoria: %d", seed);

    if(seed <= 50){
      console.log("%s ganhou!", msg.sender);

      uint256 prizeAmount = 0.0001 ether;
      require(prizeAmount <= address(this).balance, "Enough ether");

      (bool success, ) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Withdraw failed");

      emit NewWave(msg.sender, _message, block.timestamp);
    }

  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
    console.log("Total de %d tchauzinhos: ", totalWaves);
    return totalWaves;
  }

  function getWavesFrom(address _address) public view returns (uint256) {
    console.log("%s deu %d tchauzinhos", _address, wavesMap[_address].waves);
    return wavesMap[_address].waves;
  }
}
