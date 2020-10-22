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
	end
	
	def create_deck
		SUITES.each do |suite|
			counter = 0
			until counter == FACE_NAMES.size - 1
			draw_pile << Card.new(suite, FACE_NAMES[counter], VALUES[counter])
			counter += 1
			end
		end
	end
	
end

