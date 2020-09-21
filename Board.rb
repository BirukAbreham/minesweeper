require "colorize"
require_relative "Tile"

class Board

  def initialize(grid)
    @grid = grid
  end

  def self.from_file(file_name="minesweeper_1.txt")
    file_grid = Array.new(9) { [] }
    raise "File does not exits" if !File.exist?(file_name)
    
    file = File.open(file_name)
    line_arr = file.readlines
    line_arr.map! { |line| line.chomp }

    line_arr.each_with_index do |line, idx|
      row_arr = line.split("")
      row_arr.each do |char|
        if char == "0"
          file_grid[idx] << Tile.new
        else
          file_grid[idx] << Tile.new(0, true)
        end
      end
    end
    
    Board.new(file_grid)
  end

  def render
    (0...@grid.length).each do |i|
      if i == 0
        print " ".ljust(3, " ")+"#{i}".ljust(4, " ")
      else
        print" #{i}".ljust(4, " ")
      end
    end
    puts
    puts "-"*39
    # puts
    @grid.each_with_index do |line, row|
      print "#{row}|".ljust(3, " ")
      line.each_with_index do |tile, idx|
        if tile.revealed?
          if tile.mine
            print " *".ljust(3, " ")+"|"
          else
            if tile.count > 0
              if tile.count >= 4
                print " #{tile.count}".ljust(3, " ").colorize(:color => :red)+"|"
              elsif tile.count <= 3 && tile.count >= 2
                print " #{tile.count}".ljust(3, " ").colorize(:color => :yellow)+"|"
              else
                print " #{tile.count}".ljust(3, " ").colorize(:color => :blue)+"|"
              end
            else
              print " _".ljust(3, " ")+"|"
            end
          end
        else
          print " /".ljust(3, " ").colorize(:color => :green, :background => :black)+"|"
        end
      end
      puts
      puts "-"*39
      # puts
    end
    puts
  end

  def []=(position, tile)
    @grid[position[0]][position[1]] = tile
  end

  def [](position)
    @grid[position[0]][position[1]]
  end

  def won?
    @grid.each do |row|
      row.each do |tile|
        return false if !tile.revealed? && !tile.mine
      end
    end
    true
  end

  def reveale_mines
    @grid.each do |row|
      row.each do |tile|
        tile.reveale if tile.mine
      end
    end
  end
  
  def neighbors(tile_pos)
    valid_neighbors_pos = []
    valid_neighbors_pos << [ tile_pos[0], tile_pos[1]-1 ]
    valid_neighbors_pos << [ tile_pos[0], tile_pos[1]+1 ]
    valid_neighbors_pos << [ tile_pos[0]-1, tile_pos[1] ]
    valid_neighbors_pos << [ tile_pos[0]+1, tile_pos[1] ]
    valid_neighbors_pos << [ tile_pos[0]-1, tile_pos[1]-1 ]
    valid_neighbors_pos << [ tile_pos[0]+1, tile_pos[1]+1 ]
    valid_neighbors_pos << [ tile_pos[0]+1, tile_pos[1]-1 ]
    valid_neighbors_pos << [ tile_pos[0]-1, tile_pos[1]+1 ]

    valid_neighbors_pos.select do |pos| 
      pos[0] >= 0 && pos[1] >= 0 && pos[0] < @grid.length && pos[1] < @grid.length
    end
  end

  def neighbors_bomb_count(tile_pos)
    neighbors_list = self.neighbors(tile_pos)
    total = 0
    neighbors_list.each do |ng_pos|
      is_mine = self[ng_pos]
      puts "position #{ng_pos}"
      if is_mine.mine
        total += 1
      end
    end
    total
  end
  
end
