require 'terminfo'
require 'terminal-table'

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

    def table(items)
      maxLength = (items.map { |e| e.length }).max

      columns = TermInfo.screen_size[1]
      itemsPerRow = (columns/maxLength).floor

      itemsInRows = items.reduce([[]]) do |memo, obj|
        memo.push([]) if memo.last.length >= itemsPerRow
        memo.last.push(obj)
        memo
      end

      table = Terminal::Table.new :rows => itemsInRows
      table.style = {:border_x => "", :border_i => "", :border_y => ""}
      table.to_s
    end
  end
end
