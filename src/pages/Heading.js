import React from "react";
import { Link } from "react-router-dom";
import { Navbar, Container, Nav } from "react-bootstrap";

function Heading() {
  const isLogin = window.sessionStorage.getItem("isLogin") || false;

  return (
    <>
      <Navbar bg="light" expand="lg">
        <Container>
          {/* <Navbar.Brand href="/home"></Navbar.Brands> */}
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <Link
                to="/"
                style={{
                  color: "black",
                  textDecoration: "none",
                  marginRight: "25px",
                  fontSize: "20px",
                }}
              >
                Home
              </Link>
              <Link
                to="/mint"
                style={{
                  color: "black",
                  textDecoration: "none",
                  marginRight: "25px",
                  fontSize: "20px",
                }}
              >
                Mint
              </Link>
              <Link
                to="/staking"
                style={{
                  color: "black",
                  textDecoration: "none",
                  marginRight: "25px",
                  fontSize: "20px",
                }}
              >
                Staking
              </Link>
              <Link
                to="/Lottery"
                style={{
                  color: "black",
                  textDecoration: "none",
                  marginRight: "25px",
                  fontSize: "20px",
                }}
              >
                Lottery
              </Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    </>
  );
}

export default Heading;
