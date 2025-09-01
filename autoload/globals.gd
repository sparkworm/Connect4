extends Node

enum Team {
	EMPTY,
	RED,
	BLUE,
}

const TEAM_COLORS: Dictionary[Team, Color] = {
	Team.EMPTY : Color(1,1,1),
	Team.RED : Color(1,0,0),
	Team.BLUE : Color(0.0, 0.4, 1.0),
}

## TEMPORARY
## Number of columns in board
var COL_AMNT: int = 7

const DIRECTIONS: Array[Vector2i] = [
	Vector2i(0,1), # right - left
	Vector2i(1,1), # downright - upleft
	Vector2i(1,0), # down - up
	Vector2i(-1,1), # upright - downleft
]

## TODO: make work with multiple opponents (return an array)
## Returns the team opposed to the given one
func get_opposing_team(team: Team) -> Team:
	match team:
		Team.RED:
			return Team.BLUE
		Team.BLUE:
			return Team.RED
		_:
			print("Warning, team provided is neither red nor blue")
			return Team.EMPTY
