
class Game

	attr_reader :game_data

	def initialize
		num_players = 2
		markers = [:X, :O]
		@game_data = {}
		@players = []
		@board = Board.new()
		@marks = {}

		num_players.times do |num|
			puts "What is Player #{num + 1}'s name?"
			name = gets.chomp
			mark = markers[num]
			@marks[mark] = []
			name = Player.new(name, mark)
			@players << name
			@game_data[name] = 0
		end
		@turn = @players[0]

		play
	end

	def score_draw(game_data)

		scores = ""
		game_data.each do |player, score|
			temp = "#{player.name}: #{score.to_s} "
			scores += temp
		end
		scores
	end

	def game_over? 
		positions = []
		
		@marks[@turn.mark].each {|num| positions << num.pos}
		positions.sort!

		positions = positions.join

		success = positions.match(/123|456|789|147|258|369|159|357/)
		success = success != nil
		message = {done: false,
		   		    message: "Not Yet."}

		if success
			message = {done: :victory,
			 		   message: "Game Over! \"#{@turn.name}\" wins!"}

		elsif @board.draw_board(@marks.values.flatten).match(/\d/) == nil

			message = {done: :draw,
			 		   message: "Game Over! Stalemate!"}

		end

			
		message
			
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
		result = game_over?
		if result[:done] == :victory
			@game_data[@turn] = @game_data[@turn] + 1
			puts result[:message]
			puts score_draw(@game_data)
			puts "Play again? (yes/no)"
			again = gets.chomp.downcase
			if again == "yes"
				newmarks = {}
				@marks.each {|m, list| newmarks[m] = []}
				@marks = newmarks
				@turn = next_item(@turn, @players)
				play
			end

		elsif result[:done] == :draw
			puts result[:message]
			puts score_draw(@game_data)
			puts "Play again? (yes/no)"
			again = gets.chomp.downcase
			if again == "yes"
				newmarks = {}
				@marks.each {|m, list| newmarks[m] = []}
				@marks = newmarks
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

	def initialize
		@board ="1|2|3\n4|5|6\n7|8|9"

	end

	def draw_board(marks)
		new_board = @board
		marks.each do |mark| 

			new_board = new_board.gsub(mark.pos.to_s, mark.text.to_s)
		end
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


game = Game.new
