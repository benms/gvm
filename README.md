# gvm
Golang version manager

## Intro

`gvm` allows you to quickly install and use different versions of Golang via the command line.

**Example:**

 Install Golang version 1.17.10
```sh
$ gvm install 1.17.10
```
 Set and use Golang version 1.17.10 as default
 ```sh
 $ gvm default 1.17.10
 ```
 Use Golang version 1.18.2 (works only for current terminal session)
```sh
 $ gvm use 1.18.2
```
 Show installed Golang versions available for switching
 ```
 $ gvm ls
 ```
 Show all versions that can be installed from go.dev repo
 ```sh
 $ gvm ls-remote
 ```
 Remove installed version
```sh
 $ gvm rm 1.18.2
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
