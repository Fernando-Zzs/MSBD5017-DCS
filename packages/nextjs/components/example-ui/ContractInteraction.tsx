import { ArrowSmallRightIcon } from "@heroicons/react/24/outline";
import { useState } from "react";
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export const ContractInteraction = () => {
  const [reciAddr, setReciAddr] = useState("");
  const [amount, setAmount] = useState("");

  const { writeAsync, isLoading } = useScaffoldContractWrite({
    contractName: "YourContract",
    functionName: "transferTokens",
    args: [reciAddr, BigInt(amount)],
    onBlockConfirmation: txnReceipt => {
      console.log("📦 Transaction blockHash", txnReceipt.blockHash);
    },
  });

  return (
    <div className="flex justify-center items-center bg-base-200 relative pb-10">
      {/* <DiamondIcon className="absolute top-24" />
      <CopyIcon className="absolute bottom-0 left-36" />
      <HareIcon className="absolute right-0 bottom-24" /> */}
      <div className="flex flex-col w-full mx-5 sm:mx-8 2xl:mx-20">
        <div className="flex flex-col mt-6 px-7 py-8 bg-base-200 opacity-80 rounded-2xl shadow-lg border-2 border-primary">
          <span className="text-4xl sm:text-3xl font-bai-jamjuree">Vote Board</span>

          <div className="mt-8 flex flex-col items-start sm:items-center gap-2 sm:gap-5">
            <input
              type="text"
              placeholder="Recipient Address..."
              className="input font-bai-jamjuree w-full px-5 bg-[length:100%_100%] border border-primary sm:text-lg placeholder-grey uppercase"
              onChange={(e) => setReciAddr(e.target.value)}
            />

            <input
              type="number"
              min="1"
              max="100"
              placeholder="Amount"
              className="input font-bai-jamjuree w-full px-5 bg-[length:100%_100%] border border-primary sm:text-lg placeholder-grey uppercase"
              onChange={(e) => setAmount(e.target.value)}
            />

            <button
              className="btn btn-primary rounded-full capitalize font-normal font-white w-24 flex items-center gap-1 hover:gap-2 transition-all tracking-widest"
              onClick={() => writeAsync()}
              disabled={isLoading}
            >
              {isLoading ? (
                <span className="loading loading-spinner loading-sm"></span>
              ) : (
                <>
                  VOTE <ArrowSmallRightIcon className="w-3 h-3 mt-0.5" />
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
