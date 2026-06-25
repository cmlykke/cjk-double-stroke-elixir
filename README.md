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
  








