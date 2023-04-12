FROM openjdk:17-jdk-alpine AS spigot
ENV JAVA_HOME=/opt/openjdk-17
ENV PATH=/opt/openjdk-17/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV JAVA_VERSION=17-ea+14

RUN apk --update add --no-cache screen

WORKDIR /plg
COPY plugins/ ./
COPY logs/ ./

FROM openjdk:17-jdk-alpine AS utc

ENV MEMORY=1024M

WORKDIR /minecraft
RUN mkdir -p ./plugins/PluginMetrics
RUN mkdir -p ./plugins/BungeeServerSigns
COPY ./paper.jar .
COPY ./start.sh .
COPY ./paper.jar .
COPY ./server.properties .
COPY ./bukkit.yml .
COPY ./spigot.yml .
COPY --from=spigot /plg/ ./plugins/ 
COPY ./config.yml ./plugins/PluginMetrics/

EXPOSE 25565
ENTRYPOINT ["./start.sh"]

FROM utc AS ja_jp

RUN apk add --update --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone && \
  apk del tzdata
