import { useRef } from "react";
import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract, useScaffoldContractRead } from "~~/hooks/scaffold-eth";

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

  function convertTimestampToString(unixTimestamp: string): string {
    const timestampInSeconds = parseInt(unixTimestamp, 10);
    const date = new Date(timestampInSeconds * 1000);

    return date.toLocaleString();
  }

  const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });
  console.log("yourContract: ", yourContract);

  return (
    <div className="flex flex-col justify-center items-center bg-[length:100%_100%] py-10 px-5 sm:px-0 lg:py-auto max-w-[100vw] ">
      <div className={`flex flex-col max-w-2xl bg-base-200 bg-opacity-70 rounded-2xl shadow-md px-6 py-5 w-full`}>
        <div className="mt-3 overflow-hidden text-[20px] whitespace-nowrap w-full font-bai-jamjuree">
          {startTime !== undefined && endTime !== undefined && (
            <div>
              <span className="text-lg">Time Range: {convertTimestampToString(startTime.toString())}</span>
              <span className="text-lg"> - {convertTimestampToString(endTime.toString())}</span>
            </div>
          )}
          <div className="relative overflow-x-hidden" ref={containerRef}>
            <div className="p-6">
              <table className="min-w-full divide-y divide-gray-200">
                <thead>
                  <tr>
                    <th>Rank</th>
                    <th>Address</th>
                    <th>Level</th>
                    <th>Credit</th>
                  </tr>
                </thead>
                <tbody>
                  {userArray && userArray.map((user, index) => (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td><Address address={user.userAddress} /></td>
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
