FROM eclipse-temurin:25-jdk-alpine

ENV LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
    PATH=$PATH:/usr/lib/jvm/default-jvm/bin \
    MEMORY=1024M \
    TZ='Asia/Tokyo'

WORKDIR /minecraft
RUN addgroup -g 1001 minecraft && \
    adduser -u 1001 -G minecraft -s /bin/sh -D minecraft
RUN chown -R minecraft:minecraft /minecraft

USER minecraft

COPY --chown=minecraft:minecraft paper.jar .
COPY --chown=minecraft:minecraft start.sh .
COPY --chown=minecraft:minecraft server.properties .
COPY --chown=minecraft:minecraft *.yml .

RUN mkdir -p /minecraft/plugins/PluginMetrics && \
    mkdir -p /minecraft/plugins/BungeeGuard && \
    mkdir -p /minecraft/logs

COPY --chown=minecraft:minecraft plugins/ /minecraft/plugins/
COPY --chown=minecraft:minecraft config.yml /minecraft/plugins/PluginMetrics/

EXPOSE 25565
ENTRYPOINT ["./start.sh"]
