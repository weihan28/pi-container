FROM node:slim

RUN apt update \
    && apt full-upgrade -y \
    && apt install -y \
        curl \
        jq \
    && npm install -g @earendil-works/pi-coding-agent

USER 1000

CMD ["sleep", "infinity"]