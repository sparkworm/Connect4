
class_name Level
extends Node2D

@export var piece_scene: PackedScene
@export var dimensions := Vector2i(7,6)
@export var drop_speed := 400.0

var game: Game
var game_active: bool = true

@onready var visible_board: VisibleBoard = $VisibleBoard
@onready var piece_holder: Node2D = $PieceHolder
@onready var popup_layer: CanvasLayer = $PopupLayer
@onready var win_label: Label = $PopupLayer/PanelContainer/MarginContainer/VBoxContainer/WinLabel

func _ready() -> void:
	visible_board.create_board(dimensions)
	visible_board.position = -visible_board.tile_set.tile_size * dimensions / 2

	# create players
	var player1 = PlayerHuman.new(Globals.Team.RED)
	var player2 = PlayerAI.new(Globals.Team.BLUE)

	game = Game.new([player1, player2])

	game.player_won.connect(game_won)
	game.piece_dropped.connect(drop_piece)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop_piece") and game.is_active_player_human() and game_active:
		var col := visible_board.get_mouse_col()
		if col != -1:
			var color := game.get_active_player_team()
			var land_pos := game.make_player_move(col)


## Animates the dropping of a piece to the specified position.
func drop_piece(team: Globals.Team, pos: Vector2i) -> void:
	# create piece
	var new_piece = piece_scene.instantiate() as Piece
	# set team for piece
	new_piece.initialize(team)
	# set piece position
	new_piece.position.x = visible_board.tile_set.tile_size.x * (pos.x+.5) + visible_board.position.x
	new_piece.position.y = -visible_board.tile_set.tile_size.y + visible_board.position.y
	#new_piece.position += Vector2(visible_board.tile_set.tile_size) / 2
	# add piece to scene
	piece_holder.add_child(new_piece)
	var piece_drop_tween := get_tree().create_tween()
	var final_pos := Vector2(visible_board.tile_set.tile_size * pos) + visible_board.position
	final_pos += Vector2(visible_board.tile_set.tile_size) / 2
	var drop_time: float = (final_pos.y - new_piece.position.y) / drop_speed
	piece_drop_tween.tween_property(new_piece, "position", final_pos, drop_time)
	piece_drop_tween.tween_callback(game.next_player)

func game_won(_winner: Player) -> void:
	win_label.text = "Player " + str(game.active_player_idx+1) + " won!"
	popup_layer.show()
	game_active = false
