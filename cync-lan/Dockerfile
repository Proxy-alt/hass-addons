ARG BUILD_FROM
FROM $BUILD_FROM

ENV PYTHONUNBUFFERED=1
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# NO build-time certificate generation, deliberately - and so no openssl.
#
# This used to run `openssl req -x509 ...`, baking one key pair into the built
# add-on image so that every install shared a single private key, extractable
# by anyone who pulls it.
#
# It was also redundant. cync_lan.server._ensure_self_signed_cert generates the
# pair at startup whenever either file is missing, with identical parameters
# (RSA 4096, CN=*.xlink.cn, self-signed, 3650 days). Creating the files here is
# exactly what stopped it running - it returns early when both already exist.
# run.sh starts the app through that same library, so removing this means each
# install mints its own key on first start.
#
# openssl goes with it: the CLI was here only for the line above.
ARG BUILD_ARCH
ARG BUILD_VERSION
RUN set -x \
    && apk add --no-cache --no-interactive \
        nano \
        tree \
    && pip install --no-cache-dir -U pip \
    && rm -rf /var/cache/apk/*

# Pinned to a release on PyPI, not to a git branch.
#
# This used to install `git+https://github.com/Proxy-alt/cync-lan@python`,
# which resolves to whatever happens to be on that branch at build time - and
# because config.yaml carries no `image:` key, that build runs on each user's
# own Home Assistant machine, whenever they install or update. So the code
# people received depended on the day they pressed the button, with nothing
# recording which revision they got.
#
# It had already broken. The package was renamed cync_lan -> cync_lan_mqtt
# between 0.0.6b45 and 0.2.2, so branch HEAD stopped providing the module
# run.sh imports, and any rebuild produced a container that died on startup.
#
# The version below is kept in step with cync-lan/upstream by the subtree-sync
# workflow, alongside config.yaml's. Installing from PyPI also removes the need
# for git in the image at all.
ARG BUILD_ARCH
ARG BUILD_VERSION
RUN set -x \
    && pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir "cync-lan-mqtt==0.2.2"

ENV CYNC_HOST="0.0.0.0" \
    CYNC_DEBUG=0 \
    CYNC_RAW_DEBUG=0 \
    CYNC_TOPIC="cync_lan_hass" \
    CYNC_MQTT_PORT=1883 \
    CYNC_MQTT_HOST="homeassistant.local" \
    CYNC_MQTT_USER="" \
    CYNC_MQTT_PASS="" \
    CYNC_HASS_TOPIC="homeassistant" \
    CYNC_HASS_STATUS_TOPIC="status" \
    CYNC_HASS_BIRTH_MSG="online" \
    CYNC_HASS_WILL_MSG="offline" \
    CYNC_MQTT_CONN_DELAY=10 \
    CYNC_CMD_BROADCASTS=2 \
    CYNC_MAX_TCP_CONN=8 \
    CYNC_TCP_WHITELIST="" \
    CYNC_OVERWRITE_CONFIG_FILE=yes \
    CYNC_BASE_DIR="/root/cync-lan" \
    CYNC_STATIC_DIR="/root/cync-lan/www" \
    CYNC_CONFIG_DIR="/homeassistant/.storage/cync-lan/config" \
    CYNC_HASS_APP="yes"

# Copy data for app
COPY static/ /root/cync-lan/www/

EXPOSE 23779 23778

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]