class_name LevelTileMap
extends TileMap

func _ready() -> void:
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())

func get_tilemap_bounds() -> Array[Vector2]:
	var rect = get_used_rect()
	var cell_size = tile_set.tile_size

	var top_left = to_global(rect.position * cell_size)
	var bottom_right = to_global((rect.position + rect.size) * cell_size)

	return [top_left, bottom_right]
