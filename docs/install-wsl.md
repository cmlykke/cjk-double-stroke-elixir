# Installations
## Install Erlang and Elixir on WSL
This project accepts Elixir 1.19 and 1.20 (`elixir: "~> 1.19 or ~> 1.20"` in `mix.exs`). The newest release is Elixir 1.20.5.

Elixir 1.20 runs on Erlang/OTP 27, 28, or 29. The newest OTP 29 release is 29.1.2. Install that pair. Elixir 1.19.7 with OTP 28.5.0.8 still works, but it is the older line.

These steps are for Windows 10, version 2004 or newer (build 19041 or higher), with Ubuntu 24.04 running in WSL 2. The same apt and asdf commands work on Ubuntu 24.04 outside WSL. Start at "Update Ubuntu" in that case.

Paste only the lines inside a code block. Do not paste a line of backticks, and do not paste a backtick at the start or end of a command. In PowerShell a backtick continues the line, and the prompt changes to `>>`. Press Ctrl+C to cancel that. A check is finished when it prints a line ending in `OK`. PowerShell checks are run in Windows PowerShell. Bash blocks are run inside Ubuntu.

- In Windows PowerShell, Run as administrator, install Ubuntu 24.04. Windows 10 often asks for a restart. Restart, then continue. The first launch asks for a Linux username and password. The paths below use `cmlykke`. If `whoami` inside Ubuntu prints something else, use that name instead.

```powershell
wsl --install -d Ubuntu-24.04
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e true
if ($LASTEXITCODE -ne 0) { throw 'Ubuntu-24.04 did not start' }
'Ubuntu-24.04 OK'
```

- Enter Ubuntu:

```powershell
wsl.exe -d Ubuntu-24.04
```

- Update Ubuntu and install the packages asdf needs to compile Erlang. This is the Ubuntu 24.04 list from asdf-erlang. Java is left out; this project does not need it.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git unzip build-essential autoconf m4 libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'dpkg -s curl git unzip build-essential autoconf m4 libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev >/dev/null'
if ($LASTEXITCODE -ne 0) { throw 'apt install failed' }
'apt OK'
```

- Install asdf 0.20.2. Current asdf is a single program, not the old git clone of `v0.14.0`.

```bash
mkdir -p "$HOME/.local/bin"
curl -fL -o /tmp/asdf.tar.gz https://github.com/asdf-vm/asdf/releases/download/v0.20.2/asdf-v0.20.2-linux-amd64.tar.gz
tar -xzf /tmp/asdf.tar.gz -C "$HOME/.local/bin" asdf
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc '"$HOME/.local/bin/asdf" version | grep -q 0.20.2'
if ($LASTEXITCODE -ne 0) { throw 'asdf install failed' }
'asdf OK'
```

- Add asdf to `~/.bashrc`. `asdf global` was removed in asdf 0.16. Shims on `PATH` replace sourcing `asdf.sh`.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.bashrc
echo '. <(asdf completion bash)' >> ~/.bashrc
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'asdf version | grep -q 0.20.2'
if ($LASTEXITCODE -ne 0) { throw 'asdf is not on PATH' }
'asdf path OK'
```

- Add the Erlang plugin:

```bash
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'asdf plugin list | grep -qx erlang'
if ($LASTEXITCODE -ne 0) { throw 'Erlang plugin install failed' }
'erlang plugin OK'
```

- Add the Elixir plugin:

```bash
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'asdf plugin list | grep -qx elixir'
if ($LASTEXITCODE -ne 0) { throw 'Elixir plugin install failed' }
'elixir plugin OK'
```

- Compile Erlang/OTP 29.1.2. This builds from source and often takes 10–20 minutes.

```bash
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
asdf install erlang 29.1.2
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'test -x "$HOME/.asdf/installs/erlang/29.1.2/bin/erl"'
if ($LASTEXITCODE -ne 0) { throw 'Erlang install failed' }
'Erlang OK'
```

- Install the Elixir 1.20.5 build made for OTP 29. This downloads a precompiled build.

```bash
asdf install elixir 1.20.5-otp-29
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'test -x "$HOME/.asdf/installs/elixir/1.20.5-otp-29/bin/elixir"'
if ($LASTEXITCODE -ne 0) { throw 'Elixir install failed' }
'Elixir OK'
```

