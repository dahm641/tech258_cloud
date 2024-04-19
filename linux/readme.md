# Basic Commands

- `uname` = What is current OS
- `"command" --help` = Options for most commands
- `whoami` = Current user
- `sudo` Is super user do (permissions)
- `sudo su` Logs in as super-user
- `sudo apt update -y` Downloads latest packages
- `sudo apt upgrade -y` Installs latest packages that have been downloaded
- `sudo apt install "package" -y` Installs a specific downloaded package
- `snap install tree` Installs a module called tree that can visually show you your directories and files. `snap` downloads and installs packages in one step.

### File / directory commands
- `curl` = Download stuff online. Can download files.
- `file` = Checks file type
- `mv` = Move / rename
- `cp` = Copy
- `rm` = Remove file. Add `-r` for directory removal.
- `mkdir` = Make directory
- `touch` = Create file
- `cat` = Display contents of file
- `nano` = Basic text editor
- `cd` Changes directory. `cd` by itself goes home directory add `..` to move up a directory use `/` to go to root directory or specify any other path / directory
- `pwd` Is current directory


### Example 

#### Create a chicken joke

`touch chicken-joke.txt`

`nano chicken-joke`
#### Write out a basic chicken joke `ctrl x` and then ***enter*** to save



1. To print the top 2 lines of `chicken-joke.txt` to the screen:
```bash
head -2 chicken_joke.txt
```

2. To print the bottom 2 lines of `chicken-joke.txt` to the screen:
```bash
tail -2 chicken_joke.txt
```

3. To number the lines of `chicken-joke.txt` when outputting the file to the screen:
```bash
cat -n chicken_joke.txt
```

4. To print only the lines of `chicken-joke.txt` which contain the keyword "chicken":
```bash
grep "chicken" chicken_joke.txt
```



