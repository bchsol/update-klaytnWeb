import React, { useState, useEffect } from "react";

import "./ToggleButton.css";

const ToggleButtons = (props) => {
  const [selectedButtons, setSelectedButtons] = useState([]);

  useEffect(() => {
    props.setNumbers(selectedButtons);
  }, [selectedButtons, props]);

  const handleClick = (button) => {
    if (selectedButtons.includes(button)) {
      setSelectedButtons(selectedButtons.filter((b) => b !== button));
    } else if (selectedButtons.length < 6) {
      setSelectedButtons([...selectedButtons, button]);
    }
  };

  return (
    <div
      className="toggle-button-container"
      style={{
        padding: "50px",
        display: "grid",
        gridTemplateColumns: "1fr 1fr 1fr 1fr 1fr",
      }}
    >
      {[...Array(45).keys()].map((button) => (
        <button
          key={button}
          className={`toggle-button ${
            selectedButtons.includes(button + 1) ? "active" : ""
          }`}
          onClick={() => handleClick(button + 1)}
          disabled={
            selectedButtons.length >= 6 && !selectedButtons.includes(button + 1)
          }
        >
          {button + 1}
        </button>
      ))}
    </div>
  );
};

export default ToggleButtons;
