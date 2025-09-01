## Script for AI players
class_name PlayerAI
extends Player

## Reference to the game board
var board: Board

## returns the col that the piece will be played in.
## TODO: game needs to assure that there are viable moves
func take_turn() -> void:
	print("AI move: ", pick_best_move())
	var best_move := pick_best_move()
	board.print_board()
	move_made.emit(best_move)
	print("after move")
	board.print_board()

func pick_best_move() -> int:
	var best_score := 0
	var best_col := 0
	# set to column where enemy can be blocked, stays -1 if there are none
	var block_col := -1
	for col in range(Globals.COL_AMNT): # NOTICE: maybe change to game columns?
		var col_score: int = evaluate_move(col)
		# -1 indicates that the move is an instant win
		if col_score == -1:
			return col
		if col_score == -2:
			block_col = col
		if col_score > best_score:
			best_col = col
			best_score = col_score
	if block_col != -1:
		return block_col
	return best_col

## returns a score for placing a piece in a given column
## [br][br]
## -1 means the move is an instant win,
## [br]-2 indicates that the move will block an opponent victory
## [br]-3 indicates that the move is not possible (NOTE: this should never be chosen for move as default
## is 0, so -3 will never be greater
## [br]otherwise, the higher the better
func evaluate_move(col:int) -> int:
	# cancel if col is invalid
	if col < 0 or col >= board.columns.size():
		return -3

	# check to see if the enemy would win if they played here
	#var enemy_board: Board = board.duplicate()
	#enemy_board.columns = board.columns.duplicate(true) # WARNING: may only be references
	#print("normal columns size: ", board.columns.size())
	#print("duplicate columns size: ", enemy_board.columns.size())
	# WARNING: only works with one enemy in this state
	var enemy_piece_location: Vector2i = board.add_piece(col, Globals.get_opposing_team(team))
	for dir:Vector2i in Globals.DIRECTIONS:
		var in_line: int = board.count_pieces_in_line(enemy_piece_location, dir)
		# check enemy win
		if in_line >=4:
			board.remove_piece(enemy_piece_location)
			return -2
	board.remove_piece(enemy_piece_location)

	# calculate score
	var score:= 0
	#var new_board: Board = board.duplicate()
	#new_board.columns = board.columns.duplicate(true) # WARNING: may only be references
	var piece_location: Vector2i = board.add_piece(col, team)
	for dir:Vector2i in Globals.DIRECTIONS:
		var in_line: int = board.count_pieces_in_line(piece_location, dir)
		# check win
		if in_line >=4:
			board.remove_piece(piece_location)
			return -1
		score += in_line - 1 # since in_line will always be at least one
	board.remove_piece(piece_location)

	#print("Column ", col, " : ")
	#for c: Globals.Team in board.columns[col].pieces:
		#print("\t", c)
	return score
