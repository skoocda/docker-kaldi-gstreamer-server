FROM skoocda/docker-kaldi-gstreamer-server
MAINTAINER Danny Lloyd <dlloyd.cda@gmail.com>

# This is the practical example part

RUN mkdir -p /opt/models && cd /opt/models && \
    wget http://sprezatestlanguagemodels.s3.amazonaws.com/tedlium_nnet_ms_sp_online.tgz && \
    tar -zxvf tedlium_nnet_ms_sp_online.tgz && \
    wget https://raw.githubusercontent.com/skoocda/kaldi-gstreamer-server/master/multi_hypothesis.yaml -P /opt/models && \
    find /opt/models/ -type f | xargs sed -i 's:test:/opt:g' && \
    sed -i 's:full-post-processor:#full-post-processor:g' /opt/models/sample_english_nnet2.yaml

RUN apt-get update && \
    apt-get install -y supervisor && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
