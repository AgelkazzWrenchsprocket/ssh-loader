#!/bin/bash

USER=$(whoami)
HOME=/home/$USER
TIMER=3h
AGENT=$HOME/.ssh/.ssh-agent

AUTH=$HOME/Dropbox/AUTH
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
	find /tmp -maxdepth 1 -type d -name "ssh-*" -exec rm -rf {} \;
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
	veracrypt -m ro $AUTH $MNT
}

containerUMount() {
	veracrypt -d $AUTH
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
