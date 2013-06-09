
  class Screen

    def initialize(window)
      @win = window
      @width = @win.maxx
      @hight = @win.maxy
    end

    def show_message(message)
      @win.setpos(0, 0)
      message['stats'].each do |s|
        pool_size = (s.fetch(:pages_misc).to_i + s.fetch(:pages_data).to_i * s.fetch(:page_size).to_i / 1024 / 1024)
        stats = "Buffer Pool: %s/%sMB  Data pages: %s  Misc Pages: %s  Free pages: %s\n" % [pool_size, s.fetch(:buffer_pool_mb), s.fetch(:pages_data), s.fetch(:pages_misc), s.fetch(:pages_free)]
        @win.addstr(stats)
      end
      names = (@width * 0.23).round()
      stats = (@width * 0.07).round()
      title = "%-#{names}.#{names}s" % "Database" + "%-#{names}.#{names}s" % "Table" + "%-#{names}.#{names}s" % "Index" + "%-#{stats}.#{stats}s" % "Pages" + "%-#{stats}.#{stats}s" % "Dirty" + "%-#{stats}.#{stats}s" % "Hashed" + "%-#{stats}.#{stats}s\n" % "%"
      template = "%{db}%{table_n}%{i_name}%{cnt}%{dirty}%{hashed}%{pct}\n"
      @win.addstr("-" * @win.maxx)
      @win.addstr(title)
      @win.addstr("-" * @win.maxx)
      row_max = @win.maxy - 2
      rows = 2

      message['bp'].each do |row|
        row[:db] = "%-#{names}.#{names}s" % row.fetch(:db)
        row[:table_n] = "%-#{names}.#{names}s" % row.fetch(:table_n)
        row[:i_name] = "%-#{names}.#{names}s" % row.fetch(:i_name)
        row[:cnt] = "%-#{stats}.#{stats}s" % row.fetch(:cnt)
        row[:dirty] = "%-#{stats}.f" % row.fetch(:dirty)
        row[:hashed] = "%-#{stats}.f" % row.fetch(:hashed)
        row[:pct] = "%-#{stats}.2f" % row.fetch(:pct)
        @win.addstr(template % row)
        rows += 1
        break if rows >= row_max
      end
      @win.refresh
    end

  end
