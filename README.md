# cjk-double-stroke-elixir
Implementation of the liuma chinese input method in elixir

# Installations
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
  
## starting workflow

- login to wsl: 
wsl.exe -d Ubuntu
- go to root:
cd ~
- navigate to project and type: 
code .




## Fast iteration workflow (no database reload)

All static CJK data is now owned by the dedicated Mnesia node (`db@localhost`).  
The app/test node never loads the files — it only reads from the remote DB.

### Daily setup (once)

1. Start the DB node (this is where the slow loading happens):
   ```bash
   iex --sname db@localhost -S mix run --no-halt -e "CjkDoubleStroke.DBServer.start_link([])"
   ```
   You will see the "Loading static CJK data into Mnesia..." messages here.

2. In your normal terminal:
   ```bash
   iex --sname app@localhost -S mix
   CjkDoubleStroke.DBClient.connect()
   ```

### Rapid development loop

Use your VS Code task as usual:

1. `ctrl+alt+w` → run current test
2. Edit code
3. `ctrl+alt+w` again

All data access on the app node is now a fast remote read from the DB node. No files are ever re-read on the app node, even after restarts or `recompile()`.

You can keep the `app@localhost` IEx session (and the VS Code task) running for the whole day. Only the DB node needs to stay alive.

### tmux script version of startup:
# Start both nodes in a tmux session
./bin/start_nodes.sh

# Attach to the session
tmux attach -t cjk-dev

Inside tmux (reliable shortcuts):
• Ctrl+b 0          → DB node window
• Ctrl+b 1          → App node window (already connected)
• Ctrl+b ' then db  → switch by name to DB
• Ctrl+b ' then app → switch by name to App
• Ctrl+b w          → interactive window list
• Ctrl+b d          → detach (session keeps running)
• ./bin/stop_nodes.sh → completely clean everything up

Tip: From any terminal (including VS Code's), you can also run:
  tmux select-window -t cjk-dev:db
  tmux select-window -t cjk-dev:app

### VS Code shortcuts (add to your keybindings.json)
```json
{
    "key": "ctrl+alt+d",
    "command": "workbench.action.tasks.runTask",
    "args": "tmux: switch to db"
},
{
    "key": "ctrl+alt+a",
    "command": "workbench.action.tasks.runTask",
    "args": "tmux: switch to app"
}
```
These let you jump straight to the DB or App tmux window from the editor.


