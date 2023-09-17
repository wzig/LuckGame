// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// // NOTE: Deploy this contract first
// contract B {
//     // NOTE: storage layout must be the same as contract A
//     uint public num;
//     address public sender;
//     uint public value;

//     function setVars(uint _num) public payable {
//         num = _num;
//         sender = msg.sender;
//         value = msg.value;
//     }
// }

// contract A {
//     uint public num;
//     address public sender;
//     uint public value;

//     function setVars(address _contract, uint _num) public payable {
//         // A's storage is set, B is not modified.
//         (bool success, bytes memory data) = _contract.delegatecall(
//             abi.encodeWithSignature("setVars(uint256)", _num)
//         );
//     }
// }


// import "../../lib/forge-std/src/Test.sol";

// contract TestTest is Test {
//     WrapperContract public instance;
//     TargetContract public instanceT;
//     uint forkID;

//     function setUp() public {
//         forkID = vm.createSelectFork("mainnet", 17999182);

//         address owner = 0x060FcF541c7444F439C0c4e83001634853dc59Da;
//         vm.deal(owner, 1000 ether);

//         vm.prank(owner);
//         instanceT = new TargetContract();
//         instance = new WrapperContract(address(instanceT));

//         emit log_named_address("address(instance)", address(instance));

//         emit log_string("====> start");
//     }

//     function testName() public {
//         instance.forwardCall();
//     }
// }
