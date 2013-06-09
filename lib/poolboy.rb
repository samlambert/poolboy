require 'poolboy/screen'
require 'poolboy/version'
require 'poolboy/mysql'
require 'poolboy/five_five'
require 'poolboy/five_one'
require 'optparse'
require 'yaml'
require 'curses'

module Poolboy

  def Poolboy.execute
    options = YAML.load(File.read(ENV['HOME']+'/.poolboy.yaml')) rescue {}

    o = OptionParser.new do |opts|
      opts.banner = "Poolboy helps you inspect your buffer pool\n\nUsage: poolboy [options]"
      opts.on("-h HOST", "MySQL hostname") do |h|
        options[:host] = h
      end
      opts.on("-u USER", "MySQL username") do |u|
        options[:username] = u
      end
      opts.on("-p PASSWORD", "MySQL password") do |p|
        options[:password] = p
      end
      opts.on("-r REFRESH", Integer, "Refresh interval") do |r|
        options[:refresh] = r >= 1 ? r : 1
      end
      options[:refresh] = options.has_key?(:refresh) ? options[:refresh] : 5
      opts.on("-f", "Force skipping of Percona Server check") do |r|
        options[:force] = true
      end
      options[:force] = options.has_key?(:force) ? options[:force] : false
      opts.on_tail("--help", "Show this message") do
        puts opts
        exit
      end
      opts.on_tail("--version", "Show version") do
        puts VERSION
        exit
      end
    end

    begin o.parse!
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts e
        puts o
        exit 128
    end

    connection = MysqlConnection.new(options)
    if not options[:force]
      connection.percona
      percona = connection.percona ? connection.percona : version_exit(connection)
    end
    version = connection.version
    case version[0,3] 
      when '5.1'
        mysql_map = FiveOne
      when '5.5'
        mysql_map = FiveFive
      else
        version_exit
    end

    window = Curses::Window.new(0,0,0,0)
    screen = Screen.new(window)

    begin
      while true
        results = mysql_map.get_stats(connection)
        screen.show_message(results)
        sleep(options[:refresh])
      end
    rescue SystemExit, Interrupt
      connection.disconnect
      exit
    end
  end

  def Poolboy.version_exit(connection)
    puts "Incompatible MySQL version! Poolboy is only compatible with Percona Server 5.1 and 5.5"
    connection.disconnect
    exit 1
  end

end