class Game
    def initialize 
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
        splited_word = @word.split("")
        puts "select a new letter"
        selected_letter = gets.chomp.downcase
        if splited_word.include?(selected_letter)
            splited_word.each_with_index do |value, index|
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
    
    def play
        attempts = 10
        @incorrect_letters = []
        @output_word = []
        @guessed_correctly = false
        @indexes_already_taken = []
        load_dictionary
        select_word(@dictionary)
        while attempts > 0 do
            try_to_guess
            if !@guessed_correctly
                attempts -= 1
            elsif @indexes_already_taken.length == @word.length
                puts "Yeeeey you guessed correctly, congrats"
                break
            end
        end
        if attempts == 0 
            puts "Game Over"
            puts "the word was #{@word}"
        end
    end
end

game_1 = Game.new
game_1.play

