# frozen_string_literal: true

require 'pry'
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
    elsif non_ace_value < (10 - (number_of_aces - 1))
      11 + (num_of_ace - 1)
    else
      non_ace_value + number_of_aces
    end
  end

  def check_for_bust
    @is_busted = true if value > 21
  end

  private

  def non_ace_value
    hand.reject { |card| card.face_name == 'Ace' }.map(&:value).sum
  end

  def num_of_ace
    hand.select { |card| card.face_name == 'Ace' }.size
  end
end

# contains all the display messages
module Displayable
  private

  def display_bust(participant)
    puts "#{participant.name} has busted."
  end

  def display_scores
    puts "#{player.name}'s score is #{player.score}."
    puts "Dealer's score is #{dealer.score}."
  end

  def display_dealer_hand
    puts "Dealer's has a #{dealer.hand[0]} and one hidden card."
  end

  def display_full_hand(participant)
    puts "#{participant.name}'s hand has a #{participant.hand[0..-2].join(', ')} and a #{participant.hand[-1]}."
  end

  def display_hand_value(participant)
    puts "#{participant.name}'s hand has a value of #{participant.value}."
  end

  def display_welcome_msg
    puts 'Welcome to 21!'
  end

  def display_hands_and_scores
    display_hand_value(player)
    display_hand_value(dealer)
    display_scores
  end

  def display_hands_and_scores_with_winner
    display_hand_value(player)
    display_hand_value(dealer)
    increment_score(winner)
    display_scores
  end
end

# contains pregame methods
module Pregameable
  private

  def pre_game
    display_welcome_msg
  end
end

# the game engine orchestrates the game
class GameEngine
  include Displayable
  include Pregameable
  attr_accessor :deck, :player, :dealer, :is_anyone_busted

  def initialize
    @deck = Deck.new
    @player = Participants.new('')
    @dealer = Participants.new('Dealer')
    @is_anyone_busted = false
  end

  def play
    pre_game
    @player.name = player_name
    loop do # main game loop
      deal_initial_hands
      loop do # exit to win eval loop
        player_turn
        player_busted if player.is_busted == true
        break if is_anyone_busted == true

        dealer_turn
        dealer_busted if dealer.is_busted == true
        break
      end
      if is_anyone_busted == true
        if another_round? == true
          reset
          next
        else
          break
        end
      end
      if tie?
        display_hands_and_scores
        if another_round? == true
          reset
          next
        else
          break
        end
      else
        display_hands_and_scores_with_winner
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

  def player_busted
    display_bust(player)
    increment_score(dealer)
    display_scores
    @is_anyone_busted = true
  end

  def dealer_busted
    display_bust(dealer)
    increment_score(player)
    display_scores
    @is_anyone_busted = true
  end

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
    reset_deck
    reset_busted_states
  end

  def reset_deck
    player.hand.pop(player.hand.size).each { |card| deck.draw_pile << card }
    dealer.hand.pop(dealer.hand.size).each { |card| deck.draw_pile << card }
    deck.shuffle_deck
  end

  def reset_busted_states
    @is_anyone_busted = false
    player.is_busted = false
    dealer.is_busted = false
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
      player.check_for_bust
      break if player.is_busted

      player_hit? == true ? hit(player) : break
    end
  end

  def dealer_turn
    loop do
      display_full_hand(dealer)
      dealer.check_for_bust
      break if dealer.is_busted

      dealer.value > 17 == false ? hit(dealer) : break
    end
  end

  def hit(participant)
    deck.take_cards(1).each { |card| participant.hand << card }
  end
end

test = GameEngine.new

test.play
