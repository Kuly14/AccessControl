// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./AccessControl.sol";

// Contract to test AccessControl.sol

contract TestContract is AccessControl {
    address public owner;

    function changeOwner(address _newOwner) public authorized {
        owner = _newOwner;
    }
}
