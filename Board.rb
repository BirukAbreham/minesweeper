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
          file_grid[idx] << Tile.new(true)
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
    puts "_"*39
    puts
    @grid.each_with_index do |line, row|
      print "#{row}|".ljust(3, " ")
      line.each_with_index do |tile, idx|
        if tile.revealed?
          if tile.mine
            print "*".ljust(3, " ")+"|"
          else
            if tile.count > 0
              print " #{bomb_count}".ljust(3, " ")+"|"
            else
              print " _".ljust(3, " ")+"|"
            end
          end
        else
          print " /".ljust(3, " ")+"|"
        end
      end
      puts
      puts "_"*39
      puts
    end
    puts
  end

  def []=(position, tile)
    @grid[position[0]][position[1]] = tile
  end

  def [](position)
    @grid[position[0]][position[1]]
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

    valid_neighbors_pos.select { |pos| pos[0] >= 0 && pos[1] >= 0 }
  end

  def neighbors_bomb_count(tile_pos)
    neighbors_list = self.neighbors(tile_pos)
    total = 0
    neighbors_list.each do |ng_pos|
      total += 1 if self[ng_pos].mine
    end
    total
  end
  
end
