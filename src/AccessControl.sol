// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// @author Kuly14

/**
 * Simple contract that allows the admin to give permissions to users
 * If you want to restrict access to some function just add the modifier authorized
 * This modifier will check if the user was first approved to call that function.
 * If admin wants to give somebody permission he needs the selector of the function and address of the user
 * Then he calls grantAccess(selector, address). Now the user can call that specific function.
 */

contract AccessControl {
    error notAdmin(address _msgSender);
    error notAuthorized(bytes4 _sig, address _msgSender);

    event AccessGranted(bytes4 _sig, address _user);
    event AccessRevoked(bytes4 _sig, address _user);
    event AdminChanged(address _newAdmin);

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    mapping(bytes4 => mapping(address => bool)) private sig;

    modifier isAdmin() {
        if (admin != msg.sender) {
            revert notAdmin(msg.sender);
        }
        _;
    }

    modifier authorized() {
        if (isAuthorized(msg.sig, msg.sender) == false) {
            revert notAuthorized(msg.sig, msg.sender);
        }
        _;
    }

    function changeAdmin(address _newAdmin) external isAdmin {
        admin = _newAdmin;
        emit AdminChanged(_newAdmin);
    }

    function grantAccess(bytes4 _sig, address _account) external isAdmin {
        _grantAccess(_sig, _account);
        emit AccessGranted(_sig, _account);
    }

    function revokeAccess(bytes4 _sig, address _account) external isAdmin {
        _revokeAccess(_sig, _account);
        emit AccessRevoked(_sig, _account);
    }

    function isAuthorized(bytes4 _sig, address _account)
        public
        view
        returns (bool)
    {
        return sig[_sig][_account];
    }

    ////////////////// INTERNAL FUNCTIONS ////////////////////////
    function _grantAccess(bytes4 _sig, address _account) internal {
        sig[_sig][_account] = true;
    }

    function _revokeAccess(bytes4 _sig, address _account) internal {
        sig[_sig][_account] = false;
    }
}
