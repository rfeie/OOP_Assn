players =["hi", "there", "ruby"]

turn = players[0]
puts turn

10.times do |num|
#puts num
if players.index(turn) >= players.length - 1 
	turn = players[0]
	puts turn

else
	turn = players[players.index(turn) + 1]
	puts turn
end



end