## A class for showing the player the current state of the game
class_name VisibleBoard
extends TileMapLayer

func create_board(dimensions: Vector2i) -> void:
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			set_cell(Vector2i(x,y), 0, Vector2i(1,1))

## Returns which column the mouse resides over.  Returns -1 if it is over no column
func get_mouse_col() -> int:
	var mouse_pos := get_local_mouse_position()
	var col_pos: int = mouse_pos.x / tile_set.tile_size.x
	if col_pos >= Globals.COL_AMNT or mouse_pos.x < 0:
		col_pos = -1
	print(col_pos)
	return col_pos
