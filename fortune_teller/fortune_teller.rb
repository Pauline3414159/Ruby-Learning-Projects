# section has a number to id, and a fortune to display. It is collaberator
# to FortuneCatcher
class Section
	
	attr_reader :number, :fortune
	
	def initialize(number, fortune)
		@number = number
		@fortune = fortune
	end
	
	def to_s
		@fortune
	end
	
end

# is boss of section, holds two arrays of sections, also creates the arrays
class FortuneCatcher
	
	attr_reader :group_one, :group_two, :group_all
	
	LIST_OF_FORTUNES = [
		'It is certain.',
    'It is decidedly so.',
    'Without a doubt.',
    'Yes - definitely.',
    'You may rely on it.',
    'As I see it, yes.',
    'Most likely.',
    'Outlook good.',
    'Yes.',
    'Signs point to yes.',
    'Reply hazy, try again.',
    'Ask again later.',
    'Better not tell you now.',
    'Cannot predict now.',
    'Concentrate and ask again.',
    "Don't count on it.",
    'My reply is no.',
    'My sources say no.',
    'Outlook not so good.',
    'Very doubtful.'
		]
	
	def initialize
		@group_all = []
		@group_one = []
		@group_two = []
		create_group_all
		create_groups
	end
	
	private
	
	def create_group_all
		fortunes = LIST_OF_FORTUNES.sample(8)
		(1..8).to_a.each { |num| @group_all << Section.new(num, fortunes[num-1])}
	end
	
	def create_groups
		group_all.sample(4).each { |section| group_one << section }
		(group_all - group_one).each { |section| group_two << section }
	end
	
end

# orchestration brings the use of the fortune catcher together
class Orchestration
	
	attr_accessor :question, :group
	
	def initialize
		@catcher = FortuneCatcher.new
		@question = nil
		@group = nil
	end
	
	def use
		ask_question
		choose_group == true ? @group = @catcher.group_one : @group = @catcher.group_two
		change_group if change_group?
		display_fortune(choose_fortune)
	end
	
	private
	def ask_question
		puts "Enter your question"
		ans = nil
		loop do
			ans = gets.chomp
			break if ans.include?('?')
			puts "Remember to include a question mark at the end of your question"
		end
		@question = ans
	end
	
	def choose_group
		puts "Choose 1 or 2"
		ans = nil
		loop do
			ans = gets.chomp.to_i
			break if [1,2].include?(ans)
			puts "enter 1 or 2"
		end
		ans == 1
	end
	
	def change_group?
		numbers = group.collect(&:number)
		puts "Pick a number: (#{numbers.join(' ')})"
		ans = nil
		loop do
			ans = gets.chomp.to_i
			break if numbers.include?(ans)
			puts "Enter a valid number"
		end
		ans.odd?
	end
	
	def change_group
		group == @catcher.group_one ? @group = @catcher.group_two : @group = @catcher.group_one
	end
	
	def choose_fortune
		numbers = group.collect(&:number)
		puts "Pick a number: (#{numbers.join(' ')})"
		ans = nil
		loop do
			ans = gets.chomp.to_i
			break if numbers.include?(ans)
			puts "Enter a valid number"
		end
		ans
	end
	
	def display_fortune(num)
		choice = group.select { |section| section.number == num}
		puts "#{choice.first.fortune}"
	end
end

test = Orchestration.new

test.use

