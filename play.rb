require 'ruby2d'

set title: 'Reaction_Game'
set width: 800, height: 600


class Reaction_Game
  attr_accessor :started, :finished, :score_screen

  def initialize()
    @started = false
    @finished = false
    @score_screen = false

    @shape_size = 40
    @live = 0
    @all_scores = []

    @text_message = 'Click to screen to start the game. To finish, press \'Q\''
  end

  def draw
    unless score_screen

      unless @started
        Text.new(@text_message , x: 10, y: 10, color: 'yellow')
      else
        Square.new(x: @shape_x, y: @shape_y, size: @shape_size, color: 'random')
      end

      if @finished
        Text.new("Try again. Press 'Q' to see scoreboard", x: 10, y:50, color: 'purple')
        Text.new("Press 'E' to clear scoreboard.", x: 10, y:90, color: 'purple')
      end

    else
      scoreboard
    end
  end

  def start
    @started = true
    @finished = false
    @live += 1

    start_the_game
    area_of_shape

    puts " game started - #{@start_time}"

  end


  def click_correct?(mouse_x, mouse_y)

    finish if square_contain?(mouse_x, mouse_y)

  end

  def finish()

    score = ((Time.now - @start_time) * 1000).round
    @text_message = "Your time was #{score} seconds. Try again. Press 'Q' to see scoreboard"
    @finished = true
    @started = false

    @all_scores.push(score)


  end


  def scoreboard
    column = 100
    row = 25
    high_score = @all_scores.min

    Text.new("Press 'R to return game. Press 'E' to delete scoreboard. To quit press 'Q'",
             x: 15, y: 15, color: 'yellow')
    Text.new('SCOREBOARD', x: 15, y: 55)

    @all_scores.each_with_index do |item, i|

      item == high_score ? color = 'red' : color = 'white'

      if column >= Window.height - 50
        column = 100
        row += 250
      end

      Text.new("#{i}. attemp: #{item} ms.", x: row, y: column, color: color)
      column += 25

    end

  end

  def delete_scoreboard
    @all_scores.clear
  end

  private

  def start_the_game
    @start_time = Time.now
    @shape_x = rand(Window.width - @shape_size)
    @shape_y = rand(Window.height - @shape_size)
  end

  def area_of_shape
    @shape_coords = [(@shape_x..@shape_x + @shape_size).to_a, (@shape_y..@shape_y + @shape_size).to_a] if @started
    @shape_coords
  end

  def square_contain?(mouse_x, mouse_y)
    @shape_coords[0].include?(mouse_x) && @shape_coords[1].include?(mouse_y)
  end

end


game = Reaction_Game.new
game.draw


on :mouse_down do |event|
  game.click_correct?(event.x, event.y) if event.button == :left && game.started

  clear
  game.draw
end


on :mouse_up do |event|
  game.start if !game.started && !game.finished && !game.score_screen
  clear

  game.draw
  game.finished = false if game.finished
end


on :key_up do |event|
  unless game.started

    case event.key.downcase

      when 'q' then game.score_screen ? exit : game.score_screen = true
      when 'r' then game.score_screen = false
      when 'e' then game.delete_scoreboard
    end

    clear
    game.draw
  end

end


show
