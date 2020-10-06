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
# module Moves
	
# 	class Moves
# 		def initialize
# 			@beats
# 			@loses
# 		end
# 	end
	
# 	class Rocks < Moves
# 		@beats = ['paper','spock']
# 		@loses = ['scissors', 'lizard']
# 	end
		
# end
class Move
  VALUES = %w[rocks paper scissors lizard spock].freeze
  
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
      break if Move::VALUES.include?(choice)

      puts 'sorry, enter a valid choice'
    end
    self.move = Move.new(choice)
  end
end

# comment
class Computer < Player
  def set_name
    self.name = %w[bob sue all_rocks].sample
  end

  def choose
  	if self.name == 'all_rocks'
  		self.move = Move.new('rocks')
  	else
  		self.move = Move.new(Move::VALUES.sample)
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
    puts "#{human.name} choose #{human.move}"
    puts "#{computer.name} choose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won"
    elsif human.move < computer.move
      puts "#{computer.name} won"
    else
      puts "It's a tie"
    end
  end

  def increment_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
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
