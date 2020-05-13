FROM alpine


COPY . /data
WORKDIR /data

# bower requires this configuration parameter to allow bower install using root.
RUN echo '{ "allow_root": true }'>.bowerrc

# node-sass doesn't support Alpine, so we need the build toolchain.
RUN apk --update add curl git ca-certificates python build-base nodejs &&\
	npm update -g npm && git clone https://github.com/aksakalli/sandraREST.git &&\
    cp /data/src/cassandra_config.json /data/sandraREST/ &&\
    cp /data/src/bower.json /data/sandraREST/ &&\
    cp /data/src/public/js/services.js /data/sandraREST/public/js/ &&\
    cd /data/sandraREST/ && npm install && npm install bower && node_modules/bower/bin/bower install &&\
    mv /data/sandraREST /cassandra-rest &&\
    ls -la /cassandra-rest/bin &&\    
    rm -rf /data

EXPOSE 8088
ENTRYPOINT ["node"]
CMD ["/cassandra-rest/bin/www"]

