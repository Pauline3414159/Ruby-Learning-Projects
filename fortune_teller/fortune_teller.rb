# frozen_string_literal: true

require 'pry'
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
  ].freeze

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
    (1..8).to_a.each { |num| @group_all << Section.new(num, fortunes[num - 1]) }
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
    display_welcome_message
    loop do
      ask_question
      @group = choose_group == true ? @catcher.group_one : @catcher.group_two
      change_group if change_group?
      display_fortune(choose_fortune)
      break if exit? == true
    end
    display_goodbye_msg
  end

  private

  def clear_screen
    system 'clear' || (system 'clr')
  end

  def ask_question
    sleep 1.5
    clear_screen
    puts 'Enter your question about the future.'
    ans = nil
    loop do
      ans = gets.chomp
      break if ans.include?('?')

      puts 'Remember to include a question mark at the end of your question'
    end
    @question = ans
  end

  def choose_group
    clear_screen
    puts 'Choose (h)eads or (t)ails.'
    ans = nil
    loop do
      ans = gets.chomp.downcase
      break if %w[h t].include?(ans)

      puts 'enter h or t'
    end
    ans == 'h'
  end

  def change_group?
    clear_screen
    numbers = group.collect(&:number)
    puts "Pick a number: (#{numbers.join(' ')})"
    ans = nil
    loop do
      ans = gets.chomp.to_i
      break if numbers.include?(ans)

      puts 'Enter a valid number'
    end
    ans.odd?
  end

  def change_group
    @group = group == @catcher.group_one ? @catcher.group_two : @catcher.group_one
  end

  def choose_fortune
    clear_screen
    numbers = group.collect(&:number)
    puts "Pick a number: (#{numbers.join(' ')})"
    ans = nil
    loop do
      ans = gets.chomp.to_i
      break if numbers.include?(ans)

      puts 'Enter a valid number'
    end
    ans
  end

  def display_fortune(num)
    clear_screen
    puts 'The answer is ...'
    sleep 0.5
    choice = group.select { |section| section.number == num }
    puts choice.first.fortune.to_s
  end

  def exit?
    puts '(e)xit?'
    ans = nil
    loop do
      ans = gets.chomp.downcase
      break if %w[e y n].include?(ans)

      puts 'Enter e or y to exit, or n to continue.'
    end
    # binding.pry
    %w[e y].include?(ans)
  end

  def display_goodbye_msg
    clear_screen
    sleep 1
    puts 'Thank you for using Fortune Teller Catcher! Goodbye.'
    sleep 1
  end

  def display_welcome_message
    puts 'Welcome to Fortune Teller Catcher! Find out your FUTURE11!11!'
  end
end

test = Orchestration.new

test.use
