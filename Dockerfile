FROM spritsail/alpine:3.15

ARG MC_VER=1.18.1
ARG JRE_VER=17
LABEL maintainer="Spritsail <minecraft@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Minecraft server" \
      org.label-schema.url="https://minecraft.net/en-us/download/server/" \
      org.label-schema.description="Minecraft server" \
      org.label-schema.version=${MC_VER}

RUN apk --no-cache add openjdk${JRE_VER}-jre nss curl jq && \
    \
    curl -fsSL https://launchermeta.mojang.com/mc/game/version_manifest.json \
        | jq -r ".versions[] | select(.id == \"$MC_VER\") | .url" \
        | xargs curl -fsSL \
        | jq -r ".downloads.server.url" \
        | xargs curl -fsSL -o /minecraft_server.jar && \
    \
    apk --no-cache del jq

WORKDIR /mc

ENV INIT_MEM=1G \
    MAX_MEM=4G \
    SERVER_JAR=/minecraft_server.jar

CMD exec java "-Xms$INIT_MEM" "-Xmx$MAX_MEM" -jar "$SERVER_JAR" nogui
