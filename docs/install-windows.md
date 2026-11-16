# Installations
## Install Erlang and Elixir on Windows
This project accepts Elixir 1.20 (`elixir: "1.20"` in `mix.exs`). The newest release is Elixir 1.20.5.

Elixir 1.20 runs on Erlang/OTP 27, 28, or 29. The newest OTP 29 release is 29.1.2. Install that pair. Elixir 1.19.7 with OTP 28.5.0.8 still works, but it is the older line.

These steps are for Windows 10, version 2004 or newer (build 19041 or higher), without WSL. `winget` comes with App Installer. If `winget` is missing, install "App Installer" from the Microsoft Store, then open a new PowerShell.

Paste only the lines inside a code block. Do not paste a line of backticks, and do not paste a backtick at the start or end of a command. In PowerShell a backtick continues the line, and the prompt changes to `>>`. Press Ctrl+C to cancel that. A check is finished when it prints a line ending in `OK`.

- Install Git, if `git --version` does not already work. Or download the current installer from https://git-scm.com/download/win

```powershell
winget install --id Git.Git -e --source winget
```

Check:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$gitVersion = git --version
if ($gitVersion -notmatch 'git version') { throw 'Git install failed' }
"Git OK: $gitVersion"
```

- Download and run the 64-bit Erlang OTP 29.1.2 installer. Windows 10 will ask for administrator approval.
  https://github.com/erlang/otp/releases/download/OTP-29.1.2/otp_win64_29.1.2.exe
  Leave the install folder as `C:\Program Files\Erlang OTP`.
  The installer adds `C:\Program Files\Erlang OTP\bin` to PATH.

Check:

```powershell
$otp = erl -noshell -eval "erlang:display(erlang:system_info(otp_release)), halt()." 2>&1 | Out-String
if ($otp -notmatch '29') { throw "Erlang check failed: $otp" }
"Erlang OK: OTP $($otp.Trim())"
```

- Download and run the Elixir 1.20.5 installer built for OTP 29. Install Erlang first. This installer looks for it.
  https://github.com/elixir-lang/elixir/releases/download/v1.20.5/elixir-otp-29.exe
  Leave the install folder as `C:\Program Files\Elixir`.
  The installer adds `C:\Program Files\Elixir\bin` to PATH.

Check:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$elixirVersion = elixir --version 2>&1 | Out-String
if ($elixirVersion -notmatch 'Elixir 1\.20\.5' -or $elixirVersion -notmatch 'OTP 29') { throw "Elixir check failed: $elixirVersion" }
"Elixir OK:`n$elixirVersion"
```

- Close every open IntelliJ and VS Code window. Programs that were already open keep the old PATH.
- Install Hex (Elixir's package manager):

```powershell
mix local.hex --force
```

Check:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$archives = mix archive 2>&1 | Out-String
if ($archives -notmatch 'hex') { throw 'Hex install failed' }
"Hex OK"
```

- Install Rebar3 (the Erlang build tool):

```powershell
mix local.rebar --force
```

Check:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$rebar = Get-ChildItem "$env:USERPROFILE\.mix" -Recurse -Filter 'rebar3*' -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $rebar) { throw 'Rebar3 install failed' }
"Rebar3 OK: $($rebar.FullName)"
```

- Check Mix:

```powershell
mix --version
```

If `elixir` is not found, add these two folders to your user PATH, then open a new PowerShell:

`C:\Program Files\Erlang OTP\bin`

`C:\Program Files\Elixir\bin`

## Create an Erlang SDK in IntelliJ
Install the Erlang plugin first if File → Project Structure → SDKs → + has no "Erlang SDK" entry: Settings → Plugins, search for Erlang, install it, and restart IntelliJ.

In IntelliJ, open File → Project Structure.
On the left, select SDKs.
Click the + button.
Select Erlang SDK.
Choose "Add Erlang SDK from disk..."

Paste this path. It is the folder that contains `bin\erl.exe`:

`C:\Program Files\Erlang OTP`

Then select Project on the left and set the Project SDK to that Erlang SDK.

Restart IntelliJ if it was open while Erlang was installing.

## Clone the project

- In PowerShell:

```powershell
cd $env:USERPROFILE
mkdir codingprojects
cd codingprojects
```

- Clone the repo:

```powershell
git clone https://github.com/cmlykke/cjk-double-stroke-elixir.git
cd cjk-double-stroke-elixir
```

- Fetch dependencies and compile:

```powershell
mix deps.get
mix compile
```

- In IntelliJ, File → Open, and choose that `cjk-double-stroke-elixir` folder.
  If the project is already on disk, open that folder instead of cloning again.

## Setup VS Code
- Install the current VS Code if needed: https://code.visualstudio.com/
  In the installer, enable "Add to PATH".

Check:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$codeVersion = code --version | Select-Object -First 1
if ($codeVersion -notmatch '\d+\.\d+\.\d+') { throw 'VS Code install failed' }
"VS Code OK: $codeVersion"
```

- Close VS Code if it was open during the Erlang or Elixir install, then reopen it so it sees the new PATH.
- Open the project. From PowerShell, inside the project folder:

```powershell
code .
```

- Install ElixirLS: Elixir support and debugger.
  Identifier: `jakebecker.elixir-ls`
  Current release: 0.31.1

Check:

```powershell
$env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
$extensions = code --list-extensions
if ($extensions -notcontains 'jakebecker.elixir-ls') { throw 'ElixirLS install failed' }
"ElixirLS OK"
```

- Reload VS Code when it asks. The first ElixirLS start compiles the project and can take a minute.

Open the normal Windows folder. The status bar should not say "WSL".

## Where the files are
- Erlang: `C:\Program Files\Erlang OTP`
- Elixir: `C:\Program Files\Elixir`
- Hex and Rebar, after `mix local.hex` and `mix local.rebar`: `%USERPROFILE%\.mix`
