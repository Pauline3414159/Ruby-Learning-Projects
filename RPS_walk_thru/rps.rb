# frozen_string_literal: true

VALUES = %w[rock paper scissors lizard Spock].freeze

# contains methods for comparing moves
class Move
  LESSER_MOVES = { 'rock' => %w[paper Spock],
                   'paper' => %w[lizard scissors],
                   'scissors' => %w[Spock rock],
                   'Spock' => %w[paper lizard],
                   'lizard' => %w[rock scissors] }.freeze

  GREATER_MOVES = { 'rock' => %w[scissors lizard],
                    'paper' => %w[rock Spock],
                    'scissors' => %w[paper Spock],
                    'Spock' => %w[rock scissors],
                    'lizard' => %w[Spock paper] }.freeze

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
    puts 'Enter your name:'
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
      puts 'Choose your move! Please choose from (r)ock, (p)aper, (s)cissors, (l)izard or (S)pock.'
      choice = gets.chomp
      break if VALUES.include?(choice) || %w[r p s l S].include?(choice)

      puts "That's not a move, try again. "
    end
    self.move = choice_validator(choice)
  end

  private

  def choice_validator(choice)
    if choice.size == 1
      case choice
      when 'r' then return 'rock'
      when 'p' then return 'paper'
      when 's' then return 'scissors'
      when 'l' then return 'lizard'
      when 'S' then return 'Spock'
      end
    end
    choice
  end
end

# all three possible compueter players descend from this class
class Computer < Player
  def choose
    self.move = VALUES.sample
  end
end

# this computer player will always choose rock and will talk about rock
class RockFacts < Computer
  def initialize
    super
    @name = 'Rock Facts'
  end

  def choose
    self.move = 'rock'
  end

  def display_talk
    puts "Rock Facts says :
    #{['Sedimentary rocks form layers at the bottoms of oceans and lakes.',
		     'rocks are usually grouped into three main groups:'\
     		' igneous rocks, metamorphic rocks and sedimentary rock.',
		     'The scientific study of rock is called petrology.'].sample}"
  end
end

# this computer player will never choose lizards and bad talks lizards
class Herpetophobia < Computer
  def initialize
    super
    @name = 'Herpetophobiac'
  end

  def choose
    self.move = %w[rock paper scissors Spock].sample
  end

  def display_talk
    puts "#{name} says:
    #{['Herpetophobia is a common specific phobia,'\
		'which consists of fear or aversion to reptiles.', 'Lizards are reptiles.',
		     'Say no to lizards!'].sample} "
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
    puts "#{name} says:
    #{['hola', 'hello.', 'konnichiwa.', 'good day.', 'buenos dios.'].sample}"
  end
end

# contains display methods except for computer.display_talk
module Displayable
  def display_welcome_message
    puts 'Welcome to rock, paper, and scissors (and lizard and Spock!)'
  end

  def display_goodbye_message
    puts 'Thanks for playing rock, paper, and scissors'\
    '(and lizard and Spock). Goodbye.'
  end

  def display_moves
    puts "#{human.name} choose #{human.move}."
    puts "#{computer.name} choose #{computer.move}."
  end

  def display_human_win
    puts "#{human.name} won !"
    sleep 1.5
  end

  def display_computer_win
    puts "#{computer.name} won."
    sleep 1.5
  end

  def display_tie
    puts "It's a tie."
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
    puts "#{human.name}'s score is #{human.score}."
    puts "#{computer.name}'s score is #{computer.score}."
  end

  # rubocop:disable Metrics/MethodLength
  def display_rules
    clear_screen(0)
    puts <<~MSG
      -whoever gets to 10 points first is the grand winner!
      -rock beats scissors or lizard, but loses to paper or Spock
      -paper beats rock or Spock, but loses to lizard or scissors
      -scissors beasts paper or Spock, but loses to Spock or rock
      -Spock beats rock or scissors, but loses to paper or lizard
      -lizard beats Spock or paper, but loses to rock or scissors
      		Let's start!
    MSG
    sleep 6
  end

  # rubocop:enable Metrics/MethodLength
  def display_human_hx(int)
    "#{human.name} chose #{human.history[int]}, while"
  end

  def display_comp_hx(int)
    "#{computer.name} chose #{computer.history[int]}."
  end

  def display_history
    clear_screen(0)
    size = human.history.size
    (0...size).each do |idx|
      puts display_human_hx(idx) + ' ' + display_comp_hx(idx)
      sleep 1.5
    end
  end

  def display_grand_winner
    if human.score > 9
      puts "#{human.name} is the grand winner!"
    elsif computer.score > 9
      puts "#{computer.name} is the grand winner!"
    end
    sleep 3
  end
end

# contains  game engine
class RPSGame
  include Displayable

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = [Herpetophobia, Ordinary, RockFacts].sample.new
  end

  private

  # start of true/false methods --------------------------------------
  def grand_winner?
    human.score > 9 || computer.score > 9
  end

  def display_rules?
    answer = nil
    loop do
      puts 'Would you like to read the rules? (y/n)'
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
      puts 'Would you like to see the log of moves? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)

      puts 'Enter y or n:'
    end
    answer == 'y'
  end

  # end of true/false methods -----------------------------------

  def clear_screen(sec)
    sleep sec
    system('clear') || system('cls')
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
    clear_screen(2)
    display_rules if display_rules?
    clear_screen(1.5)
    human.set_name
    clear_screen(1.5)
    computer.display_talk
  end

  def post_game
    clear_screen(1)
    display_history if see_history?
    display_goodbye_message
  end

  def one_round
    clear_screen(1.5)
    human.choose
    computer.choose
    move_history
    display_moves
    clear_screen(2)
    display_winner
    increment_score
  end

  public


  def play
    pre_game
    loop do
      one_round
      clear_screen(2)
      break display_grand_winner if grand_winner?
      display_score
      clear_screen(3)
      break unless play_again?
    end
    post_game
  end

end

RPSGame.new.play
