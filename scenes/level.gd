
class_name Level
extends Node2D

@export var piece_scene: PackedScene
@export var dimensions := Vector2i(7,6)
@export var drop_speed := 400.0
@export var p1_team: Globals.Team
@export var p2_team: Globals.Team

var game: Game
var game_active: bool = false

@onready var visible_board: VisibleBoard = $VisibleBoard
@onready var piece_holder: Node2D = $PieceHolder
#@onready var popup_layer: CanvasLayer = $PopupLayer
@onready var win_label: Label = %WinLabel
@onready var game_over_panel: PanelContainer = $PopupLayer/GameOverPanel
@onready var p1_checkbox: CheckBox = %P1Checkbox
@onready var p2_checkbox: CheckBox = %P2Checkbox
#@onready var player_select_panel: PanelContainer = $PopupLayer/PlayerSelectPanel
@onready var player_select: ColorRect = $PopupLayer/PlayerSelect

func _ready() -> void:
	visible_board.create_board(dimensions)
	visible_board.position = -visible_board.tile_set.tile_size * dimensions / 2

	# create players
	
	#var player1 = PlayerHuman.new(Globals.Team.RED)
	#var player2 = PlayerAI.new(Globals.Team.BLUE)
	#add_players([player1,player2])


## Adds players and creates Game with given players
func add_players(player_arr: Array[Player]) -> void:
	game = Game.new([player_arr[0], player_arr[1]])

	game.player_won.connect(game_won)
	game.game_tied.connect(game_tied)
	game.piece_dropped.connect(drop_piece)

	if player_arr[0] is PlayerAI:
		player_arr[0].take_turn()

func _process(_delta: float) -> void:
	if game_active and Input.is_action_just_pressed("drop_piece") and game.is_active_player_human():
		var col := visible_board.get_mouse_col()
		if col != -1:
			game.make_player_move(col)


## Animates the dropping of a piece to the specified position.
func drop_piece(team: Globals.Team, pos: Vector2i) -> void:
	# create piece
	var new_piece = piece_scene.instantiate() as Piece
	# set team for piece
	new_piece.initialize(team)
	# set piece position
	new_piece.position.x = visible_board.tile_set.tile_size.x * (pos.x+.5) + visible_board.position.x
	new_piece.position.y = -visible_board.tile_set.tile_size.y + visible_board.position.y
	# add piece to scene
	piece_holder.add_child(new_piece)
	var piece_drop_tween := get_tree().create_tween()
	var final_pos := Vector2(visible_board.tile_set.tile_size * pos) + visible_board.position
	final_pos += Vector2(visible_board.tile_set.tile_size) / 2
	var drop_time: float = (final_pos.y - new_piece.position.y) / drop_speed
	piece_drop_tween.tween_property(new_piece, "position", final_pos, drop_time)
	if game_active:
		piece_drop_tween.tween_callback(game.next_player)

func game_won(_winner: Player) -> void:
	win_label.text = "Player " + str(game.active_player_idx+1) + " won!"
	game_over_panel.show()
	game_active = false

func game_tied() -> void:
	win_label.text = "Game is a draw!"
	game_over_panel.show()
	game_active = false


func _on_ready_button_pressed() -> void:
	var p1: Player
	var p2: Player
	if p1_checkbox.button_pressed:
		p1 = PlayerAI.new(p1_team)
	else:
		p1 = PlayerHuman.new(p1_team)
	
	if p2_checkbox.button_pressed:
		p2 = PlayerAI.new(p2_team)
	else:
		p2 = PlayerHuman.new(p2_team)
	
	player_select.hide()
	game_active = true
	add_players([p1,p2])
