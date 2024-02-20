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
ln -sf /vol/njhs/logs/ /minecraft/logs

#RCON PASS and GAMEMODE replace
cp /minecraft/server.properties /minecraft/server.properties.org
sed -e "s/REPLACE_RCON/$RCON/g" /minecraft/server.properties.org > /minecraft/server.properties
sed -i "s/REPLACE_MODE/$GAMEMODE/g" /minecraft/server.properties
sed -i "s/REPLACE_SPAWN/$SPAWN/g" /minecraft/server.properties
sed -i "s/REPLACE_DIFFICULTY/$DIFFICULTY/g" /minecraft/server.properties

ln -s logs/latest.log /vol/logs/latest.log

#bukkit.yml world-container が1.16では正しく動かないのでここに入れる
#--world-containerのオプションは必ず最後に入れる
#/usr/bin/screen -Dm java -Xmx${MEMORY} -jar /minecraft/paper.jar nogui --world-container /vol
java -Xmx${MEMORY} -jar /minecraft/paper.jar nogui --world-container /vol
