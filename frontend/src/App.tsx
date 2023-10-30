import Nav from "./components/Nav";
import Card from "./components/Card";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { FaGithub } from "react-icons/fa";
function App() {
  return (
    <div className="max-w-5xl mx-auto">
      <ToastContainer />
      <Nav />
      <div className="grid place-items-center mt-5">
        <Card />
      </div>
      <footer className="flex justify-center items-center gap-2 text-lg">
        <FaGithub />{" "}
        <a
          className="text-blue-600 font-bold"
          href="https://github.com/0xBcamp/Sept23_Granary_Strategy/tree/main"
        >
          MaxiGain
        </a>{" "}
      </footer>
    </div>
  );
}

export default App;
