#!/bin/bash

USER=$(whoami)
HOME=/Users/$USER
TIMER=3h
AGENT=$HOME/.ssh/.ssh-agent

AUTH=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Config/AUTH
MNT=$HOME/.auth
KEYS=$MNT/.ssh

# # #

agentRunning() {
	if [ "$SSH_AUTH_SOCK" ]; then
		ssh-add -l > /dev/null 2>&1 || [ $? -eq 1 ]
	else
		false
	fi
}

agentLoad() {
	[ -r $AGENT ] && \
		eval "$(<$AGENT)" > /dev/null
}

agentKill() {
	killall -9 ssh-agent > /dev/null 2>&1
	[ -e $AGENT ] && \
		rm -f $AGENT > /dev/null 2>&1
	find /var/folders/b2/p9tc06q97yg120pbh52q5d2r0000gn/T/ -maxdepth 1 -type d -name "ssh-*" -exec rm -rf {} \;
}

agentStart() {
	agentKill
	(umask 077; ssh-agent > $AGENT)
	eval "$(<$AGENT)" > /dev/null
}

agentKeysLoaded() {
	ssh-add -l > /dev/null 2>&1
}

containerMount() {
	/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt -t -m ro $AUTH $MNT
}

containerUMount() {
	/Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt -d $AUTH
}

agentKeysLoad() {
	containerMount
	find $KEYS -maxdepth 1 -type f -not -name "*.pub" -exec ssh-add -t $TIMER {} +;
	containerUMount
	echo `ssh-add -l | wc -l` keys loaded
}

# # #

if [ -z "$*" ]; then
	if ! agentRunning; then
		agentStart
		agentKeysLoad
	elif ! agentKeysLoaded; then
		agentLoad
		agentKeysLoad
	fi
elif [ $1 = "load" ]; then
	agentLoad
elif [ $1 = "kill" ]; then
	agentKill
fi
