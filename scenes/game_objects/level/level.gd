extends LevelBase
class_name Level

#------------------------------------------------
# Формируем уровень из словаря
func init_level(data):
	if Globals.DEBAG: print ("(Level)   -> init_level")	
	if (data !=null):
		for info in data:
			var item = null
			match info["type"]:
				"generator": 
					item = Globals.GeneratorItem.instantiate()
					item.generator_clicked.connect(append_items)
				"egg":	
					item = Globals.EggItem.instantiate()
					item.egg_catched.connect(_on_egg_catched)
				"ice": 
					item = Globals.IceItem.instantiate()
					item.item_destroyed.connect(_on_ice_destroyed)
				"stone": 
					item = Globals.StoneItem.instantiate()
					item.item_destroyed.connect(_on_stone_destroyed)
			if (item !=null):		
				item.deserialize(info)
				_world.add_child(item)		

#------------------------------------------------	
#------------------------------------------------

