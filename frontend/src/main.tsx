import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

import "@rainbow-me/rainbowkit/styles.css";
import { getDefaultWallets, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import { Chain, configureChains, createConfig, WagmiConfig } from "wagmi";
import { hardhat, optimism } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";
import { MockProvider } from "@wagmi/connectors/mock";

export const op = {
  id: 10,
  name: "Op-fork",
  network: "op",
  nativeCurrency: {
    decimals: 18,
    name: "ETH",
    symbol: "ETH",
  },
  rpcUrls: {
    public: {
      http: [
        "https://rpc.tenderly.co/fork/42761568-1898-4e4d-9ae6-78a476d12fc5",
      ],
    },
    default: {
      http: [
        "https://rpc.tenderly.co/fork/42761568-1898-4e4d-9ae6-78a476d12fc5",
      ],
    },
  },
  blockExplorers: {
    etherscan: { name: "SnowTrace", url: "https://snowtrace.io" },
    default: { name: "SnowTrace", url: "https://snowtrace.io" },
  },
  contracts: {
    multicall3: {
      address: "0xca11bde05977b3631167028862be2a173976ca11",
      blockCreated: 11_907_934,
    },
  },
} as const satisfies Chain;

const { chains, publicClient } = configureChains([op], [publicProvider()]);
const { connectors } = getDefaultWallets({
  appName: "My RainbowKit App",
  projectId: "YOUR_PROJECT_ID",
  chains,
});
// const connector = new MetaMaskConnector();
const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <WagmiConfig config={wagmiConfig}>
      <RainbowKitProvider chains={chains}>
        <App />
      </RainbowKitProvider>
    </WagmiConfig>
  </React.StrictMode>,
);
