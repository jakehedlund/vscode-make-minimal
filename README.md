# About

This repo was created to assist in the debugging of: https://github.com/Microsoft/vscode-makefile-tools/issues/741 

This is a minimal demonstration C Makefile project using a recursive build strategy. Each sub-directory has its own `Makefile` which handles a selection of build target labels. 

Notably, a library is first built (`libmyproject`), which is utilized by the tools contained in the tools directory (`mytool` and `myothertool`). 

Also of note are a handful of commands that are used as part of the build process: `pkg-config` to find dependencies, and `perl` (via `mkversion.sh`) to auto-increment the version number. _These programs must be available in the terminal in which make runs._ 

## Prerequisites 

1. Install Cygwin (`setup-x86_64.exe`).
2. From the Cygwin setup package manager, install `pkg-config`, `json-c` and `perl`. 
3. Install VSCode and the vscode-makefile-tools extension. 

## Building (Cygwin terminal)

1. Start a Cygwin bash terminal (`C:/Cygwin64/bin/mintty.exe -`). 
2. `cd` to this project's directory. 
3. From the top-level directory of this project, run `make`. 
4. The shell output will show a series of build steps. No errors should be shown. 
5. The lib and tools folders will contain the output binaries. 

## Building from VS Code

1. Add the following to your `settings.json` file: 
    ```
    "makefile.makefilePath": "Makefile",
    // The crux of the issue: 
    // "makefile.makePath": "C:/Cygwin64/bin/make.exe",
    "makefile.makePath": "make.exe",
    "terminal.integrated.profiles.windows": {
        "Cygwin64": {
            "path": "C:\\cygwin64\\bin\\bash.exe", 
            "args": [ "--login", "-i" ],
            "env": {"CHERE_INVOKING": "1" },
        }, 
    },
    "terminal.integrated.defaultProfile.windows": "Cygwin64",
    "C_Cpp.default.compilerPath": "C:/cygwin64/bin/gcc.exe",
    ```
2. The above lines set your default integrated terminal to Cygwin's bash prompt. **This is required to run `pkg-config` and `perl`**.
3. Restart VSCode! 
4. Run the command `Makefile: Configure`. 
5. Attempt to change the `build target` setting in the makefile extension. 
    * Expected result: all build targets in the Makefile should be shown (`all` `all-recursive` `check` `checkconfig` `clean` `debug` `release` `printconfig`).
    * Actual result: only `all` is shown. 
6. In `settings.json`: 
    1. Change the line: `"makefile.makePath": "make.exe"` to `"makefile.makePath": "C:/Cygwin64/bin/make.exe"`
7. Run the command `Makefile: Configure` again. 
    1. Expected result: all build targets are shown. 
    2. Actual result: all build targets are shown. 
8. Run the command `Makefile: build current target` (defaults to `all`)
    1. Expected result: `make` runs successfully and builds `.so` and `.exe` files. 
    2. Actual result (in vscode `bash` terminal): 
        ```
        *  Executing task: 'C:\Cygwin64\bin\make.exe' 'all' '-f' 'c:\Users\e438179\git\vscode-make-minimal\Makefile' 

        bash: C:\Cygwin64\bin\make.exe: command not found

        *  The terminal process "C:\cygwin64\bin\bash.exe '--login', '-i', '-c', ''C:\Cygwin64\bin\make.exe' 'all' '-f' 'c:\Users\e438179\git\vscode-make-minimal\Makefile''" terminated with exit code: 127. 
        *  Terminal will be reused by tasks, press any key to close it. 
        ```
        Note: this is attempting to locate `C:\Cygwin64\bin\make.exe` from the `bash` shell, and failing due to the path specifier being wrong from the Cygwin terminal perspective. 
9. In `settings.json`: 
    1. Change the line: `"makefile.makePath": "C:/Cygwin64/bin/make.exe"` to `"makefile.makePath": "/usr/bin/make"` (attempt to work around the above issue.)
10. Run the command `Makefile: build current target` again. 
    * Terminal output: 
    ```
    bash: \usr\bin\make.exe: command not found

    *  The terminal process "C:\cygwin64\bin\bash.exe '--login', '-i', '-c', ''\usr\bin\make.exe' 'debug' '-f' 'c:\Users\e438179\git\vscode-make-minimal\Makefile''" terminated with exit code: 127. 
    *  Terminal will be reused by tasks, press any key to close it. 
    ```
    Note the extension **changes the slashes** to back-slashes (from forward-slashes). 
11. Revert the `settings.json` change to `"makefile.makePath": "make.exe"` 
12. In `settings.json`, change the line: 
    `"terminal.integrated.defaultProfile.windows": "Cygwin64"` to `"terminal.integrated.defaultProfile.windows": "PowerShell"`
13. Run the command `Makefile: build current target` again. 
    * Terminal error output: 
    ```
    ./mkversion.sh: line 21: perl: command not found
    make: mkdir: No such file or directory
    make: *** [c:\Users\e438179\git\vscode-make-minimal\Makefile:35: check] Error 127

    *  The terminal process "C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -Command & 'C:\Cygwin64\bin\make.exe' 'all' '-f' 'c:\Users\e438179\git\vscode-make-minimal\Makefile'" terminated with exit code: 1. 
    *  Terminal will be reused by tasks, press any key to close it. 
    ```

The only "working" configuration I have found is this: 

1. Set `"makefile.makePath": "C:/Cygwin64/bin/make.exe"`
2. Run `Makefile: configure`. 
3. All build targets should be shown. 
4. Set `"makefile.makePath": "make.exe"` (the default).
5. Run `Makefile: build current target`. 
6. `make.exe` should succeed without errors. 
