require_relative 'round'
require 'yaml'


def save_game(current_game)
  filename = prompt_name
  return false unless filename
  dump = YAML.dump(current_game)
  File.open(File.join(Dir.pwd, "/saves/#{filename}.yaml"), 'w') { |file| file.write dump }
end

def prompt_name
  Dir.mkdir(File.join(Dir.pwd, "/saves/")) unless Dir.exist?(Dir.pwd + "/saves/")

  begin
    file_list = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))]}
    puts "Enter name for saved game:"
    filename = gets.chomp
    raise "#{filename} already exists." if file_list.include?(filename)
    filename
  rescue StandardError => e
    puts "#{e} Are you sure you want to overwrite this file? (Y/N)"
    answer = gets.chomp.upcase
    until answer == "Y" || answer == "N"
      puts "Invalid input. #{e} Are you sure you want to overwrite this file? (Y/N)"
      answer = gets.chomp.upcase
    end
    answer == "Y" ? filename : false
  end
end

def load_game
  file_list = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
  if file_list == []
    puts "No save file available! Starting new game..."
    return Round.new
  end
  
  filename = choose_game
  saved_file = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.load(saved_file)
  saved_file.close
  loaded_game
end

def choose_game
  begin
    puts
    puts "Here are the current saved games. Please choose which you'd like to load."
    file_list = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts file_list
    filename = gets.chomp
    raise "#{filename} does not exist." unless file_list.include?(filename)
    puts "#{filename} loaded..."
    puts
    "/saves/#{filename}.yaml"
  rescue StandardError => e
    puts e
    retry
  end
end

# Main
puts "Welcome to Hangman!"
puts "Type \"1\" to start a new game."
puts "Type \"2\" to load a game."

user_choice = gets.chomp
until ['1', '2'].include?(user_choice)
  puts "Invalid input. Please enter 1 or 2"
  user_choice = gets.chomp
end

if user_choice == "1"
  game_round = Round.new
else
  game_round = load_game
end

while game_round.is_playing == true do
  game_round.play_turn
  if game_round.to_save == true
    if save_game(game_round)
      puts "Your game has been saved. Thanks for playing!"
      break
    end
  end
end