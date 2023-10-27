import wbtcLogo from "../assets/wbtc.png";
import { FaRegCopy } from "react-icons/fa";
import {
  useAccount,
  useContractWrite,
  usePrepareContractWrite,
  usePublicClient,
  useWaitForTransaction,
  useWalletClient,
} from "wagmi";
import { wbtcContractConfig, vaultContractConfig } from "../utils/contracts";
import { useState } from "react";

const Card = () => {
  const { address } = useAccount();
  const [amount, setAmount] = useState(0);
  // Approve actions
  const { config: approveConfig } = usePrepareContractWrite({
    ...wbtcContractConfig,
    functionName: "approve",
    enabled: true,
    args: [
      vaultContractConfig.address as `0x${string}`,
      BigInt(amount * 10 ** 8),
    ],
  });
  const {
    data: receiptApprove,
    isLoading: isPendingApprove,
    isSuccess: isSuccessApprove,
    write: writeApprove,
    data: dataApprove,

    isError: isErrorApprove,
  } = useContractWrite(approveConfig);

  //  Deposit actions

  const { config: depositConfig } = usePrepareContractWrite({
    address: vaultContractConfig.address as `0x${string}`,
    abi: vaultContractConfig.abi,
    functionName: "deposit",
    enabled: true,
    args: [amount * 10 ** 8],
  });
  const {
    write: writeDeposit,
    data: dataDeposit,
    isLoading: isLoadingDeposit,
    isSuccess: isSuccessDeposit,
    isError: isErrorDeposit,
  } = useContractWrite(depositConfig);

  const handleDeposit = () => {
    writeApprove?.();
    writeDeposit?.();
  };
  // Withdraw actions
  const { config: withdrawConfig } = usePrepareContractWrite({
    address: vaultContractConfig.address as `0x${string}`,
    abi: vaultContractConfig.abi,
    functionName: "withdraw",
    enabled: true,
    args: [BigInt(amount * 10 ** 8)],
  });

  const {
    write: writeWithdraw,
    data: dataWithdraw,
    isLoading: isLoadingWithdraw,
    isSuccess: isSuccessWithdraw,
    isError: isErrorWithdraw,
  } = useContractWrite(withdrawConfig);

  const handleWithdraw = () => {
    writeWithdraw?.();
  };
  return (
    <div className="w-[400px] space-y-4 p-5 h-fit bg-[#FFDFDF] rounded-md">
      <div className=" flex justify-around items-center">
        <img src={wbtcLogo} className="object-cover h-10 w-10" alt="Logo" />
        <h1 className="text-lg font-serif font-semibold flex">
          WBTC Multi Asset
          <i className="cursor-pointer">
            <FaRegCopy />{" "}
          </i>
        </h1>
      </div>

      <div>
        <p>
          APY: <span className="text-lg font-semibold ml-4">20%</span>
        </p>
        <p>
          TVL: <span className="text-lg font-semibold ml-4"> $145,977.15</span>
        </p>
      </div>
      {address && (
        <>
          {" "}
          <div className="text-sm">
            <p>
              Deposited: <span className="ml-4">1 WBTC</span>{" "}
            </p>
            <p>
              Value: <span className="ml-4">$ 28,444</span>
            </p>
            <p>
              Wallet Bal: <span className="ml-4">0 WBTC</span>
            </p>
          </div>
          <div className="flex flex-col gap-2 w-[300px]">
            <input
              onChange={(e) => setAmount(parseInt(e.target.value))}
              type="text"
              className="p-2 rounded-md"
              placeholder="Amount"
            />
            <div className="flex justify-center gap-4">
              <button
                onClick={handleDeposit}
                className="bg-indigo-500 font-bold rounded-lg text-white p-2"
                disabled={isErrorApprove || isErrorDeposit || isErrorWithdraw}
              >
                Deposit
              </button>
              <button
                onClick={handleWithdraw}
                className="bg-red-400 font-bold text-white rounded-lg p-2 "
                disabled={isErrorApprove || isErrorDeposit || isErrorWithdraw}
              >
                Withdraw
              </button>
            </div>

            {isErrorApprove && <p>ERROR 🔴</p>}
          </div>
        </>
      )}
    </div>
  );
};

export default Card;
