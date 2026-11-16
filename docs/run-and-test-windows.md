# Run and test
## Run and test on Windows
These steps assume Erlang, Elixir, Hex, and Rebar are already installed, as in `docs/install-windows.md`. Run them in Windows PowerShell from the project folder, the folder that contains `mix.exs`.

If you cloned the project with the install guide, that folder is:

```powershell
cd $env:USERPROFILE\codingprojects\cjk-double-stroke-elixir
```

Paste only the lines inside a code block. Do not paste a line of backticks, and do not paste a backtick at the start or end of a command. In PowerShell a backtick continues the line, and the prompt changes to `>>`. Press Ctrl+C to cancel that. A check is finished when it prints a line ending in `OK`.

Check that PowerShell is in the project folder:

```powershell
if (-not (Test-Path .\mix.exs)) { throw 'This folder has no mix.exs. cd to the project folder first.' }
'Project folder OK'
```

The code to run is `CjkDoubleStroke.add/2` in `lib/cjk_double_stroke.ex`. It adds two numbers. For anything that is not a number, it returns `{:error, :invalid_input}`.

## Run the code
Compile the project:

```powershell
mix compile
```

Call `add/2` once and print the result. `mix run` compiles first if anything is out of date, runs the Elixir expression, then exits.

```powershell
mix run -e "IO.puts(CjkDoubleStroke.add(5, 3))"
```

Check:

```powershell
$result = mix run -e "IO.puts(CjkDoubleStroke.add(5, 3))"
if ($result -ne '8') { throw "Run failed: $result" }
'Run OK: 8'
```

To call the function yourself, start a session that stays open:

```powershell
iex -S mix
```

Wait until the prompt shows `iex>`. The next two lines are Elixir, typed at that prompt:

```elixir
CjkDoubleStroke.add(5, 3)
CjkDoubleStroke.add("hello", 5)
```

The first call returns `8`. The second returns `{:error, :invalid_input}`.

Leave the session by typing this at the `iex>` prompt:

```elixir
System.halt()
```

## Run the test suite
The tests live in `test/cjk_double_stroke_test.exs`. This runs every test in `test/`:

```powershell
mix test
```

Check:

```powershell
$output = mix test 2>&1 | Out-String
if ($output -notmatch '4 passed') { throw "Test suite failed:`n$output" }
'Test suite OK'
```

A finished run ends with `Result: 4 passed`.

## Run individual tests
Run every test in one file:

```powershell
mix test test/cjk_double_stroke_test.exs
```

Run one test by passing the file and a line number inside that test. The line can be the line that starts with `test`, or any line inside the test body. Forward slashes are the form Mix expects, and PowerShell accepts them.

The tests in `test/cjk_double_stroke_test.exs` are:

- Line 6, `adds two positive numbers`
- Line 11, `adds negative numbers`
- Line 16, `adds float numbers`
- Line 20, `returns error for invalid input`

This runs only `adds negative numbers`:

```powershell
mix test test/cjk_double_stroke_test.exs:11
```

Check:

```powershell
$output = mix test test/cjk_double_stroke_test.exs:11 2>&1 | Out-String
if ($output -notmatch '1 passed, 3 excluded') { throw "Single test failed:`n$output" }
'Single test OK'
```

Mix prints `1 passed, 3 excluded` because the other three tests in the file stay in the file and are left out of this run. Replace `11` with `6`, `16`, or `20` to run one of the other tests.
