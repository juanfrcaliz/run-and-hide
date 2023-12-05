extends TileMap

# https://github.com/godotengine/godot/issues/69743#issuecomment-1600236854

# Call the above function to check if a cell's tile_data needs to be updated:
func _use_tile_data_runtime_update(layer, cell):
	var nextLayer = layer + 1
	if nextLayer >= get_layers_count():
		return false
	
	var currentPolygon = get_cell_tile_data(layer, cell).get_navigation_polygon(0)
	if !currentPolygon:
		return false

	var nextTile =  get_cell_tile_data(nextLayer, cell)
	if !nextTile:
		return false
	
	var nextPolygon = nextTile.get_navigation_polygon(0)
	if nextPolygon:
		return currentPolygon != nextPolygon
	
	return true

# Inherit the tile data polygon from the parent layer
func _tile_data_runtime_update(layer, cell, tile_data):
	var nextLayer = layer + 1
	if nextLayer >= get_layers_count():
		return false

	var currentPolygon = tile_data.get_navigation_polygon(0)
	if !currentPolygon:
		return false

	var nextTile =  get_cell_tile_data(nextLayer, cell)
	if !nextTile:
		return false
	
	var nextPolygon = nextTile.get_navigation_polygon(0)
	if nextPolygon:
		tile_data.set_navigation_polygon(0, nextPolygon)
		return true

	tile_data.set_navigation_polygon(0, NavigationPolygon.new())
	return true
		
