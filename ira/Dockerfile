
FROM monetdb/monetdb-r-docker
LABEL mantainer="zysam<explnwind@gmail.com"

WORKDIR /home/monetdb

COPY scripts/set-monetdb-password.sh /home/monetdb/set-monetdb-password.sh
RUN chmod +x /home/monetdb/set-monetdb-password.sh

COPY ./docker-entrypoint.sh /home/monetdb/docker-entrypoint.sh
RUN chmod +x /home/monetdb/docker-entrypoint.sh

CMD ["/home/monetdb/docker-entrypoint.sh"]

EXPOSE 50000
VOLUME [ "/var/monetdb5" ]


