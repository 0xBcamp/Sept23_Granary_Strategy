import Nav from "./components/Nav";
import Card from "./components/Card";

function App() {
  return (
    <div className="max-w-5xl mx-auto">
      <Nav />
      <div className="grid place-items-center mt-5">
        <Card />
      </div>
    </div>
  );
}

export default App;
