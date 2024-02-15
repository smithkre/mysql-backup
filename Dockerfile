FROM mysql:8.0-debian

# Install MySQL and AWS CLI
RUN apt-get update && \
    apt-get install -y awscli tar && \
    rm -rf /var/lib/apt/lists/*

# Add your backup script
COPY backup-script.sh /backup-script.sh
RUN chmod +x /backup-script.sh

CMD ["/backup-script.sh"]
