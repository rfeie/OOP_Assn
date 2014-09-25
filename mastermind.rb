##TODO

#old guesses
## do code breaker

class MasterMind
	attr_reader :pegs
	
	def initialize
		@pegs = ["red","green","yellow","blue","indigo","violet"]
		@turn = 1
		@guesses = {}
		@score = {codemaker: 0, codebreaker: 0}

		#initialize codemaker and breaker
		@codemaker = CodeMaker.new(self)
		@codebreaker = CodeBreaker.new
		play
	end

	def old_guesses
		#render old guesses here
		#hash of turn, guess and response

		@guesses.each do |turn, guess|
			info = render_guess(guess)
			puts "#{turn}: #{info}"
		end

	end

	def play
		#render old guesses
		puts "Next turn!\n\nOld Guesses"
		old_guesses
		#run getinput to checkguess
		the_guess = @codemaker.check_guess(@codebreaker.get_input(@pegs))
		#if guess correct, end game
		if the_guess[:correct] == true
			@guesses[@turn] = the_guess
			puts "Game is won!\nAll colors were correct."
			puts render_guess(the_guess)
			if play_again? == true
				return MasterMind.new
			end
		elsif @turn >= 12

			puts render_guess(the_guess)
			@guesses[@turn] = the_guess
			puts "Out of turns!"			
			if play_again? == true
				return MasterMind.new
			end
			else
			puts "Game is not over yet.\n"	
			puts render_guess(the_guess)
			@guesses[@turn] = the_guess
			@turn += 1
			return play
		end

	end

	def render_guess(info)
		info_str = ""

			info[:all_guesses].each do |item|
				info_str += "#{item[0]}: #{item[1]}. "
			end

		info_str
	end

	def play_again?
		puts "Do you want to play again? (yes/no)"
		response = gets.chomp
		return response.downcase == "yes"
	end
end


class CodeMaker

	attr_reader :score

	def initialize(master_mind)
		@score = 0
		@pattern = master_mind.pegs.sample(4)
		puts "Secret Pattern is: #{@pattern}"
	end

	def check_guess(guess)
		checked_data = {correct: false, all_guesses: []}
		correct_count = 0
		guess.each_with_index do |color, idx|
			#compare with code
			#if not exist set code
			this_guess = [color]
			if @pattern.include?(color)
					if @pattern.rindex(color) == idx
						this_guess << "Correct"
						correct_count += 1
					## correct pos	
					else
						this_guess << "Wrong Location"
					## wrong pos
					end

			else
				this_guess << "Doesn't Exist"
			end
			checked_data[:all_guesses] <<  this_guess
		end
		checked_data[:correct] = true if correct_count == 4
		checked_data
	end

end

class CodeBreaker
	def initialize
		@name = gets.chomp

	end

	def get_input(valid_colors)
		puts "What is your guess?\nValid colors are #{valid_colors}"
		guesses = []

		4.times do |n|
			valid = false
			guess = gets.chomp
			until valid
				if valid_colors.include?(guess)
					valid = true
				else
					puts "What is your guess?\nValid colors are #{valid_colors}"
					guess = gets.chomp
				end
			end
			guesses << guess
		end 
		guesses
	end


end

MasterMind.new
