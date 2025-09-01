class_name Piece
extends Sprite2D

var color: Globals.Team

func initialize(team: Globals.Team) -> void:
	color = team
	modulate = Globals.TEAM_COLORS[color]
