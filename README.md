### I no longer maintain poolboy, I might pick it up again in the future but right now I don't have time.

# Poolboy

Poolboy is a command line tool that allows you to see information about the MySQL buffer pool as well as the buffered indexes.
Understanding how your data fits in memory helps discover why some queries are IO bound.

By default MySQL doesn't provide the stats necessary to get this information so Poolboy only works with Percona Server.

Poolboy in action:
![Poolboy](http://samlambert.com/images/poolboy.png)

This is my first Ruby project so if you have any comments/constructive criticism please create an issue or submit a pull request  :thumbsup:

## Installation

    $ gem install poolboy

Poolboy requires process privileges from MySQL

## Usage

The command line options are in the style of the Mysql Client:

    $ poolboy -h localhost -u root -p password
Help can be found with --help:

    $ poolboy --help
    Poolboy helps you inspect your buffer pool

    Usage: poolboy [options]
        -h HOST                          MySQL hostname
        -u USER                          MySQL username
        -p PASSWORD                      MySQL password
        -r REFRESH                       Refresh interval
        -f                               Force skipping of Percona Server check
            --help                       Show this message
            --version                    Show version

All options are optional (obviously) and can be defined in a configuration file for convenience.

## Configuration
If you wish to store connection options in a file you can place .poolboy.yaml in your home directory and it will be automatically loaded.

The configuration file needs to be in YAML format like so:

    $ cat ~/.poolboy.yaml
    :host: 127.0.0.1
    :username: root
    :password: password123
    :refresh: 5
    :force: false

## Quirks/Bugs
Some versions of Percona Server such as the one installed by brew don't have the 'version_comment' server variable which Poolboy uses to check version compatibility. If you want to skip this check just specify the option '-f' or ':force: true' in your config file.

Sometimes the Server reports slightly inaccurate page counts causing % to go over 100%

Older versions of Percona Server may not report all the values needed by Poolboy

## TODO

Add more stats

Add tests!

Move option parsing into a class


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

