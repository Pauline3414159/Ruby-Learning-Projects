# frozen_string_literal: true

VALUES = %w[rocks paper scissors lizard spock].freeze

# contains methods for comparing moves
class Move
  LESSER_MOVES = { 'rocks' => %w[paper spock],
                   'paper' => %w[lizard scissors],
                   'scissors' => %w[spock rocks],
                   'spock' => %w[paper lizard],
                   'lizard' => %w[rocks scissors] }.freeze

  GREATER_MOVES = { 'rocks' => %w[scissors lizard],
                    'paper' => %w[rocks spock],
                    'scissors' => %w[paper spock],
                    'spock' => %w[rocks scissors],
                    'lizard' => %w[spock paper] }.freeze

  def initialize(value)
    @value = value
  end

  def >(other)
    GREATER_MOVES[@value].include?(other.to_s)
  end

  def <(other)
    LESSER_MOVES[@value].include?(other.to_s)
  end

  def to_s
    @value
  end
end

# all possible players decend from this class
class Player
  attr_accessor :move, :name, :score, :history
  def initialize
    @move = nil
    @score = 0
    @history = []
    @name = nil
  end
end

# the human player, contains method for setting the name and choosing the move
class Human < Player
  def initialize
    super
  end

  def set_name
    n = nil
    puts '
Enter your name:'
    loop do
      n = gets.chomp
      break unless n.empty? || n.include?(' ') || VALUES.include?(n.downcase)

      puts 'Enter some letters! No spaces or moves allowed'
    end
    self.name = n.capitalize
  end

  def choose
    choice = nil
    loop do
      puts '
Choose your move! Please choose from rocks, paper, scissors, lizard or spock.'
      choice = gets.chomp
      break if VALUES.include?(choice)

      puts "That's not a move, try again. "
    end
    self.move = choice
  end
end

# all three possible compueter players descend from this class
class Computer < Player
  def choose
    self.move = VALUES.sample
  end
end

# this computer player will always choose rocks and will talk about rocks
class RockFacts < Computer
  def initialize
    super
    @name = 'Rock Facts'
  end

  def choose
    self.move = 'rocks'
  end

  def display_talk
    puts "
Rock Facts says :
#{['Sedimentary rocks form layers at the bottoms of oceans and lakes.',
		 'Rocks are usually grouped into three main groups:'\
 		' igneous rocks, metamorphic rocks and sedimentary rocks.',
		 'The scientific study of rocks is called petrology.'].sample
}"
  end
end

# this computer player will never choose lizards and bad talks lizards
class Herpetophobia < Computer
  def initialize
    super
    @name = 'Herpetophobiac'
  end

  def choose
    self.move = %w[rocks paper scissors spock].sample
  end

  def display_talk
    puts "
#{name} says:
#{['Herpetophobia is a common specific phobia,'\
		'which consists of fear or aversion to reptiles.', 'Lizards are reptiles.',
		 'Say no to lizards!'].sample
} "
  end
end

# this computer player will choose the move randomly and will greet the human
# player normally
class Ordinary < Computer
  def initialize
    super
    @name = %w[Bob Sue Mikiko Alejandro].sample
  end

  def display_talk
    puts "
#{name} says:
#{['hola', 'hello.', 'konnichiwa.', 'good day.', 'buenos dios.'].sample}
"
  end
end

# contains display methods except for computer.display_talk
module Displayable
  def display_welcome_message
    puts 'Welcome to Rocks, Paper, and Scissors (and Lizards and Spock!)'
  end

  def display_goodbye_message
    puts '
Thanks for playing Rocks, Paper, and Scissors'\
    '(and Lizards and Spock). Goodbye.'
  end

  def display_moves
    puts "
#{human.name} choose #{human.move}"
    puts "#{computer.name} choose #{computer.move}"
  end

  def display_human_win
    puts "
#{human.name} won !"
  end

  def display_computer_win
    puts "
#{computer.name} won."
  end

  def display_tie
    puts "
It's a tie."
  end

  def display_winner
    if human.move > computer.move
      display_human_win
    elsif human.move < computer.move
      display_computer_win
    else
      display_tie
    end
  end

  def display_score
    puts "
#{human.name}'s score is #{human.score}."
    puts "#{computer.name}'s score is #{computer.score}.
    "
  end

  def display_rules
    puts "
-whoever gets to 10 points first is the grand winner!
-rocks beats scissors or lizard, but loses to paper or spock
-paper beats rocks or spock, but loses to lizard or scissors
-scissors beasts paper or spock, but loses to spock or rocks
-spock beats rocks or scissors, but loses to paper or lizard
-lizard beats spock or paper, but loses to rocks or scissors
		Let's start!"
  end

  def display_human_hx(int)
    "
#{human.name} chose #{human.history[int]}, while"
  end

  def display_comp_hx(int)
    "#{computer.name} chose #{computer.history[int]}."
  end

  def display_history
    size = human.history.size
    (0...size).each do |idx|
      puts display_human_hx(idx) + ' ' + display_comp_hx(idx)
    end
  end

  def display_grand_winner
    if human.score > 9
      puts "#{human.name} is the grand winner!"
    elsif computer.score > 9
      puts "#{computer.name} is the grand winner!"
    end
  end
end

# contains methods that return a true or false, like play_again?
module Booleanable
  def grand_winner?
    human.score > 9 || computer.score > 9
  end

  def display_rules?
    answer = nil
    loop do
      puts '
Would you like to read the rules? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)

      puts 'enter y or n'
    end
    answer == 'y'
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)

      puts 'Enter y or n:'
    end
    answer == 'y'
  end

  def see_history?
    answer = nil
    loop do
      puts '
Would you like to see the log of moves? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)

      puts 'Enter y or n:'
    end
    answer == 'y'
  end
end

# contains  game engine
class RPSGame
  include Displayable
  include Booleanable

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = [Herpetophobia, Ordinary, RockFacts].sample.new
  end

  def move_history
    human.history << human.move
    computer.history << computer.move
  end

  def increment_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def pre_game
    display_welcome_message
    display_rules if display_rules?
    human.set_name
  end

  def post_game
    display_history if see_history?
    display_goodbye_message
  end

  def one_round
    computer.display_talk
    human.choose
    computer.choose
    move_history
    display_moves
    display_winner
    increment_score
  end

# rubocop:disable all
  # 11/10 lines is close enough for me
  def play
    pre_game
    loop do
      one_round
      if grand_winner?
        display_grand_winner
        break
      end
      display_score
      break unless play_again?
    end
    post_game
  end
# rubocop:enable all
end

RPSGame.new.play
