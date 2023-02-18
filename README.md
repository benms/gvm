# gvm 
gvm is a version manager for the Go programming language, which allows you to easily install and manage multiple versions of Go on a single machine. With gvm, you can quickly switch between different versions of Go and manage dependencies for each version.


[![Test](https://github.com/benms/gvm/actions/workflows/main.yml/badge.svg)](https://github.com/benms/gvm/actions/workflows/main.yml)


## Intro

`gvm` allows you to quickly install and use different versions of Golang via the command line.

**Example:**

```sh
 Install Golang version 1.17.10
 $ gvm install 1.17.10
 Set and use Golang version 1.17.10 as default
 $ gvm default 1.17.10
 Use Golang version 1.18.2 (works only for current terminal session)
 $ gvm use 1.18.2
 Show installed Golang versions available for switching
 $ gvm ls
 Show all versions that can be installed from go.dev repo
 $ gvm ls-remote
 Remove installed version
 $ gvm rm 1.18.2
```

## Prerequisites
gvm requires the following software to be installed on your system:

- Git (version 1.7 or higher)
- Bash (version 4.0 or higher)

## Installation

To install gvm, run the following command:
```sh
curl -o- https://raw.githubusercontent.com/benms/gvm/main/install.sh | bash && . ~/.bashrc
```
For installation though the Zsh run
```sh
curl -o- https://raw.githubusercontent.com/benms/gvm/main/install.sh | zsh && . ~/.zshrc
```

## Usage

After installing gvm, you can use the gvm command to manage your Go installations. Some common commands include:

- ```sh gvm install <version>``` Installs the specified version of Go.
- ```sh gvm use <version>``` Sets the specified version of Go as the default version.
- ```sh gvm uninstall <version>``` Uninstalls the specified version of Go.
- ```sh gvm list``` Lists all installed versions of Go.
- ```sh gvm current``` Prints the currently active version of Go.

For a full list of available commands and options, see the gvm documentation.

## Contributing

If you would like to contribute to gvm, please fork the repository and submit a pull request. Before submitting a pull request, please ensure that your changes are well-tested and conform to the existing coding style.

## Contact

For questions or issues related to gvm, please open an issue on the GitHub repository.
