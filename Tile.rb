class Tile

  def initialize(bomb=false)
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
