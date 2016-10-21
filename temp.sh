#!/bin/bash

cat >> /tmp/supervisord.conf <<EOT
[supervisord]
nodaemon=true
[program:worker]
environment=GST_PLUGIN_PATH=/opt/gst-kaldi-nnet2-online/src/:/opt/kaldi/src/gst-plugin/
command=python /opt/kaldi-gstreamer-server/kaldigstserver/worker.py -c /opt/models/english/multi.yaml -u ws://52.45.237.54/worker/ws/speech
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/opt/worker.log
EOT
