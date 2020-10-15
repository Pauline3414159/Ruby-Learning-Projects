class Book
	
	attr_reader :list
	
	def initialize
		#@breakfast = []
		#@lunch = []
		#@dinner = []
		@list = [test = Recipie.new('fake'), two = Recipie.new('test')]
	end
	
	def add_recipie
		puts "what is the name of the recipie?"
		ans = gets.chomp
		list << Recipie.new(ans)
	end
	
	def display_recipie_list
		puts "Please choose from the recipie list below."
		list.each_with_index { | recipie, index | puts "#{index + 1}. #{recipie.name}"}
	end
	
	def recipie_list_selection
		ans = nil
		loop do
			ans = gets.chomp.to_i
			break if (1 .. list.size).include?(ans)
			puts "Please enter a number between #{1} and #{list.size}"
		end
		ans - 1
	end
	
end

class Recipie
	
	attr_reader :name
	
	def initialize(name)
		@name = name
		@prep_time = nil
		@taste = nil
	end
	
	def prep_time_set
		puts "Please enter the time it takes to prep in minutes."
		ans = nil
		loop do
			ans = gets.chomp.to_i
			break if ans > 0
			puts "enter a prep time that is greater than zero"
		end
		@prep_time = ans
	end
	
end

class RankerEngine
	
	def initialize
		@choice = nil
		@book = Book.new
	end
	
	def display_welcome
		puts "Welcome to Recipie Ranker."
	end
	
	def display_goodbye
		puts "Thanks for using Recipie Ranker."
	end
	
	def display_options
		puts "Would you like to (a)dd a new recipies, edit the prep (t)ime of a "\
		"recipie, or (r)ank the taste?"
	end
	
	def display_read_me
		puts <<HEREDOC
		
"Recipie ranker allows you to enter recipies. Then, you can add how much
time it took you to cook the dish(in minutes) and how much you liked the 
dish (on a scale of 1 to 10. You can also sort your recipie rankings by
breakfast, lunch, and dinner."
HEREDOC
	press_any_key_to_continue
	end
	
	def press_any_key_to_continue
		puts "Press any key to cotinue "
		gets.chomp
		clear_screen(0.5)
	end
	
	def clear_screen(seconds = 0)
		sleep(seconds)
		system('clear') || system('clr')
	end
	
	def read_me?
		puts "Would you like to read the instruction manual? (y/n)"
		ans = nil
		loop do
			ans = gets.chomp.downcase
			break if %w(y n).include?(ans)
			puts "enter y or n"
		end
		ans == 'y'
	end
	
	def options_choice
		ans = nil
		loop do
			ans = gets.chomp.downcase
			break if ['a','t','r'].include?(ans)
			puts "Please enter a, t, or r."
		end
		ans
	end
	
	def navigation
		case options_choice
		when 'a' then @book.add_recipie
		when 't' then @book.display_recipie_list
									@book.list[@book.recipie_list_selection].prep_time_set #puts "nav to correct recipie, then add_time"
		when 'r' then puts "nav to correct recipie, then add_ranking"
	  end
	end
	
	def start
		display_welcome
		display_read_me if read_me?
		display_options
		options_choice
		navigation
		display_goodbye
	end
end

RankerEngine.new.start
		
	