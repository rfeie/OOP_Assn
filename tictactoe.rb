#where to initialize players? Game?



class Game

	attr_reader :game_data

	def initialize
		num_players = 2

		@game_data = {}
		@players = []
		@board = board
		@marks = {}

		num_players.times do |num|
			puts "What is Player #{num}'s name?"
			name = gets.chomp
			puts "What is #{name}'s mark?"
			mark = gets.chomp
			if @game_data.key(mark) 
				puts "#{mark} is taken! Choose another!"
				mark = gets.chomp
			end
			name = Player.new(name, mark)
			@players << name
			@marks[mark] = []
			@game_data[name] = 0
		end
		@score = score_draw(@game_data)
		@turn = @players[0]

		play
	end

	def score_draw(game_data)

		score = ""
		game_data.each do |player, score|
			score = "#{player.name}: #{score} "
		end
		score
	end

	def board
		board = Board.new()
	end
	def game_over? 
		positions = []
		
		@marks[@turn.mark].each {|num| positions << num.pos}
		puts positions.to_s
		positions.sort!

		positions = positions.join
#		puts positions
		success = positions.match(/123|456|789|147|258|369|159|357/)
#		puts success
		success = success != nil

	end

	def get_input
		puts "#{@turn.name}, make your selection"
		choice = gets.chomp.to_i
		while (choice < 1) or (choice > 9)
			puts "Selection needs to be 1 through 9"
			choice = gets.chomp.to_i			
		end
		while mark_exists?(choice)
			puts "#{@turn.name}, Mark already exists!"
			choice = gets.chomp.to_i
		end
		choice = Marker.new(choice, @turn.mark)
		choice 
	end

	def play
		puts @board.draw_board(@marks.values.flatten)
		@marks[@turn.mark].push(get_input)
		if game_over?
			@game_data[@turn] = @game_data[@turn] + 1
			puts "Game Over! #{@turn.name} wins!"
			puts "Play again? (yes/no)"
			again = gets.chomp.downcase
			if again == "yes"
				@marks.each {|m| @marks[m] = []}
				@turn = next_item(@turn, @players)
				play
			end

		else
			@turn = next_item(@turn, @players)
			play
		end

	end

	def mark_exists?(choice)
		found = false
		@marks.values.flatten.each {|mark| found = true if mark.pos == choice}
		found
	end
	def next_item(current, list)
		if list.index(current) >= list.length - 1 
			current = list[0]
			current

		else
			current = list[list.index(current) + 1]
			current
		end
	end
end


class Board
	# score?
	def initialize
		@board ="1|2|3\n4|5|6\n7|8|9"

	end

	def draw_board(marks)
		new_board = @board
		marks.each do |mark| 
			#puts new_board
			#puts mark.pos.to_s
			#puts mark.text
			new_board = new_board.gsub(mark.pos.to_s, mark.text)
		end
		new_board = new_board.gsub(/[1-6]/, "_").gsub(/[7-9]/, " ")
		new_board

	end

end

class Player
	
	attr_reader :name, :mark 

	def initialize(name, mark)
		@name = name
		@mark = mark
	end


end

class Marker
	attr_reader :pos, :text

	def initialize(pos, text)
		@pos = pos
		@text = text
	end

end

#board = Board.new
#puts board.draw_board([])

game = Game.new
