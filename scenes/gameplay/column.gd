class_name Column
extends Node

## pieces listed from top to bottom
var pieces: Array[Globals.Team]

func _init(height:=6) -> void:
	for spot in range(height):
		pieces.append(Globals.Team.EMPTY)

# TODO
func is_full() -> bool:
	return pieces[0] != Globals.Team.EMPTY

## Drops a piece to lowest available position
## [br]Returns the idx of where the piece lands
func add_piece(team: Globals.Team) -> int:
	if is_full():
		print("WARNING, ATTEMPTING TO ADD TO FULL COLUMN")
		return -1
	# place piece before any existing pieces
	for spot: int in range(pieces.size()):
		# if the spot is not empty
		if(pieces[spot] != Globals.Team.EMPTY):
			# add to the prior spot (which was empty)
			pieces[spot-1] = team
			return spot-1
	pieces[pieces.size()-1] = team
	return pieces.size()-1
	print("NO SPOT FOUND?")

## Returns the piece at the location indicated, with idx==0 being at the top of the column
func get_piece(idx:int) -> Globals.Team:
	return pieces[idx]
