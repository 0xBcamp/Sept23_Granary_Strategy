import { ConnectButton } from "@rainbow-me/rainbowkit";

const Nav = () => {
  return (
    <div className="flex justify-between  shadow-sm rounded p-5 ">
      <h1 className="font-bold text-3xl ">Maxi Vault</h1>
      <ConnectButton />
    </div>
  );
};

export default Nav;
