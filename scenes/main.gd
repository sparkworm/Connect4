extends Node

@export var level: PackedScene



@onready var pause_menu_layer: CanvasLayer = $PauseMenuLayer
@onready var game_layer: CanvasLayer = $GameLayer

func _ready() -> void:
	get_tree().paused = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func load_scene(scene: PackedScene) -> void:
	for child in game_layer.get_children():
		child.queue_free()
	var new_scene := scene.instantiate()
	game_layer.add_child(new_scene)

## Start game if start is pressed
func _on_button_play_pressed() -> void:
	toggle_pause()
	load_scene(level)

## Quit game if quit is pressed
func _on_button_quit_pressed() -> void:
	get_tree().quit()

func toggle_pause() -> void:
	pause_menu_layer.visible = not pause_menu_layer.visible
	get_tree().paused = not get_tree().paused
