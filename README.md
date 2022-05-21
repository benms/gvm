# gvm
Golang version manager

## Intro

`gvm` allows you to quickly install and use different versions of node via the command line.

**Example:**
```sh
$ gvm use 1.17.10
Applied Go version 1.17.10
$ go version
go version go1.17.10 linux/amd64
$ gvm use 1.14
Applied Go version 1.14
$ go version
go version go1.14 linux/amd64
$ gvm install 1.18.1
Successfully installed Go version 1.18.1
$ gvm use 1.18.1
Applied Go version 1.18.1
$ go version
go version go1.18.1 linux/amd64
```

## Install script
```sh
curl -o- https://raw.githubusercontent.com/benms/gvm/main/install.sh | bash
```

```sh
curl -o- https://raw.githubusercontent.com/benms/gvm/main/install.sh | zsh
```
