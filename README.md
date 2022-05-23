# gvm
Golang version manager

## Intro

`gvm` allows you to quickly install and use different versions of Golang via the command line.

**Example:**
```sh
     Install Golang version 1.17.10"
     $ gvm install 1.17.10"
     echo "\n   Set and use Golang version 1.17.10 as default"
     $ gvm default 1.17.10"
     echo "\n   Use Golang version 1.18.2 (works only for current terminal session)"
     $ gvm use 1.18.2"
     echo "\n   Show installed Golang versions available for switching"
     $ gvm ls"
     echo "\n   Show all versions that can be installed from go.dev repo"
     $ gvm ls-remote"
     echo "\n   Remove installed version"
     $ gvm rm 1.18.2"
```

## Install script

For installation though the Bash run
```sh
curl -o- https://raw.githubusercontent.com/benms/gvm/main/install.sh | bash
```
For installation though the Zsh run
```sh
curl -o- https://raw.githubusercontent.com/benms/gvm/main/install.sh | zsh
```

## Uninstall
<details>
<summary>Run</summary>

```sh
gvm-application no-preserve-uninstall
```
</details>
