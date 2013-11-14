# Git-issue

[![Build Status](http://ci.homecomputing.fr/git-issue/build/status)](http://ci.homecomputing.fr/git-issue)

*Git-issue* is a bug tracker based on git.

## Why?

Git is a great tool to versioning source but also to [store
everything](http://git-annex.branchable.com/). Git is [designed like a file
system](http://marc.info/?l=linux-kernel&m=111314792424707), or if you prefer
buzz words, you can see it like a [nosql
database](http://opensoul.org/blog/archives/2011/09/01/git-the-nosql-database/).
A [nosql database over a
FS](http://www.pdl.cmu.edu/PDL-FTP/Storage/CMU-PDL-12-103.pdf)?.

Sorry, I digress. So why do not use it to store issues? In fact, use git
automatically makes your issues tracker versioned and distributed, like your
code.

Of course, it is not the first [distributed issue
tracker](http://www.cs.unb.ca/~bremner/blog/posts/git-issue-trackers/) but
*git-issue* exist because the other projects doesn't cover all these objectives:

* fully based on git ;
* minimal dependencies ;
* fully tested.

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

    $ git issue new 'A new issue' 'A long description'
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

By default, only unclosed issues are listed. You can use filter on *status*,
*title*, *tags*, *milestone* or *type*:

    $ git issue ls --status=close

Or inverted filter:

    $ git issue ls --status=~accepted

Or multiple values:

    $ git issue ls --status='new|accepted'

### Edit an issue

    $ git issue edit 1

Git issue open the issue with your preferred editor. Edit, save and quit. The
issue is automatically committed.

Or you can rapidly edit issue headers:

    $ git issue edit --status=done 1

## Close an issue

And you can more rapidly close an issue:

    $ git issue close 1

### Delete an issue

    $ git issue rm 1

### Synchonize issues

Bidirectionnal synchronize:

    $ git issue sync
    Issues synced.

## A bug?

Clone this repository and use *git-issue* on it. After creating an issue, send
me a pull or a push request.
