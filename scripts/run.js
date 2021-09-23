async function main() {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("[script run.js] 📂 Contract Deployed");
  console.log("[script run.js] 🔑 address: ", waveContract.address);

  let waveTxn, allWaves, contractBalance;

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "[script run.js] 💰 Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  waveTxn = await waveContract.wave("Sending 1st Wave!");
  await waveTxn.wait();

  waveTxn = await waveContract.wave("Sending 2nd Wave!");
  await waveTxn.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "[script run.js] 💰 Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  allWaves = await waveContract.getAllWaves();
  console.log("[script run.js] 👋 All wave objects:", allWaves);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
