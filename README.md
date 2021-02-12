# docker-minecraft-spigot-server

Docker image that provides a Spigot Minecraft Server.

Please read and accept [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula) before use.

## Usage

```
docker run -d -e EULA=true -p 25565:25565 --name spigot docker.pkg.github.com/outakyoutou/docker-minecraft-spigot-server/minecraft-spigot-server:1.16.5
```

With Japan Standard Time (JST)

```
docker run -d -e EULA=true -p 25565:25565 --name spigot docker.pkg.github.com/outakyoutou/docker-minecraft-spigot-server/minecraft-spigot-server-jp:1.16.5
```
