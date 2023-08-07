extends LevelBase
class_name LevelItem


#------------------------------------------------
# Формируем уровень из словаря
func init_level(data):
	if Globals.DEBAG: print ("(LevelItem)   -> init_level")	
	#if Globals.DEBAG: print (" 	",data)
	
	if (data !=null):
		for key in data:
			var item = data[key]
			#var world_item = null		
			match item["type"]:
				"wall": 	 _make_wall(item)
				"generator": _make_generator(item)
				#"grass": 	 _make_grass(item)
				#"chain":	 _make_chain(item)
				#"locker":	 _make_locker(item)
	if Globals.DEBAG: 
		test() 
	if Globals.DEBAG: print ("(LevelItem)   -> init_level --- complited")	
#------------------------------------------------		
func test():
	#test_wall()
	pass
#------------------------------------------------		
#------------------------------------------------			
#------------------------------------------------		
# Стена - полигон
func _make_wall(_data):
	if Globals.DEBAG: print ("(LevelItem)   -> _make_wall")	
	if Globals.DEBAG: print ("    ",_data)
	var wall = Globals.WallPolyItem.instantiate()
	
	var points = []
	for key in _data["points"]:
		var p = _data["points"][key]
		var x = p["x"];
		var y = p["y"];
		points.append(Vector2(x,y))
	
	wall.polygon = PackedVector2Array(points)
	wall.position = Vector2( _data["position"]["x"], _data["position"]["y"] )	
	wall.scale = scale
	add_world_item(wall)
	return wall

func test_wall():
	var data = {
		"type": "wall",
		"position":{"x":0,"y":0},
		"points":{
			"0":{"x":104,"y":302},
			"1":{"x":46,"y":508},
			"2":{"x":76,"y":746},
			"3":{"x":132,"y":894},
			"4":{"x":238,"y":1262},
			"5":{"x":362,"y":1282},
			"6":{"x":490,"y":1266},
			"7":{"x":566,"y":1202},
			"8":{"x":630,"y":1156},
			"9":{"x":678,"y":528},
			"10":{"x":606,"y":282},
			"11":{"x":900,"y":48},
			"12":{"x":900,"y":1604},
			"13":{"x":0,"y":1600},
			"14":{"x":0,"y":52},}		
	}
	_make_wall(data)
#------------------------------------------------		
#------------------------------------------------
# Генератор шариков
func _make_generator(_data):
	if Globals.DEBAG: print ("(LevelItem)   -> _make_generator")	
	#if Global.DEBAG: print (_data)	
	var generator = Globals.GeneratorItem.instantiate()
	add_world_item(generator)
	generator.position = Vector2( _data["position"]["x"], _data["position"]["y"] )
	generator.generator_clicked.connect(_on_generator_clicked)
	generator.node_level = self
	var _type =  _data["value"] if _data.has("value") else "none"
	var _level =  _data["level"] if _data.has("level") else 0
	generator.set_type(_type,_level) # TODO
	#return gener
	
func _on_generator_clicked(blocks):
	append_items(blocks)
