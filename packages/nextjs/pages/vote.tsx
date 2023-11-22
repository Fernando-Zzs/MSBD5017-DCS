import type { NextPage } from "next";
import { MetaHeader } from "~~/components/MetaHeader";
import { ContractInteraction } from "~~/components/example-ui/ContractInteraction";
import { UserData } from "~~/components/example-ui/UserData";

const RecipientRanking: NextPage = () => {
    return (
        <>
            <MetaHeader
                title="Recipient Ranking | Scaffold-ETH 2"
                description="Recipient Ranking created with 🏗 Scaffold-ETH 2, showcasing some of its features."
            >
                {/* We are importing the font this way to lighten the size of SE2. */}
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link href="https://fonts.googleapis.com/css2?family=Bai+Jamjuree&display=swap" rel="stylesheet" />
            </MetaHeader>
            <div className="grid lg:grid-cols-3 flex-grow">
                <div className="col-span-1">
                    <UserData />
                </div>
                <div className="col-span-2">
                    <ContractInteraction />
                </div>
            </div>
        </>
    );
};

export default RecipientRanking;
