import { Route, Routes, Link } from "react-router-dom";
import Heading from "./pages/Heading";
import Home from "./pages/Home";
import Mint from "./pages/Mint";
import Staking from "./pages/Staking";
import Lottery from "./pages/Lottery";

import Market from "./pages/Market";
import Test from "./pages/Test";

function App() {
  return (
    <>
      <Heading />

      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/mint" element={<Mint />} />
        <Route path="/staking" element={<Staking />} />
        <Route path="/Lottery" element={<Lottery />} />
        <Route path="/test" element={<Test />} />
      </Routes>
    </>
  );
}

export default App;
