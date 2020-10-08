# frozen_string_literal: true

# comment
class Player
  attr_accessor :move, :name, :score
  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
    @score = 0
    set_name
  end
end

# comment

VALUES = %w[rocks paper scissors lizard spock].freeze
# comment
class Rocks
  attr_reader :beats, :loses
  def initialize
    @beats = %w[paper spock]
    @loses = %w[scissors lizard]
  end
end
# comment
class Paper
  attr_reader :beats, :loses
  def initialize
    @beats = %w[rocks spock]
    @loses = %w[paper spock]
  end
end
# comment
class Scissors
  attr_reader :beats, :loses
  def initialize
    @beats = %w[paper lizard]
    @loses = %w[spock rocks]
  end
end
# comment
class Spock
  attr_reader :beats, :loses
  def initialize
    @beats = %w[rocks scissors]
    @loses = %w[paper lizard]
  end
end
# comment
class Lizard
  attr_reader :beats, :loses
  def initialize
    @beats = %w[spock paper]
    @loses = %w[rocks scissors]
  end
end

# class Move
#   VALUES = %w[rocks paper scissors lizard spock].freeze

#   LESSER_MOVES = { 'rocks' => %w[paper spock],
#                   'paper' => %w[lizard scissors],
#                   'scissors' => %w[spock rocks],
#                   'spock' => %w[paper lizard],
#                   'lizard' => %w[rocks scissors] }.freeze

#   GREATER_MOVES = { 'rocks' => %w[scissors lizard],
#                     'paper' => %w[rocks spock],
#                     'scissors' => %w[paper spock],
#                     'spock' => %w[rocks scissors],
#                     'lizard' => %w[spock paper] }.freeze

#   def initialize(value)
#     @value = value
#   end

#   def >(other)
#     GREATER_MOVES[@value].include?(other.to_s)
#   end

#   def <(other)
#     LESSER_MOVES[@value].include?(other.to_s)
#   end

#   def to_s
#     @value
#   end
# end

# comment
class Human < Player
  def set_name
    n = nil
    puts 'enter your name'
    loop do
      n = gets.chomp
      break unless n.empty?

      puts 'entery something silly'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'please choose rocks, paper, scissors, lizard or spock'
      choice = gets.chomp
      break if VALUES.include?(choice)

      puts 'sorry, enter a valid choice'
    end
    self.move = Kernel.const_get(choice.capitalize).new
  end
end
# comment
class Computer < Player
  def set_name
    self.name = %w[bob sue all_rocks].sample
  end

  def choose
    self.move = if name == 'all_rocks'
                  Rocks.new
                else
                  Kernel.const_get(VALUES.sample.capitalize).new
                end
  end
end

# comment
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rocks, Paper, and Scissors (and Lizards and Spock)'
  end

  def display_goodbye_message
    puts 'Thanks for playing Rocks, Paper, and Scissors (and Lizards and Spock). Goodbye.'
  end

  def display_moves
    puts "#{human.name} choose #{human.move.class.to_s.downcase}"
    puts "#{computer.name} choose #{computer.move.class.to_s.downcase}"
  end

  def display_winner
    if human.move.beats.include?(computer.move.class.to_s.downcase)
      puts "#{human.name} won"
    elsif computer.move.beats.include?(human.move.class.to_s.downcase)
      puts "#{computer.name} won"
    else
      puts "It's a tie"
    end
  end

  def increment_score
    if human.move.beats.include?(computer.move.class.to_s.downcase)
      human.score += 1
    elsif computer.move.beats.include?(human.move.class.to_s.downcase)
      computer.score += 1
    end
  end

  def display_score
    puts "#{human.name}'s score is #{human.score}."
    puts " #{computer.name}'s score is #{computer.score}."
  end

  def grand_winner?
    human.score > 9 || computer.score > 9
  end

  def display_grand_winner
    if human.score > 9
      puts "#{human.name} is the grand winner!"
    elsif computer.score > 9
      puts "#{computer.name} is the grand winner!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts 'would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)

      puts 'enter y or n'
    end
    answer == 'y'
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      increment_score
      if grand_winner?
        display_grand_winner
        break
      end
      display_score
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
