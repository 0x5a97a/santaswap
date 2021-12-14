import "./App.css";
import Connect from "./components/connect";
import Send from "./components/send";
import Unwrap from "./components/unwrap";
import { useChristmasMagic } from "./hooks/contracts";

function App() {
  const { christmasMagic } = useChristmasMagic();

  return (
    <div className="p-16 min-h-screen bg-gradient-to-t from-yellow-50 via-yellow-50 to-white flex flex-col place-items-center text-lg">
      <Connect />
      <div className="text-center mb-8">
        <h1 className="font-extrabold text-4xl md:text-6xl">
          🎅🏻
          <span className="tracking-tighter bg-gradient-to-tr from-red-500 to-red-800 text-transparent bg-clip-text">
            {" "}
            Santaswap{" "}
          </span>
          🎄
        </h1>
      </div>
      {christmasMagic && christmasMagic.eq(0) && <Send />}
      {christmasMagic && christmasMagic.gt(0) && <Unwrap />}
      <div className="fixed bottom-0 w-full bg-yellow-50 py-4 px-8">
        <p className="text-xs text-center">
          Experimental, unaudited, no roadmap, no fees, no Discord, no DAO,
          absolutely no promises…but I want to wish you a Merry Christmas.
        </p>
      </div>
    </div>
  );
}

export default App;
