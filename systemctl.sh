#! /bin/bash
set -exo nounset

[ $# -eq 1 ] || exit 1

#pushd ~/dockerfiles/$1
pushd $1
docker build -t $1 .
popd

cat > /etc/systemd/system/docker-$1.service << EOF
# https://better-coding.com/autostart-how-to-run-a-service-on-linux-boot-time-using-systemd/

[Unit]
Description=Docker $1 container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a $1
ExecStop=/usr/bin/docker stop -t 10 $1

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable docker-$1.service
systemctl start  docker-$1.service
systemctl status docker-$1.service

