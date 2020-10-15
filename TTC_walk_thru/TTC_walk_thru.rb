class Board
	  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9]] +
                  [[1,4,7],[2,5,8],[3,6,9]] +
                  [[1,5,9],[3,5,7]]
  def initialize
  	@squares = {}
  	reset
  end
  
  def get_square_at(key)
  	@squares[key]
  end
  
  def []=(num, marker)
    @squares[num].marker = marker
  end
  
  def unmarked_keys
  	@squares.keys.select { |key| @squares[key].unmarked? }
  end
  
  def full?
  	unmarked_keys.empty?
  end
  
  def someone_won?
  	!!winning_marker
  end
  
  def count_marker(squares)
  	arr = squares.collect(&:marker)
  	arr.count(arr.first)
  end
  
  def winning_marker
  	WINNING_LINES.each do |line|
  		if count_marker(@squares.values_at(*line)) == 3
  			return @squares.values_at(line[0])
  		end
  	end
  	nil
  end
  
  def reset
  	(1..9).each { |key| @squares[key] = Square.new}
  end
  

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
	
  	
  
end

class Square
	attr_accessor :marker
	
	INIT_MARKER = " "
	
  def initialize(marker = INIT_MARKER)
  	@marker = marker
  end
  
  def to_s
  	@marker
  end
  
  def unmarked?
  	marker == INIT_MARKER
  end
  
end

class Player
	attr_reader :marker
	
  def initialize(marker)
  	@marker = marker
  end


end

class TTTGame
	
	attr_reader :board, :human, :compueter
	
	HUMAN_MARKER = 'H'
	COMPUETER_MARKER = 'C'
	
	def initialize
		@board = Board.new
		@human = Player.new(HUMAN_MARKER)
		@compueter = Player.new(COMPUETER_MARKER)
	end
	
	def display_welcome_message
		puts "Welcome to Tic Tac Toe!"
		puts ""
	end
	
	def display_goodbye_message
		puts "Thanks for playing Tic Tac Toe!"
		puts "Goodbye."
	end
	
	def display_board
		#clear 
		puts "You are a #{HUMAN_MARKER}. Computer is a #{COMPUETER_MARKER}."
		board.draw
		puts ""
	end
	
	def clear_screen_and_display_board
		clear 
		puts "You are a #{HUMAN_MARKER}. Computer is a #{COMPUETER_MARKER}."
		board.draw
		puts ""
	end
	
	def display_result
		clear_screen_and_display_board
		case board.winning_marker
		when HUMAN_MARKER
			puts "You won!"
		when COMPUETER_MARKER
			puts "Computer won."
		else
			puts "It's a tie."
		end
	end
	
	def clear
		system('clear') || system('clr')
	end
	
	def human_moves
		puts "Choose a square  #{board.unmarked_keys.join(', ')}"
		square_choice = nil
		loop do
			square_choice = gets.chomp.to_i
			break if board.unmarked_keys.include?(square_choice)
			puts "Enter a valid number #{board.unmarked_keys.join(', ')}"
		end
		board[square_choice] = human.marker
	end
	
	def compueter_moves
		board[board.unmarked_keys.sample] = compueter.marker
	end
	
	def play_again?
		puts "would you like to play again? (y/n)"
		ans = ''
		loop do
			ans = gets.chomp.downcase
			break if %w(y n).include?(ans)
			puts "enter yes or no"
		end
		ans == 'y'
	end
	
	def reset
		board.reset
	  clear
	  
	end
	
	def display_play_again_msg
		puts "Let's play again."
		puts ""
	end
	
  def play
  	clear
    display_welcome_message
    loop do
	    display_board
	    loop do
	      
	      human_moves
	      break if board.someone_won? || board.full?
	      compueter_moves
	      clear_screen_and_display_board
	      break if board.someone_won?|| board.full?
	    end
	    display_result
	    break unless play_again?
	    reset
	    display_play_again_msg
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play