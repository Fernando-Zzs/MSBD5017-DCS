import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract, useScaffoldContractRead } from "~~/hooks/scaffold-eth";

export const UserData = () => {
  const { address } = useAccount();
  const { data: yourContract } = useScaffoldContract({ contractName: "YourContract" });
  console.log("yourContract: ", yourContract);
  const { data: DCSTOKEN } = useScaffoldContract({ contractName: "DCSTOKEN" });
  console.log("MyToken: ", DCSTOKEN);

  const { data: token } = useScaffoldContractRead({
    contractName: "DCSTOKEN",
    functionName: "balanceOf",
    args: [address]
  });

  const { data: userArray } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "updateUserRanking",
  });

  function mapNumberToLabel(number: number): string {
    switch (number) {
      case 0:
        return "Basic";
      case 1:
        return "Silver";
      case 2:
        return "Gold";
      case 3:
        return "Platinum";
      default:
        return "Unknown";
    }
  }

  function formatBalance(balance: bigint): string {
    const etherValue = Number(balance) / 10 ** 18;
    return etherValue.toFixed(2);
  }

  return (
    <div className="flex flex-col justify-center items-center bg-[length:100%_100%] py-10 px-5 sm:px-0 lg:py-auto max-w-[100vw] ">
      <div className={`flex flex-col max-w-sm bg-base-200 bg-opacity-70 rounded-2xl shadow-md px-6 py-5 w-full`}>
        <div className="mt-3 overflow-hidden text-[17px] whitespace-nowrap w-full font-bai-jamjuree">
          {userArray &&
            userArray
              .filter((user) => user.userAddress === address)
              .map((user, index) => (
                <div key={index} className="mb-4 p-4 rounded">
                  <div className="flex flex-col">
                    <div>
                      <Address address={user.userAddress} disableAddressLink={true} size="3xl" />
                    </div>
                    <div>
                      <span>LEVEL</span>{" "}
                      {mapNumberToLabel(user.level)}
                    </div>
                    <div>
                      <span>BALANCE</span>{" "}
                      {user.balance?.toString()}
                    </div>
                    <div>
                      <span>CREDITS</span>{" "}
                      {user.credits?.toString()}
                    </div>
                    <div>
                      <span>DCS</span> {token != undefined && formatBalance(token)}
                    </div>
                  </div>
                </div>
              ))}
        </div>
      </div>
    </div>
  );
};
