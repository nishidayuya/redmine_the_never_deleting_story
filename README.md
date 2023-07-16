Redmine ![](doc/the_never_deleting_story_logo.png)

# Redmine The NeverDeleting Story (a.k.a. 絶対削除させないマン): A Redmine plugin to omit removing feature

[![License X11](https://img.shields.io/badge/license-X11-blue.svg)](https://raw.githubusercontent.com/nishidayuya/redmine_the_never_deleting_story/master/LICENSE.txt)
[![Latest tag](https://img.shields.io/github/v/tag/nishidayuya/redmine_the_never_deleting_story)](https://github.com/nishidayuya/redmine_the_never_deleting_story/tags)

## Installation

Clone the plugin into your Redmine plugins directory.

```console
$ cd /path/to/redmine/plugins/
$ git clone https://github.com/nishidayuya/redmine_the_never_deleting_story.git
```

Run `redmine:plugins:migrate`

```console
$ cd /path/to/redmine/
$ bin/rails redmine:plugins:migrate
```

And restart your Redmine.

## Uninstallation

Run `redmine:plugins:migrate` to remove redmine_the_never_deleting_story's table.

```console
$ cd /path/to/redmine/
$ bin/rails redmine:plugins:migrate NAME=redmine_the_never_deleting_story VERSION=0
```

Remove plugin directory

```console
$ cd /path/to/redmine/plugins/
$ rm -rf redmine_the_never_deleting_story
```
