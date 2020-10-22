# section has a number to id, and a fortune to display. It is collaberator
# to FortuneCatcher
class Section
	
	attr_reader :number, :fortune
	
	def initialize(number, fortune)
		@number = number
		@fortune = fortune
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
