#!/bin/bash
# shellcheck disable=SC2004,SC2006,SC2034,SC2181

#CAPSULE TO REGISTER THE HOST TO
DEFAULT_CAPSULE="capsuleTestspre.test.es"
#CHANGE DEFAULT REGISTRATION CHANNEL: alfa | estable
DEFAULT_CHANNEL="alfa"

# Define git protocol
cat << EOF >> /home/vagrant/.gitconfig
[http]
sslVerify = false

[credential]
        helper = cache

[url "https://"]
    insteadOf = git://
EOF
# HOSTNAME="`facter hostname 2>/dev/null`"
HOSTNAME="molecule$((1 + $RANDOM % 100000))"

if [ ! -f /root/postinstall/satellite62.sh ]
then
  wget --no-check-certificate https://${DEFAULT_CAPSULE}/pub/satellite62.sh -P /root/postinstall/  # Currently attacking PRO due to connectivity. Should be PRE in the future.
  ln -s /root/postinstall/satellite62.sh /root/postinstall/satellite.sh
  chmod +x /root/postinstall/*.sh
fi

echo "Registering vagrant with hostname ${HOSTNAME}.test.es and channel ${DEFAULT_CHANNEL}..."
bash /root/postinstall/satellite62.sh --action register --capsule ${DEFAULT_CAPSULE} --content current_${DEFAULT_CHANNEL} --host ${HOSTNAME}.test.es &>/dev/null || exit 1
touch /tools/scripts/satellite/dummy.txt
