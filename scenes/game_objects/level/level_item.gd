extends LevelBase
class_name LevelItem


# Формируем уровень
func init_level(data):
	if Globals.DEBAG: print ("(LevelItem)   -> init_level")	
	if Globals.DEBAG: print (" 	",data)
	
	if (data !=null):
		for key in data:
			var item = data[key]
			#var world_item = null		
			match item["type"]:
				"wall": 	 _make_wall(item)
	
	#test_wall()


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

