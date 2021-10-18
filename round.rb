module RoundFunctions
  def choose_letter
    @letter_chosen = gets.chomp.upcase

    if @letter_chosen.include?("SAVE")
      @letter_chosen = ""
      @to_save = true
      return
    end
    
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
  
  attr_reader :is_playing, :letter_chosen, :to_save

  def initialize
    @word = choose_word
    @current_progress = []
    0.upto(@word.length - 1) { |index| @current_progress[index] = "_" }
    @letters_used = []
    @letter_chosen = ""
    @lives = 8
    @is_playing = true
    @to_save = false
    display_board
  end

  def play_turn
    if @to_save == true
      @to_save = false
      display_board
    end

    puts "*Type \"save\" to save the game*"
    puts "Choose a letter! Current letters used: #{@letters_used.join(", ")} (#{@lives} lives left)"
    choose_letter

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
      puts
      puts "#{@current_progress.join(" ")}"
      puts
  end

  def choose_word
    word_list = File.read("5desk.txt").split("\r\n").select { |word| word.length >= 5 && word.length <= 12}
    word_list.map! {|word| word.upcase}
    word_list[rand(word_list.length)]
  end
end

