class_name Player
extends Node

## Signal indicating that the player has made a move.  Notably unused with PlayerHuman
signal move_made(col: int)

var team: Globals.Team

func _init(assigned_team: Globals.Team) -> void:
	team = assigned_team
