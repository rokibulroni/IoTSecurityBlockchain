
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IoTSecurity {

    struct Device {
        string uid;
        address owner;
        bool isRegistered;
    }

    mapping(string => Device) private devices;
    mapping(string => mapping(string => bool)) private accessPermissions;

    event DeviceRegistered(string uid, address owner);
    event AccessGranted(string deviceA, string deviceB);
    event AccessRevoked(string deviceA, string deviceB);
    event UnauthorizedAccessAttempt(string deviceA, string deviceB, address requester);

    modifier onlyOwner(string memory uid) {
        require(devices[uid].owner == msg.sender, "Not the owner of this device");
        _;
    }

    function registerDevice(string memory uid) public {
        require(!devices[uid].isRegistered, "Device already registered");
        devices[uid] = Device(uid, msg.sender, true);
        emit DeviceRegistered(uid, msg.sender);
    }

    function grantAccess(string memory deviceA, string memory deviceB) public onlyOwner(deviceA) {
        accessPermissions[deviceA][deviceB] = true;
        emit AccessGranted(deviceA, deviceB);
    }

    function revokeAccess(string memory deviceA, string memory deviceB) public onlyOwner(deviceA) {
        accessPermissions[deviceA][deviceB] = false;
        emit AccessRevoked(deviceA, deviceB);
    }

    function checkAccess(string memory deviceA, string memory deviceB) public view returns (bool) {
        return accessPermissions[deviceA][deviceB];
    }

    function requestAccess(string memory deviceA, string memory deviceB) public {
        if (accessPermissions[deviceA][deviceB]) {
            // Access allowed
        } else {
            emit UnauthorizedAccessAttempt(deviceA, deviceB, msg.sender);
        }
    }
}
