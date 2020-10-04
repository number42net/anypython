FROM alpine
WORKDIR /

# Install packages
RUN apk add --no-cache bash openssh-client git python3 py3-pip

# Add git host key
RUN mkdir ~/.ssh
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts


COPY startup.sh /startup.sh

ENTRYPOINT ["/startup.sh"]
