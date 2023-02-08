import React, { useState } from "react";

import "./ToggleButton.css";

const ToggleButtons = (props) => {
  const [selectedButtons, setSelectedButtons] = useState([]);

  const handleClick = (button) => {
    if (selectedButtons.includes(button)) {
      setSelectedButtons(selectedButtons.filter((b) => b !== button));
    } else if (selectedButtons.length < 5) {
      setSelectedButtons([...selectedButtons, button]);
    }

    props.setNumbers(selectedButtons);
    console.log(selectedButtons);
  };

  return (
    <div
      className="toggle-button-container"
      style={{
        margin: "50px",
        padding: "50px",
        width: "500px",
        display: "grid",
        gridTemplateColumns: "1fr 1fr 1fr 1fr 1fr",
      }}
    >
      {[...Array(45).keys()].map((button) => (
        <button
          key={button}
          className={`toggle-button ${
            selectedButtons.includes(button) ? "active" : ""
          }`}
          onClick={() => handleClick(button)}
          disabled={
            selectedButtons.length >= 5 && !selectedButtons.includes(button)
          }
        >
          {button + 1}
        </button>
      ))}
    </div>
  );
};

export default ToggleButtons;
