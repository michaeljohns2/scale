#!/bin/sh

# build scaleConfig.local.json

cat > scaleConfig.local.json << EOF
{
    "scaleConfigLocal": {
        "urls": {
            "apiPrefix": "${SCALE_API_URL}"
        }
    }
}
EOF

if [[ ${ENABLE_NFS}x != x ]]
then
   sudo /usr/sbin/rpcbind
   sudo /usr/sbin/rpc.statd
fi

if [[ ${ENABLE_GUNICORN}x != x ]]
then
    /usr/bin/gunicorn -D -b 0.0.0.0:8000 -w 4 scale.wsgi:application
fi

exec ./manage.py $*
