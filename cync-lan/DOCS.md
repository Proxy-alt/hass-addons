# CyncLAN Bridge

Huge thanks to [@CodeNeedsCoffee](https://github.com/CodeNeedsCoffee) for the initial work on the App!

CyncLAN bridge is a software stack that allows Home Assistant to communicate with Cync (formerly C by GE) 
smart devices over a local network connection, bypassing the need for cloud services.
This app uses MQTT for communication and supports auto-discovery of devices in Home Assistant.

You must use [DNS redirection](https://github.com/Proxy-alt/cync-lan/tree/python/docs/DNS.md) to forward: 
- `cm-sec.gelighting.com`
- `cm.gelighting.com`
- `cm-ge.xlink.cn`

to your Home Assistant server's local IP address. This will trick Cync devices into connecting to the `nCync` 
(say: _bye, bye, bye_ to Cloud only) TCP socket server running in this app, enabling you to control your devices locally.

>[!NOTE]
> You will still need to use the Cync app to add new devices to your Cync account. 
> Once added and a new config is exported, you can control the newly added devices locally

>[!WARNING]
> If you have **network wide** DNS redirection enabled (*every* device is redirected for `xxx.gelighting.com`), you must
> disable the DNS redirection to add new devices to the cloud account. It will allow you to get to the very last stage
> **"Adding to Home"** and then fail if DNS redirection is happening to the Cync app and the new device you are trying to add.
> The new device must talk to the cloud once to be registered with your account before it can be exported. Then you can redirect them.


## First Run Steps
>[!IMPORTANT]
> Before you can manage your devices locally, you must export your Cync device list from the Cync cloud API
> using the apps ingress page.

1. Configure the Cync account username, account password and MQTT broker connection details in the app configuration.
2. Set `secret_key` to any random alphanumeric string of your choosing and keep it stable - it encrypts the cached Cync
   cloud auth token at rest, and changing it later just forces a re-login, nothing more.
3. Start the app
4. See [exporting device configuration](#exporting-device-configuration)

>[!NOTE]
> If you're looking for the newer native Home Assistant integration instead
> (installed through HACS, no Docker/MQTT/`secret_key` setup at all), see
> [`custom_components/cync_lan/README.md`](https://github.com/Proxy-alt/cync-lan/tree/feature/ha-custom-component/custom_components/cync_lan/README.md)
> in the main cync-lan repository - it's a separate installation path from this App.

---

## Exporting Device Configuration
Visit the CyncLAN 'ingress' webpage (from the sidebar, or from the app page `Open Web UI` button). You will be 
greeted with a simple form that has provisions for being sent an OTP and to enter and submit the OTP.

- The `Start Export` button will check for a cached access token and use it to export your device config, removing the need for an OTP email to be sent
  - If no cached access token is found, the button will initiate the export process by sending your Cync account credentials to the Cync cloud API and requesting an OTP to be sent to your account email address
- The `Submit OTP` button will evaluate the OTP textbox and send the OTP to the backend export server
    - You can also request an OTP from the Cync app and then use the Submit OTP button, bypassing the `Start Export` button.
    - After submitting an OTP, the backend will use the OTP and Cync account creds to generate a new access token
    - The access token and metadata are stored on disk in a cache for future operations (Cync sets a 24 hr expiration on new access tokens)
      - Cync cloud API supplies a refresh token, but I need to figure out the endpoint and data structure to use it for renewing access tokens
- After a successful export, the `cync_mesh.yaml` contents will be displayed in a text-box with syntax highlighting (via PRISM) with a `Copy` button. Also, a `Download Config File` button will be available to allow downloading the newly exported config
  - The config file is saved to disk (overwriting any existing `cync_mesh.yaml` file) and the app will use it after a restart

---

## Migration
To perform a seamless migration from the non app setup:
- SSH into HASS
- create a folder to hold the config in the correct location: `mkdir -p /homeassistant/.storage/cync-lan/config`
- copy your existing `cync_mesh.yaml` into the new dir: `cp /path/to/cync_mesh.yaml /homeassistant/.storage/cync-lan/config`
- Start the app, it will automatically detect the existing config and use it
- Change your DNS redirection to point to the Home Assistant server's local IP address
- Power cycle the Cync devices, so they perform a DNS request and get the new IP address of the CyncLAN bridge

## Tips / Troubleshooting
See the [tips documentation](https://github.com/Proxy-alt/cync-lan/tree/python/docs/tips.md) for tips on how to have a better experience with the app.

See the [troubleshooting documentation](https://github.com/Proxy-alt/cync-lan/tree/python/docs/troubleshooting.md) for common issues and how to resolve them.