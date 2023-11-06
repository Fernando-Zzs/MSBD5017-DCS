import type { NextPage } from "next";
import { MetaHeader } from "~~/components/MetaHeader";
import { ContractData } from "~~/components/example-ui/ContractData";
import { ContractInteraction } from "~~/components/example-ui/ContractInteraction";

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
            <div className="grid lg:grid-cols-2 flex-grow" data-theme="exampleUi">
                <ContractInteraction />
                <ContractData />
            </div>
        </>
    );
};

export default RecipientRanking;
