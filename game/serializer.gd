extends Node
#------------------------------------------------
## Экспорт уровня в json
#------------------------------------------------
func save_level(number:int,map:TileMap,rules: Dictionary,WorldNode:Node2D):
	var level = {
		"rules":rules, 						# Правила победы
		"tilemap":_serialize_map(map),		# Карта уровня
		"world":_serialize_world(WorldNode)	# Игровые элементы
	}
	# Сохранение
	_save_to_json("lvl_%s.json"% [number],level)
#-----------------------------------------------
# Загрузка уровня
func load_level(number:int):
	
	var level = _load_from_json("lvl_%s.json"% [number])
	"""
	var level = {
		"rules"  :json["rules"],
		"tilemap":json["tilemap"],
		"world"  :json["world"],
	}
	"""
	return level
#------------------------------------------------
# JSON
#------------------------------------------------
# Сохранение в json
func _save_to_json(filename,data):
	var fullname = "%s/%s"%[Globals.LEVELS_PATH_LOCAL,filename]
	var json = JSON.stringify(data)
	var file = FileAccess.open(fullname,FileAccess.WRITE)
	file.store_string(json)

# Загрузка из json
func _load_from_json(filename):
	var fullname = "%s/%s"%[Globals.LEVELS_PATH_LOCAL,filename]
	var file = FileAccess.open(fullname,FileAccess.READ)
	var txt = file.get_as_text()
	var json = JSON.parse_string(txt)
	return json	
	
#-------------------------------------------	
# Сериализуем Тайловую карту	
func _serialize_map(map:TileMap):
	var tilemap = []
	var amountofblocks = 0
	for chunk in map.get_used_cells(0):
		amountofblocks = amountofblocks + 1
		var atlas = map.get_cell_atlas_coords(0,chunk)
		#print (chunk,'  ',atlas)
		tilemap.append({
			"x": chunk.x,# position
			"y": chunk.y,
			"aid":map.get_cell_source_id(0,chunk),
			"ax": atlas.x, # atlas coord
			"ay": atlas.y
			})   
	return {
			"count": amountofblocks,
			"tiles":tilemap
			}
func deserialize_map(map:TileMap,data:Dictionary):
	var layer = 0
	for item in data["tiles"]:
		map.set_cell(layer,Vector2(item["x"],item["y"]),item["aid"],Vector2i(item["ax"],item["ay"]))  
	pass
#-------------------------------------------	
# Преобразование игровых элементов			
func _serialize_world(World:Node2D):
	var dict=[]
	for item in World.get_children():
		if item.has_method("serialize"):
			dict.append(item.serialize())
	return dict
#------------------------------------------------
#------------------------------------------------

#------------------------------------------------

