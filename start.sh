#!/bin/ash
if [ ! -e /minecraft/eula.txt ]; then
  if [ "$EULA" != "true" -a "$EULA" != "TRUE" ]; then
    echo ""
    echo "You need to accept Minecraft EULA"
    echo "  https://account.mojang.com/documents/minecraft_eula"
    echo "if you accept Minecraft EULA, add "
    echo "  -e EULA=true"
    echo "option on startup."
    exit 1
  fi
  echo "eula=$EULA" >> eula.txt
  if [ $? != 0 ]; then
    echo "ERROR: unable to write eula to /minecraft."
    exit 1
  fi
fi

cp -f /json/*.json /minecraft/
ln -sf /json/whitelist.json /minecraft/whitelist.json
ln -sf /json/ops.json /minecraft/ops.json

#RCON PASS replace
cp /minecraft/server.properties /minecraft/server.properties.org
sed -e "s/REPLACEHERE/$RCON/g" /minecraft/server.properties.org > /minecraft/server.properties

java -Xmx${MEMORY} -jar /minecraft/spigot.jar nogui
