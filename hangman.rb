module RoundFunctions
  def choose_word
    @letter_chosen = gets.chomp.upcase
    if @letters_used.include?(@letter_chosen)
      puts "The letter #{@letter_chosen} is already chosen. Please choose another letter."
    elsif @letter_chosen.length > 1
      puts "Please choose only 1 letter!"
    else
      @letters_used << @letter_chosen
      @letters_used.sort!
      check_letter(@letter_chosen)
    end
  end

  def check_letter(letter)
    is_correct = false
    0.upto(@word.length - 1) do |index| 
      if @word[index] == letter
        @current_progress[index] = letter
        is_correct = true
      end
    end

    if is_correct
      puts "Correct! You still have #{@lives} lives left."
    else
      @lives -= 1
      puts "The letter #{letter} is not inside. #{@lives} lives left."
    end
  end
end

class Round
  include RoundFunctions
  
  attr_reader :is_playing
  attr_accessor :current_progress

  def initialize(array)
    @word = array[rand(array.length)]
    @current_progress = []
    0.upto(@word.length - 1) { |index| @current_progress[index] = "_" }
    @letters_used = []
    @letter_chosen = ""
    @lives = 8
    @is_playing = true
    puts "#{@current_progress.join(" ")}"
    puts ""
  end

  def play_turn
    puts "Choose a letter! Current letters used: #{@letters_used.join(", ")} (#{@lives} lives left)"
    choose_word

    #Win Condition
    unless @current_progress.include?("_")
        @is_playing = false
        display_board
        puts "You Win!"
        return
    end

    #GameOver Condition
    if @lives == 0
        @is_playing = false
        display_board
        puts "You Lose! The answer is #{@word}."
        return
    end

    display_board
  end

  private
  def display_board
      puts ""
      puts "#{@current_progress.join(" ")}"
      puts ""
  end
end

word_list = File.read("5desk.txt").split("\r\n").select { |word| word.length >= 5 && word.length <= 12}
word_list.map! {|word| word.upcase}

game_round = Round.new(word_list)

while (game_round.is_playing == true) do
  game_round.play_turn
end