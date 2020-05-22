# Vintage Story Server in Docker optimized for Unraid
This is a Basic Vintage Story Server it will download and install Vintage Story Server and run it.

UPDATE NOTICE: The container will check on every start/restart if there is a newer version available.

>**CONSOLE:** To connect to the console open up the terminal on the host machine and type in: 'docker exec -u vintagestory -ti Name of your Container screen -xS VintageStory' (without quotes) to exit the screen session press CTRL+A and then CTRL+D or simply close the terminal window in the first place.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for gamefile | /vintagestory |
| GAME_PARAMS | Extra startup Parameters if needed (leave empty if not needed) | |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | User file permission mask for newly created files | 000 |
| DATA_PERM | Data permissions for main storage folder | 770 |

## Run example
```
docker run --name VintageStory -d \
	-p 42420:42420 \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=000' \
	--env 'DATA_PERM=770' \
	--volume /mnt/cache/appdata/vintagestory:/vintagestory \
	ich777/vintagestory
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/