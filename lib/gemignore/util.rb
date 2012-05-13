module GemIgnore
  module Util

    def msg(msg, level=0)
      puts (prefix(level) + msg)
    end


    def success(msg, level=0)
      puts (prefix(level) + msg).foreground(:green)
    end


    def notice(msg, level=0)
      puts (prefix(level) + msg).foreground(:yellow)
    end


    def error(msg, level=0)
      puts (prefix(level) + msg).foreground(:red)
    end


    def prefix(level)
      return "" if level <= 0
      ("-" * level) + "> "
    end
  end
end
