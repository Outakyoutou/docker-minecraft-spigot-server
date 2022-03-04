ARG SPIGOT_VER="1.18.2"

FROM openjdk:17-alpine AS spigot
ARG SPIGOT_VER
ENV JAVA_HOME=/opt/openjdk-17
ENV PATH=/opt/openjdk-17/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV JAVA_VERSION=17-ea+14

#RUN apk --update add --no-cache screen curl jq python py-pip
RUN apk --update add --no-cache screen

# build spigot https://www.spigotmc.org/wiki/buildtools/
WORKDIR /build
RUN apk --no-cache add git && wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -O BuildTools.jar && java -Xmx1024M -jar BuildTools.jar --rev $SPIGOT_VER
WORKDIR /plg
COPY plugins/ ./
RUN wget "https://media.forgecdn.net/files/3631/603/worldedit-bukkit-7.2.9.jar" && wget "https://media.forgecdn.net/files/3461/546/worldguard-bukkit-7.0.6-dist.jar"

FROM openjdk:17-alpine AS utc

ARG SPIGOT_VER
ENV MEMORY=1024M

WORKDIR /minecraft
RUN mkdir -p ./plugins/PluginMetrics
COPY --from=spigot /build/spigot-${SPIGOT_VER}.jar ./spigot.jar
COPY ./start.sh .
COPY ./server.properties .
COPY ./bukkit.yml .
COPY --from=spigot /plg/ ./plugins/ 
COPY ./config.yml ./plugins/PluginMetrics/

EXPOSE 25565
ENTRYPOINT ["./start.sh"]

FROM utc AS ja_jp

RUN apk add --update --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone && \
  apk del tzdata
