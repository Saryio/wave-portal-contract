import * as hre from "hardhat";

const main = async () => {
  // eslint-disable-next-line no-unused-vars
  const [_, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });

  await waveContract.deployed();

  console.log("Contract deployed to", waveContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveTxn = await waveContract.connect(randomPerson).wave("Tchau 1");
  await waveTxn.wait();
  console.log(waveTxn);

  waveTxn = await await waveContract.connect(randomPerson).wave("Tchau 2");
  await waveTxn.wait();
  console.log(waveTxn);
  waveTxn = await waveContract.connect(randomPerson).wave("Tchau 3");
  await waveTxn.wait();
  console.log(waveTxn);

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  const waveCount = await waveContract.getTotalWaves();
  const allWaves = await waveContract.getAllWaves();

  console.log("Total Waves:", waveCount);
  console.log("All Waves:", allWaves);

  const wavesFromSomeone = await waveContract.getWavesFrom(
    randomPerson.address
  );

  console.log("Waves from someone:", wavesFromSomeone);
};

const runMain = async () => {
  try {
    await main();
    // eslint-disable-next-line no-process-exit
    process.exit(0);
  } catch (e) {
    console.error(e);
    // eslint-disable-next-line no-process-exit
    process.exit(1);
  }
};

runMain();
