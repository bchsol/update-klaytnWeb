import { Route, Routes, Link } from "react-router-dom";
import Heading from "./pages/Heading";
import Home from "./pages/Home";
import Mint from "./pages/Mint";
import Staking from "./pages/Staking";
import Lottery from "./pages/Lottery";

function App() {
  return (
    <>
      <Heading />

      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/mint" element={<Mint />} />
        <Route path="/staking" element={<Staking />} />
        <Route path="/Lottery" element={<Lottery />} />
      </Routes>
    </>
  );
}

export default App;
