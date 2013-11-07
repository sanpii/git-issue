# Git-issue

[![Build Status](https://ci.homecomputing.fr/git-issue/build/status)](https://ci.homecomputing.fr/git-issue)

*Git-issue* is a bug tracker based on git.

## Installation

Place the single file *src/git-issue* in your path.

For example:

    $ git clone https://github.com/sanpii/git-issue.git
    $ mkdir -p ~/.local/bin
    $ ln -s $(pwd)/git-issue/src/git-issue ~/.local/bin
    $ echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc

## Configuration

*Git-issue* reuse git configuration (user name, editor, …) but provide some
options.

### issue.branch

The branch name used for store the issues. *issues* by default.

### issue.remote

Remote name to publish issues. *origin* by default.

## Commands

### Initialize your issue database

This is the required first step:

    $ git issue init

### Create a new issue

    $ git issue new 'A new issue'
    Issue #1 created.

### Show an issue

    $ git issue show 1
    title: Issue title
    status: new
    assign:
    tags:
    milestone:
    type:

### List all issue

    $ git issue ls
    1: Issue title

### Edit an issue

    $ git issue edit 1

Git issue open the issue with your preferred editor. Edit, save and quit. The
issue is automatically committed.

### Delete an issue

    $ git issue rm 1

### Synchonize issues

Bidirectionnal synchronize:

    $ git issue sync
    Issues synced.

## A bug?

Clone this repository and use *git-issue* on it. After creating an issue, send
me a pull or a push request.
