#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
LP='[run.sh]'

bashio::log.info "${LP} Starting CyncLAN Bridge App"
# pull values from the app configuration
export CYNC_SECRET_KEY="$(bashio::config 'secret_key')"
export CYNC_ACCOUNT_USERNAME="$(bashio::config 'account_username')"
export CYNC_ACCOUNT_PASSWORD="$(bashio::config 'account_password')"
export CYNC_TOPIC="$(bashio::config 'mqtt_topic')"
export CYNC_DEBUG="$(bashio::config 'debug_log_level')"
export CYNC_MQTT_HOST="$(bashio::config 'mqtt_host')"
export CYNC_MQTT_PORT="$(bashio::config 'mqtt_port')"
export CYNC_MQTT_USER="$(bashio::config 'mqtt_user')"
export CYNC_MQTT_PASS="$(bashio::config 'mqtt_pass')"
export CYNC_TCP_WHITELIST="$(bashio::config 'tuning' | jq -r '.tcp_whitelist')"
export CYNC_CMD_BROADCASTS="$(bashio::config 'tuning' | jq -r '.command_targets')"
export CYNC_MAX_TCP_CONN="$(bashio::config 'tuning' | jq -r '.max_clients')"
export CYNC_RAW_DEBUG="$(bashio::config 'raw_debug')"
export CYNC_CLOUD_IP="$(bashio::config 'cync_cloud_ip')"
export CYNC_MITM_DEV_LOGGER="$(bashio::config 'dev_mitm_console')"
export CYNC_MITM_APP_LOGGER="$(bashio::config 'app_mitm_console')"
export CYNC_APP_MITM_LOGGING="$(bashio::config 'app_mitm_log')"
export CYNC_MITM_ENTITIES="$(bashio::config 'mitm_entities')"
export CYNC_UNSUPPORTED_RAW_DEBUG="$(bashio::config 'unsupported_device_debug')"
export CYNC_MQTT_DEBUG="$(bashio::config 'mqtt_debug')"

# The module is cync_lan_mqtt, not cync_lan. cync_lan is the core protocol
# library and has never had a main module; the add-on's entry point moved when
# the MQTT daemon was split out into its own package between 0.0.6b45 and
# 0.2.2. Because the Dockerfile installed from branch HEAD, this line started
# failing with ModuleNotFoundError on every rebuild without anything changing
# here.
#
# pyproject.toml also installs a `cync-lan` console script, which does work -
# an older comment here claimed otherwise. The module form is kept because it
# does not depend on PATH inside the s6 environment.
python -c "from cync_lan_mqtt.main import main; main()"