ARG SPIGOT_VER="1.18.2"

FROM openjdk:17-jdk-alpine AS spigot
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

#2020-10-28 survivalモードの時にworldguardが入っているとあらゆる設定が正しくても何故か被ダメなどが無効化される
#animalはspawnするがcreatureはspawnしない。reloadすると正しくなるので設定ミスではなさそう
#survivalならではの要素を使う場合はWG/WEを抜くの推奨？
RUN wget "https://mediafiles.forgecdn.net/files/3677/516/worldguard-bukkit-7.0.7-dist.jar" && wget "https://mediafiles.forgecdn.net/files/3922/624/worldedit-bukkit-7.2.12.jar"

FROM openjdk:17-jdk-alpine AS utc

ARG SPIGOT_VER

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
