# cards have a suite, a facename, and a value. they are collaberator object
# to the deck

class Card
	attr_reader :suite, :face_name, :value
	
	def initialize(suite, face_name, value)
		@suite = suite
		@face_name = face_name
		@value = value
	end
	
	def to_s
		"#{face_name} of #{suite}"
	end
end

# the deck starts off with 52 cards
class Deck
	
	attr_accessor :draw_pile
	
	SUITES = %w[Clubs Hearts Diamonds Spades].freeze
	FACE_NAMES = %w[2 3 4 5 6 7 8 9 10 Jack King Queen Ace].freeze
	VALUES = [2, 3, 4, 5, 7, 8, 9, 10, 10, 10, 10, 1].freeze
	
	def initialize
		@draw_pile = []
		create_deck
		shuffle_deck
	end
	
	private
	def create_deck
		SUITES.each do |suite|
			counter = 0
			until counter == FACE_NAMES.size - 1
			draw_pile << Card.new(suite, FACE_NAMES[counter], VALUES[counter])
			counter += 1
			end
		end
	end
	
	def shuffle_deck
		draw_pile.shuffle!
	end
	
	public
	def take_cards(num)
		draw_pile.pop(num)
	end
	
end

# the participants
class Participants
	
	attr_accessor :name, :hand
	
	def initialize(name)
		@name = name
		@hand = []
	end
end

# the game engine orchestrates the game
class GameEngine
	
	attr_accessor :deck, :player, :dealer
	
	def initialize
		@deck = Deck.new
		@player = Participants.new(player_name)
		@dealer = Participants.new('dealer')
	end
	
	def play
		deal_initial_hands
	end
	
	private
	
	def player_name
		ans = nil
		puts "What's your name?"
		loop do
			ans = gets.chomp.capitalize
			break if ans.chars.all?(/\w/)
			puts "only enter letters, numbers, or underscore"
		end
		ans
	end
	
	def deal_initial_hands
		deck.take_cards(2).each { |card| player.hand << card }
		deck.take_cards(2). each { |card| dealer.hand << card }
	end
	
end

test = GameEngine.new

test.play