require 'mysql2'

class MysqlConnection

  def initialize(options)
    begin
      @mysql = Mysql2::Client.new(options.merge({:database => 'information_schema', :connect_timeout => 2, :symbolize_keys => true}))
    rescue Mysql2::Error => e
      puts e
      exit 1
    end
  end

  def version
    version = query("SHOW VARIABLES LIKE 'version'")
    return version.first[:Value]
  end

  def percona
    xtra = query("show variables like 'version_comment'")
    return (xtra.first[:Value].include? "Percona") ? true : false
  end

  def query(query)
    begin
      @mysql.query(query)
    rescue Mysql2::Error => e
      puts e
      exit 1
    end
  end

  def disconnect
    @mysql.close
  end
end