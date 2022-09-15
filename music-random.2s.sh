#!/bin/bash

# Metadata allows your plugin to show up in the app, and website.
#
#  <xbar.title>Random Apple Music song</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Vinicius Cenci</xbar.author>
#  <xbar.author.github>viniciuscenci</xbar.author.github>
#  <xbar.desc>Plays a random song from Apple Music.</xbar.desc>
#  <xbar.image>http://www.hosted-somewhere/pluginimage</xbar.image>
#  <xbar.dependencies>bash</xbar.dependencies>

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

function tellMusic()
{
  osascript -e "tell application \"Music\" to $1"
}

function playSong(){
  numberOfSongs=$(tellMusic "get count of tracks")
  randSong=$(jot -r 1 1 $numberOfSongs)
  tellMusic "play track $randSong"
}

isMusicOpen="$(osascript -e 'if application "Music" is running then
	return "true"
else
	return "false"
end if')"

if [ $isMusicOpen = "true" ]; then
  status=$(tellMusic "get player state")

  if [ $status == "playing" ] || [ $status == "paused" ]; then
    position=$(tellMusic "get player position" | cut -d '.' -f 1)

    songDuration=$(tellMusic "get time of current track")
    IFS=':' read -r -a array <<< "$songDuration"
    songSeconds=$(( ${array[0]} * 60 + $(expr ${array[1]}) ))
  fi
fi

if [ $status = "stopped" ] || [ $1 = 'play' ] ; then
  playSong
fi

echo "► | bash='$0' param1='play' terminal=false refresh=false"