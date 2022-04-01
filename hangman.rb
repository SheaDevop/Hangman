require 'yaml'

class Game
    def initialize(word = nil, attempts = nil, incorrect_letters = [nil], output_word = [nil], guessed_correctly = nil, indexes_already_taken = [nil])
        @word = word
        @attempts = attempts
        @incorrect_letters = incorrect_letters
        @output_word = output_word
        @guessed_correctly = guessed_correctly
        @indexes_already_taken = indexes_already_taken
    end

    def load_dictionary
        @dictionary = []
        file = File.open("google-10000-english-no-swears.txt", "r")
        while !file.eof?
            line = file.readline
            @dictionary << line
        end 
    end
    
    def select_word(dictionary)
        @word = @dictionary.sample 
        unless @word.length > 5 && @word.length < 12
            @word = @dictionary.sample
        end
    end

    def try_to_guess
        splitted_word = @word.chomp.split("")
        puts "select a new letter"
        selected_letter = gets.chomp.downcase
        if splitted_word.include?(selected_letter)
            splitted_word.each_with_index do |value, index|
                if @indexes_already_taken.include?(index)
                    next
                elsif selected_letter == value
                    @output_word[index] = value
                    @indexes_already_taken << index
                else
                    @output_word[index] = "_"
                end
            end
            @guessed_correctly = true
        else
            @incorrect_letters << selected_letter
            @guessed_correctly = false
        end
        p @output_word
        puts "the incorrect letters you have choosen are #{@incorrect_letters}"
    end

    def player_has_won?
        word_guessed_state = @output_word.join
        if word_guessed_state == @word.chomp
            puts "Yeeeey you guessed correctly, congrats"
            return true
        end
    end
    
    def play
        puts "to play a new game enter the keyword 'new', to load an existing game, enter the keyword 'load'"
        @option = gets.chomp.downcase
        if @option == "new"
            play_new_game
        elsif @option == "load"
            puts "enter the saved game name"
            file_name = gets.chomp
            load_game(file_name)
        else
            puts "invalid keyword"
        end
    end

    def play_loaded
        while @attempts > 0 do
            player_has_won? ? break : try_to_guess
            if !@guessed_correctly
                @attempts -= 1
            end
        end
        if @attempts == 0 
            puts "Game Over"
            puts "the word was #{@word}"
        end
    end

    def play_new_game
        @attempts = 10
        @incorrect_letters = []
        @output_word = []
        @guessed_correctly = false
        @indexes_already_taken = []
        load_dictionary
        select_word(@dictionary)
        while @attempts > 0 do
            if @attempts < 10 
                puts "do you want to save the game? y/n"
                user_wanna_save = gets.chomp.downcase
                if user_wanna_save == "y"
                    puts "select a name for your game"
                    game_name = gets.chomp
                    save_game(game_name)
                end
            end
            player_has_won? ? break : try_to_guess
            if !@guessed_correctly
                @attempts -= 1
            end
        end
        if @attempts == 0 
            puts "Game Over"
            puts "the word was #{@word}"
        end
    end

    def to_yaml
        YAML.dump ({
            :word => @word,
            :attempts => @attempts,
            :incorrect_letters => @incorrect_letters,
            :output_word => @output_word,
            :guessed_correctly => @guessed_correctly,
            :indexes_already_taken => @indexes_already_taken
        })
    end

    def self.from_yaml(string)
        data = YAML.load string
        self.new(data[:word], data[:attempts], data[:incorrect_letters], data[:output_word], data[:guessed_correctly], data[:indexes_already_taken])
    end

    def save_game(game_name)
        game_file = File.open(game_name, "w")
        game_file.write to_yaml
        game_file.close
    end

    def load_game(game_file)
        file = File.open(game_file, "r")
        game_data = file.read 
        game_name = Game.from_yaml(game_data)
        game_name.play_loaded
    end
end

nachos_game = Game.new
nachos_game.play

def player_has_won?
    word_guessed_state = @output_word.join
    if word_guessed_state == @word
        puts "Yeeeey you guessed correctly, congrats"
        return true
    end
end