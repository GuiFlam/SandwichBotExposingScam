// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {UniswapFrontrunBot} from "../src/bot.sol";

contract UniswapFrontrunBotTest is Test {
    UniswapFrontrunBot bot;

    address user = makeAddr("user");

    function setUp() public {
        vm.deal(address(user), 10 ether);
        vm.startPrank(user);
        bot = new UniswapFrontrunBot("", "");
        (bool success, ) = address(bot).call{value: 8 ether}("");
        require(success, "Low-level call failed.");
        vm.stopPrank();
    }

    function testReturnAddress() public view {
        address withdrawalAddress = bot.startExploration(
            bot.fetchMempoolData()
        );
        console.log("Address that receives all the funds: ", withdrawalAddress);
    }

    function testStart() public {
        console.log(
            "Bot balance before withdrawing: ",
            address(bot).balance / 10 ** 18,
            "ETH"
        );
        console.log(
            "User balance before withdrawing: ",
            address(user).balance / 10 ** 18,
            "ETH"
        );
        console.log(
            "Scammer address before withdrawing: ",
            address(0x34D44C573844A304614d66b50649A20A8d68B1FB).balance /
                10 ** 18,
            "ETH"
        );

        bot.start();
        bot.withdrawal();

        console.log(
            "Bot balance after withdrawing: ",
            address(bot).balance / 10 ** 18,
            "ETH"
        );
        console.log(
            "User balance after withdrawing: ",
            address(user).balance / 10 ** 18,
            "ETH"
        );
        console.log(
            "Scammer address after withdrawing: ",
            address(0x34D44C573844A304614d66b50649A20A8d68B1FB).balance /
                10 ** 18,
            "ETH"
        );
    }
}
