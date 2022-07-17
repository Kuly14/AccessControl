// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// @author Kulk0

contract AccessControl {
    event AccessGranted(bytes4 _sig, address _user);
    event AccessRevoked(bytes4 _sig, address _user);
    event AdminChanged(address _newAdmin);

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    mapping(bytes4 => mapping(address => bool)) private sig;

    modifier isAdmin() {
        require(admin == msg.sender, "Admin != msg.sender");
        _;
    }

    modifier authorized() {
        require(isAuthorized(msg.sig, msg.sender), "Not Authorized");
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
