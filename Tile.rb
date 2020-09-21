class Tile

  attr_reader :mine, :count

  def initialize(count=0, bomb=false)
    @count=count
    @mine=bomb
    @bombed=false
    @flagged=false
    @revealed=false
  end

  def reveale
    @revealed = true
  end

  def revealed?
    @revealed
  end

  def flagged?
    @flagged
  end

  def bombed?
    @bombed
  end

end
