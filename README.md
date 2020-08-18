# TheLounge in Docker optimized for Unraid
TheLonge is the self-hosted web IRC client.
Modern features brought to IRC, Always connected, Responsive interface, Synchronized experience
The Lounge is the official and community-managed fork of Shout, by Mattias Erming.

**Multiple Users:** If you want to create a new user simply change the name in the 'Username' variable and also the 'Password' variable, this will have no impact to existing users (the 'Username' variable can't be empty and should always have a username in it that is available on the server).

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Path where the configuration, users, logs are located. | /thelounge |
| USERNAME | Username to create (this variable can't be empty!) | admin |
| USERPASSWORD | User Password | password |
| SAVELOG | Save log to disk or not (valid options are: 'yes' or 'no') | yes |
| UMASK | UMASK | 000 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| DATA_PERM | Data permissions for DATA_DIR | 770 |

## Run example
```
docker run --name TheLounge -d \
	-p 9000:9000 \
	--env 'USERNAME=admin' \
	--env 'USERPASSWORD=password' \
	--env 'SAVELOG=yes' \
	--env 'UMASK=000' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'DATA_PERM=770' \
	--volume /mnt/cache/appdata/thelounge:/thelounge \
	ich777/thelounge
```

### Webgui address: http://[IP]:[PORT:9000]

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/