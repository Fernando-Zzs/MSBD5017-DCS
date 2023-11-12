import { useRef, useState } from "react";
import { useAccount } from "wagmi";
import {
  useScaffoldContract,
  useScaffoldContractRead,
  useScaffoldEventHistory,
  useScaffoldEventSubscriber,
} from "~~/hooks/scaffold-eth";

export const ContractData = () => {
  const { address } = useAccount();

  const containerRef = useRef<HTMLDivElement>(null);

  const { data: startTime } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "startTime",
  });

  const { data: endTime } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "endTime",
  });

  const { data: userArray } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "updateUserRanking",
  });

  // useScaffoldEventSubscriber({
  //   contractName: "YourContract",
  //   eventName: "GreetingChange",
  //   listener: logs => {
  //     logs.map(log => {
  //       const { greetingSetter, value, premium, newGreeting } = log.args;
  //       console.log("📡 GreetingChange event", greetingSetter, value, premium, newGreeting);
  //     });
  //   },
  // });

  // const {
  //   data: myGreetingChangeEvents,
  //   isLoading: isLoadingEvents,
  //   error: errorReadingEvents,
  // } = useScaffoldEventHistory({
  //   contractName: "YourContract",
  //   eventName: "GreetingChange",
  //   fromBlock: process.env.NEXT_PUBLIC_DEPLOY_BLOCK ? BigInt(process.env.NEXT_PUBLIC_DEPLOY_BLOCK) : 0n,
  //   filters: { greetingSetter: address },
  //   blockData: true,
  // });

  // console.log("Events:", isLoadingEvents, errorReadingEvents, myGreetingChangeEvents);

  const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });
  console.log("yourContract: ", yourContract);

  return (
    <div className="flex flex-col justify-center items-center bg-[length:100%_100%] py-10 px-5 sm:px-0 lg:py-auto max-w-[100vw] ">
      <div className={`flex flex-col max-w-2xl bg-base-200 bg-opacity-70 rounded-2xl shadow-md px-6 py-5 w-full`}>
        <div className="mt-3 overflow-hidden text-[18px] whitespace-nowrap w-full font-bai-jamjuree">
          <div className="relative overflow-x-hidden" ref={containerRef}>
            <div className="p-6">
              <table className="min-w-full divide-y divide-gray-200">
                <thead>
                  <tr>
                    <th>Address</th>
                    <th>Level</th>
                    <th>Credit</th>
                  </tr>
                </thead>
                <tbody>
                  {userArray && userArray.map((user, index) => (
                    <tr key={index}>
                      <td>{user.userAddress}</td>
                      <td>{user.level}</td>
                      <td>{user.credits?.toString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
