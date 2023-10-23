import wbtcLogo from "../assets/wbtc.png";
import { FaRegCopy } from "react-icons/fa";
import {
  useAccount,
  useContractWrite,
  usePrepareContractWrite,
  usePublicClient,
  useWalletClient,
} from "wagmi";
import { erc20ABI } from "wagmi";
import { vaultContract } from "../utils/contracts";
import { vaultAddress } from "../utils/constant";

const Card = () => {
  const { address } = useAccount();
  const { config: approveConfig } = usePrepareContractWrite({
    ...erc20ABI,
    functionName: "approve",
    enabled: true,
    args: [vaultAddress, BigInt(10000000000)],
  });
  const { write: writeApprove, data: dataApprove } =
    useContractWrite(approveConfig);
  // const {
  //   data: receiptApprove,
  //   isLoading: isPendingApprove,
  //   isSuccess: isSuccessApprove,
  // } = useWaitForTransaction({ hash: dataApprove?.hash });

  const handleApprove = () => {
    writeApprove?.();
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
              type="text"
              className="p-2 rounded-md"
              placeholder="Amount"
            />
            <div className="flex justify-center gap-4">
              <button className="bg-indigo-500 font-bold rounded-lg text-white p-2">
                Deposit
              </button>
              <button className="bg-red-400 font-bold text-white rounded-lg p-2 ">
                Withdraw
              </button>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default Card;
