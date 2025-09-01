class_name Board
extends Node

var columns: Array[Column]

## Creates empty board of specified dimensions
func initialize_board(width:=7, height:=6):
	for col in range(width):
		columns.append(Column.new(height))
	print("columns size: ", columns.size())

## A meaty function that should determine the number of same-colored pieces in the row specified by
## a piece therin and the direction.
## [br]will check in direction and opposite direction
## REQUIRES TESTING
func count_pieces_in_line(piece_coords: Vector2i, dir: Vector2i) -> int:
	var count: int = 1
	var next_coords := piece_coords + dir
	#WARNING: make sure that this terminates if first part is false
	while (is_location_valid(next_coords) \
			and get_piece_at(next_coords) == get_piece_at(piece_coords)):
		count += 1
		next_coords += dir
	next_coords = piece_coords - dir
	while (is_location_valid(next_coords) \
			and get_piece_at(next_coords) == get_piece_at(piece_coords)):
		count += 1
		next_coords -= dir
	return count

func get_piece_at(coords: Vector2i) -> Globals.Team:
	# debug
	if not is_location_valid(coords):
		print("DANGER, INVALID LOCATION")
		return Globals.Team.EMPTY
	return columns[coords.x].get_piece(coords.y)

## Checks if coords is a valid location on the board
func is_location_valid(coords: Vector2i) -> bool:
	if coords.x < 0 or coords.x >= columns.size():
		#print("coords: ", coords, " invalid: out horizontally")
		return false
	if coords.y < 0 or coords.y >= columns[coords.x].pieces.size():
		#print("coords: ", coords, " invalid: out vertically")
		return false
	return true

## Adds a piece to specified column
## [br]Returns the position of the piece once it "lands"
func add_piece(col: int, team: Globals.Team) -> Vector2i:
	if columns[col].is_full():
		print("DANGER: ATTEMPTED TO ADD PIECE TO FULL COLUMN")
		return Vector2i(-1,-1)
	return Vector2i(col, columns[col].add_piece(team))

func remove_piece(pos: Vector2i) -> void:
	columns[pos.x].pieces[pos.y] = Globals.Team.EMPTY

## Returns true if the given piece is part of a row of 4 or greater
func check_win(pos: Vector2i) -> bool:
	for dir: Vector2i in Globals.DIRECTIONS:
		if count_pieces_in_line(pos, dir) > 3:
			return true
	return false

func print_board() -> void:
	for y in range(columns[0].pieces.size()):
		var col_str := ""
		for x in range(columns.size()):
			col_str += str(get_piece_at(Vector2i(x,y)))
		print(col_str)
