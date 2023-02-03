// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/03-guess-the-random-number.sol";

// aqui puedes agregar un contrato o hacer otro import

contract Challenge3Test is Test {
    GuessTheRandomNumberChallenge target;
    address player = vm.addr(1);

    function setUp() public {
        target = new GuessTheRandomNumberChallenge{value: 1 ether}();
        vm.label(address(target), "Challenge #3");
        vm.label(player, "Player");
        vm.deal(player, 1 ether);
    }

    function testChallenge() public {
        uint8 secret = uint8(uint256(vm.load(address(target), 0)));

        vm.startPrank(address(player));
        target.guess{value: 1 ether}(secret);

        assertTrue(target.isComplete());
    }
}
