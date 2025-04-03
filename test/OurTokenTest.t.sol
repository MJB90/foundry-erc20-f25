//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;

        //Bob approves alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 trasferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, trasferAmount);

        assertEq(ourToken.balanceOf(alice), trasferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - trasferAmount);
    }
}
