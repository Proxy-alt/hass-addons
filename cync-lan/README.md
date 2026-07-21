>[!IMPORTANT]
> DNS redirection is REQUIRED, please see [here](https://github.com/Proxy-alt/cync-lan/tree/python/docs/DNS.md) for documentation and examples

>[!WARNING]
> It is **HIGHLY** recommended that you do **NOT** do any firmware upgrades to Cync devices after running cync-lan. 
> It is extremely (change 1 param in a constructor or config) easy for Savant to disable this method of local control.
> While new methods may restore functionality, I'd rather not go down that route.


![Local Push Polling][polling-shield]
![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

Huge thanks to [@CodeNeedsCoffee](https://github.com/CodeNeedsCoffee) for the initial work on the App!

CyncLAN is a software stack 'bridge' for Cync / C by GE smart devices, allowing you to control **supported** smart devices directly from Home Assistant.

This add-on provides:
- __exporter__: An async `fastapi` server that hosts a static ingress page and an API to export a device list from a Cync cloud account using 2FA (emailed OTP) [Token caching supported!]

- __nCync__: An async TCP socket server that *masquerades as the __Cync cloud controller__*

- __comms__: An async `aiomqtt` MQTT client for communication to HASS using the HASS MQTT JSON schema

# Supported devices
See [known devices](https://github.com/Proxy-alt/cync-lan/tree/python/docs/known_devices.md)
for the full, current list.

#### MOSTLY SUPPORTED
- lights
- plugs
- switches
- fan controllers (on/off, percentage, and preset-speed control, with real
  state sync back from the device)
- standalone battery-powered motion sensor accessory, and the battery-powered
  "Wireless Switch" scene remote - both exposed as `occupancy` binary sensors

#### NOT SUPPORTED
- Most other battery-powered devices remain BTLE send-only from this add-on's
  perspective (no way to push settings/firmware to them), aside from the two
  motion/wireless-switch accessories above
    - Wire-free light switches/dimmers
    - Temperature/humidity sensors not bound to a thermostat

#### UNTESTED
- Cameras
- Thermostat and temp sensors
- Dynamic functions (the lights should still work, just dont know about dynamic functions)


[polling-shield]: https://img.shields.io/badge/Polling-Local_Push-blue.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg