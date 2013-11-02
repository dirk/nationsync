# NationSync

NationSync is a Ruby client for synchronizing a [NationBuilder](http://nationbuilder.com/) theme with a local directory. It allows you to edit theme files locally and have your changes automatically sent to the server.

The core of NationSync is the theme tool API used internally by the [NationBuilder Theme Sync for Mac](http://nationbuilder.com/theme_sync). As such this may break with the whims of the developers at NationBuilder. NationSync also uses the [Listen](https://github.com/guard/listen) gem from Guard to monitor the file system for changes, so it's *hopefully* cross-platform.

## Installation

It's easy:

    gem install nationsync

## Usage

Make sure you are in the directory that you'll be syncing your theme into when running these commands!

### 1. Account setup

Next run `nationsync init`; this will prompt you for your domain, email, and password. It then authenticates with NationBuilder and saves its access token and session in `.nbconfig1`.

### 2. Theme setup

Run `nationsync pick_theme`; it will fetch a list of themes and allow you to pick one. Then run `nationsync fetch` to fetch theme files into the current directory. To pull new files or updated files run `nationsync fetch` again. (Running `nationsync clean` will also remove all NationSync theme files from the current directory, however it will leave the config file so you can then fetch again.)

### 3. Watching ###

`nationsync watch` will start watching the directory for changes and will upload any changed files to NationBuilder.

## Contributing

Fork and pull-request!

## License ##

Copyright 2013 Dirk Gadsden and released under a modified New BSD License. See LICENSE.txt for details.
