# ssh-loader
Simple script purposed to automate private ssh keys load into the ssh-agent from a secured container.
<br/>Inspired by:
- Michael R. Schoonmaker - https://www.schoonology.com/technology/ssh-agent-windows/
- Carlo Contavalli - http://rabexc.org/posts/pitfalls-of-ssh-agents
- Ando "David" Roots - https://sqroot.eu/2016/securing-ssh-keys

## Features
- check for a running ssh-agent;
- start an ssh-agent / load it from an env file;
- check for loaded keys;
- mount a VeraCrypt container and load keys;
- unmount the VeraCrypt container;

## Code
### Functions
- agentRunning() - check if an ssh-agent is running;
- agentLoad() - load agent from a variable;
- agentStart() - start a new agent and save its details into a variable;
- agentKeysLoaded() - check if any keys have been loaded;
- containerMount() - mount a VeraCrypt container;
- agentKeysLoad() - load all keys;
- containerUMount() - unmount the VeraCrypt container;
- agentKill() - kill the ssh-agent and delete any leftovers;

### Variables
- **USER** - by default, currently logged user;
- **HOME** - user's home directory;
- **TIMER** - key(s) expiration time;
- **AGENT** - variable storing agent's data;
- **AUTH** - path to the VeraCrypt container
- **MNT** - temporary mounting point for the VeraCrypt container's content;
- **KEYS** - location of a folder with ssh keys (in the **MNT** directory);

## Invoking
Bash scripts, by default, start in their own subshell.
<br/>To start a script in the current shell you need to invoke it with a dot.
```bash
. ssh-linux.sh
```
```bash
. ssh-osx.sh
```

### Parameters
These parameters are optional:
- *load* - runs the *agentLoad()* function. It's useful when opening a new terminal window / tab as it loads the currently running agent there. You can add this line to your *.bash_profile* to make it happen automatically.

```bash
. ssh-linux.sh load
```
```bash
. ssh-osx.sh load
```
- *kill* - runs the *agentKill()* function.

## .bashrc
To make it easier to use consider adding the following lines at the end of your *.bashrc* file (or an alternative shell of your choice).
```bash
PATH=path/to/the/script
alias sshadd=". $PATH/ssh-loader.sh"
alias sshload=". $PATH/ssh-loader.sh load"
alias sshkill=". $PATH//ssh-loader.sh kill"
sshload
```