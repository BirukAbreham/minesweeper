require_relative "Board"
require_relative "Player"

class Game

  def initialize(name, file='')
    @player = Player.new(name)
    if file == ''
      @board = Board.from_file
    else
      @board = Board.from_file(file)
    end
  end

  def play
    until @board.won?
      @board.render
      input_pos = @player.prompt

      if @board[input_pos].mine
        @board.reveale_mines
        system("clear")
        @board.render
        self.game_over
        break
      end

      @board[input_pos].reveale
      bomb_count = @board.neighbors_bomb_count(input_pos)
      @board[input_pos].count = bomb_count

      if bomb_count == 0
        ngs = @board.neighbors(input_pos)
        self.reveale_neighbors(ngs)
      end
    end
    if @board.won?
      @board.reveale_mines
      system("clear")
      @board.render
      self.won
    end
  end

  def game_over
    puts "--- Game over #{@player.name} stepped on a mine ---\n"
  end

  def won
    puts "#{@player.name} Won the game !!!"
  end

  def reveale_neighbors(ngs)
    ngs.each do |ng|
      if @board[ng].revealed?
        next
      end
      @board[ng].reveale
      b_count = @board.neighbors_bomb_count(ng)
      @board[ng].count = b_count
      if b_count == 0
        ngs_rec = @board.neighbors(ng)
        reveale_neighbors(ngs_rec)
      end
    end
    nil
  end

end

if __FILE__ == $PROGRAM_NAME
  filename = ARGV[0] || ""
  test_game = Game.new("Player", filename)
  puts
  puts "".ljust(10, " ")+"MINESWEEPER"+"".ljust(10, " ")
  print "\nSweep sweep the free positions without stepping on the mines (*)\n\n"
  ARGV.shift
  test_game.play
end
