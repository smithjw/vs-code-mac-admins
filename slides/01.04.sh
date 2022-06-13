#!/bin/bash

APP_NAME="$4"
app_path="$5"
app_trigger="$6"
add_icon_to_dock=/usr/local/outset/on-demand/"$APP_NAME".py

echo "Creating Outset On-Demand Script for $APP_NAME"
/bin/cat << EOF > "$add_icon_to_dock"
#!/usr/local/bin/managed_python3
import os
from docklib import Dock

dock = Dock()
app = "$app_path"
item = dock.makeDockAppEntry(app)
if os.path.exists(app):
    dock.items["persistent-apps"].append(item)
    dock.save()
EOF

chown root:wheel "$add_icon_to_dock"
chmod 755 "$add_icon_to_dock"

if [ -n "$app_trigger" ]; then
	echo "Installing $APP_NAME"
	/usr/local/bin/jamf policy -event "$app_trigger"
fi

echo "Updating the Dock"
/usr/bin/touch /private/tmp/.com.github.outset.ondemand.launchd

exit 0
