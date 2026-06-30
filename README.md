# cjk-double-stroke-elixir
Implementation of the liuma chinese input method in elixir


## starting workflow

- login to wsl: 
wsl.exe -d Ubuntu
- go to root:
cd ~
- navigate to project and type: 
code .


## tmux script to start daily workflow once code is opened:
### Start both nodes in a tmux session
- ./bin/start_nodes.sh
- ./bin/stop_nodes.sh

### run tests of the distributed setup:
- ./bin/test_distributed_db.sh

### see elixit nodes:
```epmd -names``` or ```epmd -list```
- inside iex: nodes: 
Node.self(), Node.list(), Node.list(:all), Node.info(Node.self()), :erlang.is_alive()
- inside iex: processes:
Process.list(), Process.registered(), Process.info(self())
Process.info(Process.whereis(:some_name)), :erlang.system_info(:process_count), 
:observer.start()


## Attach to the session
```tmux attach -t cjk-dev```

Inside tmux:
• Ctrl+b then 0 → DB node window
• Ctrl+b then 1 → App node window (already connected)
• Ctrl+b then d → detach (session keeps running)
• ./bin/stop_nodes.sh → completely clean everything up

### create a third window for git
- first, detach from tmux by typing: ctrl+b+d
- type this in 
```tmux new-window -t cjk-dev -n git```
- attach to tmux again:
```tmux attach -t cjk-dev```
- go to the new terminal with ctrl+b+2

### interact with the nodes:
- type Ctrl+b+1 to go to the app node: app@127.0.0.1
- type this:
```
alias CjkDoubleStroke.Idsidentifier.Idsnested
Idsnested.ids_init_search("是")
```
here is the output:
```["日", "一", "龰"]```
- type Ctrl+b+0 to go to the db node: db@127.0.0.1
see this in the output
```
Loading static CJK data into Mnesia on DB node...
  [1/7] cedict... done (125013 entries)
  [2/7] radicals... done (329 radicals)
  [3/7] conway strokes... done (28165 entries)
  [4/7] ids... done (88937 entries)
  [5/7] hongbing... done (14975 entries)
  [6/7] global wordfreq... done (1048576 entries)
  [7/7] tzai... done (13060 entries)
  words.json... done (146162 words)
  Building lookup maps... done
Static data loaded into Mnesia on DB node.
iex(db@127.0.0.1)2> 
```
This means that the db node generated the database 
once the app node executed the 
Idsnested.ids_init_search("是") function call.

#########################################################
# commands to help with AI:
- to copy file tree, type in terminal:
```tree -a --prune -P "*.ex|*.exs|*.heex|*.eex|mix.exs|*.json|*.yml|*.yaml|*.md" \
  -I 'node_modules|.git|dist|build|coverage|_build|deps|*.beam' > project-tree.txt```
- then in the project root, you will now have a file project-tree.txt
  with the updated project structure. 

##########################################################

# first time setup - Installations

## Install erlang and elixir on wsl
This project requires Elixir 1.19 and Erlang  
Here is a suggestion of how to install it:
- Use linus, or if on windows: install wsl:
`wsl --install -d Ubuntu`
- run it like this: (this will enter ubuntu)
`wsl.exe -d Ubuntu`
- Update system and install required dependencies
`sudo apt update && sudo apt upgrade -y`
`sudo apt install -y curl git unzip build-essential autoconf m4 libncurses5-dev libwxgtk3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev xsltproc fop libxml2-utils`
- Install asdf version manager
`git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0`
- Install asdf
`git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0`
- Add asdf to your .bashrc
`echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc`
`echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc`
- Reload your shell
`source ~/.bashrc`
- check version number. You should see something like: v0.14.0-ccdd47d
`asdf --version`
- Add Erlang and Elixir plugins
`asdf plugin add erlang`
`asdf plugin add elixir`
- Install the latest stable Erlang (could take 10 - 20 minutes)
`asdf install erlang latest`
- Set Erlang as global (use the version you sw, eg. "👍 Installed erlang 29.0"):
`asdf global erlang 29.0`
- check available elixir versions: (you get something like: 1.20.0-rc.4-otp-29)
`asdf list all elixir | grep otp-29`
- If there are only release version, eg. 1.20.0-rc.4-otp-29, install a stable version of erlang first:
`asdf install erlang 27.3.3`
- now set the new version of erlang as global, and then look again for available elixir versions:
`asdf global erlang 27.3.3`
- install one of the latest available non-releasecandidate elixir versions:
`asdf install elixir 1.19.5-otp-27`
- set elixir as global default:
`asdf global elixir 1.19.5-otp-27`
- Reload your shell
`source ~/.bashrc`
- Verify everything is working
`erl -version`
`elixir --version
- Install Hex, Elixir version manager
`mix local.hex --force`
- Install Rebar3 (Erlang build tool)
`mix local.rebar --force`
- Check everything is good
`mix --version`

## Create an erlang SDK in intellij
In IntelliJ, open File → Project Structure
On the left, select SDKs
Click the + button (top left of the SDKs window)
Select Erlang SDK
Choose "Add Erlang SDK from disk..."

Now, in the folder selection dialog, paste this exact path:

\\wsl$\Ubuntu\home\cmlykke\.asdf\shims

## Clone the project to wsl ubuntu

- Create a new folder in the utuntu root:
`cd ~`
`mkdir -p ~/codingprojects`
`cd ~/codingprojects`
- Clone the repo:
`git clone https://github.com/cmlykke/cjk-double-stroke-elixir.git`
`cd cjk-double-stroke-elixir`

- Now open in intellij: In IntelliJ → File → Open, paste this path:
`\\wsl$\Ubuntu\home\cmlykke\codingprojects\cjk-double-stroke-elixir`



##  setup in vscode
- inside wsl, go to the project: (in powershell:)
    - `wsl.exe -d Ubuntu`
    - `cd ~/codingprojects/cjk-double-stroke-elixir`
- open vscode:
    - `code .`
- install Remote Development extension pack:
- go to the windows (not the wsl) vs code, and install this extension:
  Remote Development (Identifier ms-vscode-remote.vscode-remote-extensionpack Version
  0.26.0)
- close and reopen VS code
- go back to WSL:
  cd ~/codingprojects/cjk-double-stroke-elixir
  code .
  (imprtant! it should say "WSL: Ubuntu")
- install these plugin in VS code:
  ElixirLS: Elixir support and debugger
  (Identifier jakebecker.elixir-ls Version 0.30.0)

## Access files in wsl

- open File Explorer
- in addressbar:
  \\wsl$\Ubuntu
- cd ~
- navigate to file
  