FROM ubuntu
WORKDIR /

# Update aptitude with new repo
RUN apt-get update

# Install software
RUN apt-get install --no-install-recommends -y git python3 python3-pip

COPY startup.sh /startup.sh

ENTRYPOINT ["/startup.sh"]
