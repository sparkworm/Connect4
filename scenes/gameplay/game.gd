## Manages the players and board of a given game
class_name Game
extends Node

signal piece_dropped(color: Globals.Team, land_pos: Vector2i)
signal active_player_changed(new_player: Player)
signal player_won(winner: Player)

## holds all players (probably 2)
var players: Array[Player]
## index of players indicating active player
var active_player_idx: int

var board: Board

func _init(player_list: Array[Player]) -> void:
	board = Board.new()
	board.initialize_board()

	players = player_list
	for player: Player in players:
		# if the player is an AI, set their board property to reference board
		if player is PlayerAI:
			player.board = board

	for player: Player in players:
		player.move_made.connect(make_player_move)

func get_active_player_team() -> Globals.Team:
	return get_active_player().team

func make_player_move(col: int) -> Vector2i:
	var land_pos := board.add_piece(col, get_active_player_team())
	#print("\n\n")
	#for dir: Vector2i in Globals.DIRECTIONS:
		#print("in line ", dir, " : ", board.count_pieces_in_line(land_pos, dir))
	piece_dropped.emit(get_active_player_team(), land_pos)
	if board.check_win(land_pos):
		player_won.emit(get_active_player())
		print("PLAYER ", active_player_idx+1, " HAS WON!")
	# ensures that game won't go to
	else:
		next_player()
	return land_pos

func next_player() -> void:
	active_player_idx = wrap(active_player_idx+1, 0, players.size())
	active_player_changed.emit(get_active_player())
	if get_active_player() is PlayerAI:
		(get_active_player() as PlayerAI).take_turn()

func get_active_player() -> Player:
	return players[active_player_idx]

func is_active_player_human() -> bool:
	return get_active_player() is PlayerHuman
