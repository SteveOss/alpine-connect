#!/bin/sh
set -e
export CONN_HOME=/opt/Vortex/vcs_${CONNECT_VERSION}
LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$CONN_HOME/lib:$LD_LIBRARY_PATH
ls -l /data/xml
exec /opt/Vortex/vcs_${CONNECT_VERSION}/bin/connect /data/xml/container.xml