- Set both as the default for your Ubuntu user (`asdf set -u` writes `~/.tool-versions`):

```bash
asdf set -u erlang 29.1.2
asdf set -u elixir 1.20.5-otp-29
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'grep -qx "erlang 29.1.2" "$HOME/.tool-versions" && grep -qx "elixir 1.20.5-otp-29" "$HOME/.tool-versions" && elixir --version | grep -q "Elixir 1.20.5" && elixir --version | grep -q "OTP 29"'
if ($LASTEXITCODE -ne 0) { throw 'Elixir 1.20.5 on OTP 29 is not the active version' }
'versions OK'
```

- Install Hex (Elixir's package manager):

```bash
mix local.hex --force
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'ls "$HOME/.mix/archives"/hex-* >/dev/null'
if ($LASTEXITCODE -ne 0) { throw 'Hex install failed' }
'Hex OK'
```

- Install Rebar3 (the Erlang build tool):

```bash
mix local.rebar --force
```

Check in PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'find "$HOME/.mix" -name rebar3 -type f | grep -q .'
if ($LASTEXITCODE -ne 0) { throw 'Rebar3 install failed' }
'Rebar3 OK'
```

## Create an Erlang SDK in IntelliJ
Install the Erlang plugin first if File → Project Structure → SDKs → + has no "Erlang SDK" entry: Settings → Plugins, search for Erlang, install it, and restart IntelliJ.

In IntelliJ, open File → Project Structure.
On the left, select SDKs.
Click the + button.
Select Erlang SDK.
Choose "Add Erlang SDK from disk..."

Paste this path. It is the OTP install directory, the folder that contains `bin/erl`, not the asdf shims folder:

`\\wsl$\Ubuntu-24.04\home\cmlykke\.asdf\installs\erlang\29.1.2`

Then select Project on the left and set the Project SDK to that Erlang SDK.

## Clone the project to Ubuntu

- In Ubuntu:

```bash
cd ~
mkdir -p ~/codingprojects
cd ~/codingprojects
```

- Clone the repo:

```bash
git clone https://github.com/cmlykke/cjk-double-stroke-elixir.git
cd cjk-double-stroke-elixir
```

- Fetch dependencies and compile:

```bash
mix deps.get
mix compile
```

- In IntelliJ, File → Open, and paste:

`\\wsl$\Ubuntu-24.04\home\cmlykke\codingprojects\cjk-double-stroke-elixir`

## Setup VS Code
- Install VS Code on Windows. In the installer, enable "Add to PATH".

Check in PowerShell:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$codeVersion = code --version | Select-Object -First 1
if ($codeVersion -notmatch '\d+\.\d+\.\d+') { throw 'VS Code install failed' }
"VS Code OK: $codeVersion"
```

- In the Windows VS Code window, install the Remote Development extension pack.
  Identifier: `ms-vscode-remote.vscode-remote-extensionpack`
  Install the current marketplace release.

Check in PowerShell:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$extensions = code --list-extensions
if ($extensions -notcontains 'ms-vscode-remote.vscode-remote-extensionpack') { throw 'Remote Development install failed' }
'Remote Development OK'
```

- Close VS Code.
- From PowerShell, open Ubuntu, then from Ubuntu open the project:

```powershell
wsl.exe -d Ubuntu-24.04
```

```bash
cd ~/codingprojects/cjk-double-stroke-elixir
code .
```

- The status bar must say `WSL: Ubuntu-24.04`. ElixirLS has to be installed in that WSL window, not in a normal Windows window.
- Install ElixirLS: Elixir support and debugger.
  Identifier: `jakebecker.elixir-ls`
  Current release: 0.31.1

Check in PowerShell. This looks inside Ubuntu, because ElixirLS is installed in the WSL window:

```powershell
wsl.exe -d Ubuntu-24.04 -e bash -lc 'code --list-extensions | grep -qx jakebecker.elixir-ls'
if ($LASTEXITCODE -ne 0) { throw 'ElixirLS install failed' }
'ElixirLS OK'
```

- Reload VS Code when it asks. The first ElixirLS start compiles the project and can take a minute.

## Access files in WSL
- Open File Explorer.
- Paste this into the address bar:

`\\wsl$\Ubuntu-24.04\home\cmlykke`

- The project is in `codingprojects\cjk-double-stroke-elixir`.
