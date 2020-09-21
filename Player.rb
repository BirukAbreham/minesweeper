class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def prompt
    puts "Player #{self.name} please enter the position to reveal. (e.g. 2, 2)"
    input = gets.chomp.split(",")
    input = input.map { |ele| ele.to_i }
    input
  end

end
