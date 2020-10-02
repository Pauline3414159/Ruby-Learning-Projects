class Player
	attr_accessor :move, :name
	def initialize(player_type = :human)
		@player_type = player_type
		@move = nil
		set_name
	end
	
	def set_name
		
		if human?
			n = nil
			puts "enter your name"
			loop do
				n = gets.chomp
				break unless n.empty?
				puts "entery something silly"
			end
			self.name = n
		else
			self.name = ['bob','sue'].sample
		end
	end
	
	def choose
		if human? == true
			choice = nil
			loop do
				puts "please choose rocks, paper, or scissors"
				choice = gets.chomp
				break if ['rocks', 'paper', 'scissors'].include?(choice)
				puts "sorry, enter a valid choice"
			end
			self.move = choice
		
		else
			self.move = ['rocks', 'paper', 'scissors'].sample
		end
	end
	
	def human?
		@player_type == :human
	end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end
  
  def display_welcome_message
  	puts "Welcome to Rocks, Paper, and Scissors"
  end
  
  def display_goodbye_message
  	puts "Thanks for playing Rocks, Paper, and Scissors. Goodbye."
  end
  
  def display_winner
  	puts "#{human.name} choose #{human.move}"
  	puts "#{computer.name} choose #{computer.move}"
  	case human.move
  	when 'rocks'
  		puts "It's a tie" if computer.move == 'rocks'
  		puts "#{human.name} won!" if computer.move == 'scissors'
  		puts "#{computer.name} won" if computer.move == 'paper'
  	when 'paper'
  		puts "It's a tie" if computer.move == 'paper'
  		puts "#{human.name}won!" if computer.move == 'rocks'
  		puts "#{computer.name} won" if computer.move == 'scissors'
  	when 'scissors'
  		puts "It's a tie" if computer.move == 'scissors'
  		puts "#{human.name} won!" if computer.move == 'paper'
  		puts "#{computer.name} won" if computer.move == 'rocks'
  	end
  end
  
  def play_again?
  	answer = nil
  	loop do
  		puts "would you like to play again? (y/n)"
  		answer = gets.chomp.downcase
  		break if ['y','n'].include?(answer)
  		puts "enter y or n"
  	end
  	if answer == 'y'
  		true
  	else
  		false
  	end
  end
  

  def play
    display_welcome_message
    loop do
    human.choose
    computer.choose
    display_winner
    break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play