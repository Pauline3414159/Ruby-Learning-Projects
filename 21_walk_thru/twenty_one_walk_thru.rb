# frozen_string_literal: true

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
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 1].freeze

  def initialize
    @draw_pile = []
    create_deck
    shuffle_deck
  end

  private

  def create_deck
    SUITES.each do |suite|
      counter = 0
      until counter == FACE_NAMES.size
        draw_pile << Card.new(suite, FACE_NAMES[counter], VALUES[counter])
        counter += 1
      end
    end
  end

  public

  def shuffle_deck
    draw_pile.shuffle!
  end

  def take_cards(num)
    draw_pile.pop(num)
  end
end

# the participants
class Participants
  attr_accessor :name, :hand, :score, :is_busted

  def initialize(name)
    @name = name
    @hand = []
    @score = 0
    @is_busted = false
  end

  def value
    number_of_aces = num_of_ace
    if number_of_aces.zero?
      non_ace_value
    elsif non_ace_value <= (10 - (number_of_aces - 1))
      11 + (num_of_ace - 1)
    else
      non_ace_value + number_of_aces
    end
  end
  
  def busted?
  	value > 21
  end

  private

  def non_ace_value
    hand.reject { |card| card.face_name == 'Ace' }.map(&:value).sum
  end

  def num_of_ace
    hand.select { |card| card.face_name == 'Ace' }.size
  end
end

module Displayable
  private

  def display_scores
    puts "#{player.name}'s score is #{player.score}."
    puts "Dealer's score is #{dealer.score}."
  end

  def display_dealer_hand
    puts "Dealer has a #{dealer.hand[0]} and one hidden card."
  end

  def display_full_hand(participant)
    puts "#{participant.name} has a #{participant.hand[0..-2].join(', ')} and a #{participant.hand[-1]}."
  end

  def display_hand_value(participant)
    puts "#{participant.name}'s hand has a value of #{participant.value}."
  end

  def display_welcome_msg
    puts 'Welcome to 21!'
  end
end

# the game engine orchestrates the game
class GameEngine
  include Displayable
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Participants.new('')
    @dealer = Participants.new('Dealer')
  end

  def play
    pre_game
    @player.name = player_name
    loop do
      deal_initial_hands
      player_turn
      if bust?(player.value)
        increment_score(dealer)
        display_scores
        if another_round? == true
          reset
          next
        else
          break
        end
      end
      dealer_turn
      if bust?(dealer.value)
        increment_score(player)
        display_scores
        if another_round? == true
          reset
          next
        else
          break
        end
      end
      if tie?
        display_hand_value(player)
        display_hand_value(dealer)
        display_scores
        if another_round? == true
          reset
          next
        else
          break
        end
      else
        display_hand_value(player)
        display_hand_value(dealer)
        increment_score(winner)
        display_scores
        if another_round? == true
          reset
          next
        else
          break
        end
      end
    end
    post_game
  end

  private
  
  

  def winner
    (21 - player.value) < (21 - dealer.value) ? player : dealer
  end

  def tie?
    player.value == dealer.value
  end

  def tie
    puts "It's a tie."
  end

  def post_game
    puts 'Thanks for playing 21! Goodbye.'
  end

  def pre_game
    display_welcome_msg
  end

  def player_name
    ans = nil
    puts "What's your name?"
    loop do
      ans = gets.chomp.capitalize
      break if ans.chars.all?(/\w/)

      puts 'only enter letters, numbers, or underscore'
    end
    ans
  end

  def increment_score(participant)
    participant.score += 1
  end

  def deal_initial_hands
    deck.take_cards(2).each { |card| player.hand << card }
    deck.take_cards(2). each { |card| dealer.hand << card }
  end

  def another_round?
    puts 'Would you like to play another round? (y/n)'
    ans = nil
    loop do
      ans = gets.chomp.downcase
      break if %w[y n].include?(ans)

      puts 'Enter y to play again or n to exit.'
    end
    ans == 'y'
  end

  def reset
    player.hand.pop(player.hand.size).each { |card| deck.draw_pile << card }
    dealer.hand.pop(dealer.hand.size).each { |card| deck.draw_pile << card }
    deck.shuffle_deck
  end

  def player_hit?
    ans = nil
    puts '(h)it or (s)tay?'
    loop do
      ans = gets.chomp.downcase
      break if %w[h s].include?(ans)

      puts 'Please enter h or s.'
    end
    ans == 'h'
  end

  def player_turn
    display_dealer_hand
    loop do
      display_full_hand(player)
      display_hand_value(player)
      if bust?(player.value)
        bust(player)
        break
      end
      player_hit? == true ? hit(player) : break
    end
  end

  def dealer_turn
    loop do
      display_full_hand(dealer)
      if bust?(dealer.value)
        bust(dealer)
        break
      end
      over?(17, dealer.value) == false ? hit(dealer) : break
    end
  end

  def hit(participant)
    deck.take_cards(1).each { |card| participant.hand << card }
  end

  def over?(num, hand_val)
    num < hand_val
  end

  def bust?(hand_val)
    over?(21, hand_val)
  end

  def bust(participant)
    puts "#{participant.name} has busted."
  end
end

test = GameEngine.new

test.play
