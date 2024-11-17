
const IoTSecurity = artifacts.require("IoTSecurity");

contract("IoTSecurity", (accounts) => {
    it("should register a device", async () => {
        const instance = await IoTSecurity.deployed();
        await instance.registerDevice("device1", { from: accounts[0] });
        const isRegistered = await instance.checkAccess.call("device1", "device1");
        assert.equal(isRegistered, false, "Device should not have self-access initially");
    });

    it("should grant access between devices", async () => {
        const instance = await IoTSecurity.deployed();
        await instance.grantAccess("device1", "device2", { from: accounts[0] });
        const hasAccess = await instance.checkAccess.call("device1", "device2");
        assert.equal(hasAccess, true, "Access should be granted");
    });

    it("should revoke access between devices", async () => {
        const instance = await IoTSecurity.deployed();
        await instance.revokeAccess("device1", "device2", { from: accounts[0] });
        const hasAccess = await instance.checkAccess.call("device1", "device2");
        assert.equal(hasAccess, false, "Access should be revoked");
    });
});
