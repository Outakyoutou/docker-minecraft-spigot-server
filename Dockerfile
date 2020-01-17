ARG SPIGOT_VER="1.15.1"

FROM openjdk:8-jdk-alpine AS spigot
ARG SPIGOT_VER

# build spigot https://www.spigotmc.org/wiki/buildtools/
WORKDIR /build
RUN apk --no-cache add git=2.20.2-r0
RUN wget "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" -O BuildTools.jar
RUN java -Xmx1024M -jar BuildTools.jar --rev $SPIGOT_VER
WORKDIR /plg
#RUN mkdir WorldEdit
#RUN mkdir WorldGuard
COPY plugins/ ./
RUN wget "https://edge.forgecdn.net/files/2844/696/worldedit-bukkit-7.1.0-beta-1.jar"
RUN wget "https://media.forgecdn.net/files/2855/477/worldguard-bukkit-7.0.2.jar"


FROM openjdk:8-jre-alpine AS UTC

ARG SPIGOT_VER
ENV MEMORY=1024M

WORKDIR /minecraft
COPY --from=spigot /build/spigot-${SPIGOT_VER}.jar ./spigot.jar
COPY ./start.sh .
RUN mkdir ./plugins
COPY --from=spigot /plg/ ./plugins/
COPY ./server.properties .
COPY ./bukkit.yml .

EXPOSE 25565
ENTRYPOINT ["./start.sh"]


FROM UTC AS JA_JP

RUN apk add --update --no-cache tzdata=2019c-r0 && \
  cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone && \
  apk del tzdata
