extends Area2D
class_name LevelBase 

#------------------------------------------------
# Реализация игровой логики
signal make_step
signal score_changed

#------------------------------------------------
var _blocks_to_check = null
var _items = null 
var _world = null
#------------------------------------------------
func _ready():
	if Globals.DEBAG: print("(LevelBase) -> _ready")
	self.remove_from_group("balls")
#------------------------------------------------
#------------------------------------------------
func set_item_node(node):
	_items = node
	
func add_item_node(item:Node):	
	_items.add_child(item)
#------------------------------------------------
func set_world_node(node):
	_world = node	
#------------------------------------------------	
# Добавление элементов на поле
func add_world_item(item:Node):	
	#for item in items:
	_world.add_child(item)
	
#------------------------------------------------
#------------------------------------------------
# Перезапуск игры
func reset_level():
	print ("(Level_base) - reset level")
	if (_world != null):
		for n in _world.get_children():
			_world.remove_child(n)
			n.queue_free()
	if (_items !=null):		
		for n in _items.get_children():
			_items.remove_child(n)
			n.queue_free()
	pass
#------------------------------------------------
# Добавление элементов на поле
func append_items(items:Array):
	for item in items:
		item.sleeping = false
		match (item.get_type()):
			"ball":	item.block_clicked.connect(_on_block_clicked)
			"egg" : item.egg_catched.connect(_on_egg_catched)
			"stone":item.item_destroyed.connect(_on_stone_destroyed)
			"ice": 	item.item_destroyed.connect(_on_stone_destroyed)
		add_item_node(item)
		
#------------------------------------------------
#------------------------------------------------
# Игровая логика при клике
func _on_block_clicked(block):
	if Globals.DEBAG: print ("(Level_base) -> _on_block_clicked")
	#print (block)
	check_blocks(block)
	
	var cnt_blocks = check_score()
	if Globals.DEBAG: print ("score: ",cnt_blocks)
	if cnt_blocks >1:
		var posi = block.position
		change_score(cnt_blocks,block) # обновляем счет
		_on_make_step()
		delete_bricks() # удаляем
		if cnt_blocks>3: # добавляем бустер
			add_buster(posi,1)
		else: pass
		
	clear_marks() #сбрасываем метки
#------------------------------------------------
#------------------------------------------------
# Логика проверки
#------------------------------------------------
# Проверяем блоки	
func check_blocks(block):
	if Globals.DEBAG: print ("(Level_base) -> check_blocks")
	_blocks_to_check = Array()
	_blocks_to_check.append(block)
	block.delete = true
	var color = block.get_color()
	
	# Прверяем всех соседей
	while _blocks_to_check.size()>0 :
		var item = _blocks_to_check[0]
		find_neighbors(item,color)
		_blocks_to_check.remove_at(0)
	
# Проверяем соседей
func find_neighbors(block,color):	
	var collisions = block.get_collision()
	#print (collisions)
	for item in collisions:
		check_neighbor_color(item, color)
			
#Проверяем цвет ячейки
func check_neighbor_color(item, color):
	if (item.has_method("get_type")):
		var _type =item.get_type() 
		match (_type):
			"ball": 
				if (item.get_color()==color) and (item.delete == false):
					#if Global.DEBAG: print ("Подходит", item ) 
					item.delete = true
					_blocks_to_check.append(item)
			"ice" :
				item.delete = true
				
func _is_item_type(item,type)->bool:
	if (item.has_method("get_type")):
		if item.get_type()==type:
			return true
	return false		

func check_score():
	# считаем количество блоков
	var count =0
	var gr = get_tree().get_nodes_in_group("balls")
	for item in gr :
		if _is_item_type(item,"ball"):
			if (item !=null) and (item.delete==true) : 
				count += 1
	""""
	var item_cnt = _items.get_child_count()
	
	for i in range(0,item_cnt) :
		var item = _items.get_child(i)
		if _is_item_type(item,"ball"):
			if (item !=null) and (item.delete==true) : 
				count += 1
	
	"""
	return count
#удаляем отмеченные элементы
func delete_bricks():
	var item_cnt = _items.get_child_count()
	for i in range(0,item_cnt) :
		var item = _items.get_child(i)
		if (item.has_method("get_type")):
			if item.get_type() in ["ball","stone","ice"]:
				if (item !=null) and (item.delete==true) : 
					item.destroy() # Определяет, уменьшаем уровень или удаляем
				
# Сброс отметок на удаление
func clear_marks():
	var item_cnt = _items.get_child_count()
	for i in range(0,item_cnt) :
		var item = _items.get_child(i)
		if _is_item_type(item,"ball"):
			item.delete = false
			item.sleeping = false
	_blocks_to_check = null
#------------------------------------------------
# Добавление бустера
#------------------------------------------------
func add_buster(_position,level):
	var buster = Globals.BusterItem.instantiate();
	buster.position =_position
	buster.buster_clicked.connect(_on_buster_clicked)
	buster.make_step.connect(_on_make_step)
	buster.set_level(level)
	add_item_node(buster)
	if Globals.DEBAG: print ("buster adds: ",_items.get_child_count())
	pass	
	
func _on_buster_clicked(buster): 
	if Globals.DEBAG: print("(level_base) -> _on_buster1_clicked")
	var cnt = 0
	# Для подсчета очков по цветам
	var _scores = {} 
	for i in Globals.Ball_ColorMap:
		_scores[i] = 0
	# активируем только 1 бустер	
	var buster_active =false
	# print (_items.get_child_count())
	
	# Просматриваем все элементы, кто попадает в зону бустера
	while  cnt <_items.get_child_count() :
		var item = _items.get_child(cnt)
		if (item.has_method("get_type")):
			if buster.check_ball_in_rect(item):
				var _type = item.get_type()
				match(_type):
					"ball": # Шарики
							var _color = item.get_color()
							_scores[_color]+=1
							item.set_color(0) #= true
							item.delete = true		
					"buster": #Другой бустер
						if not buster_active: # Если новый бустер не активирован
							item.activate = true
							buster_active = true
					"stone": # Камешки
							item.delete = true			
					"ice": # Льдинки
							item.delete = true									
		cnt+=1			
	for i in _scores:
		var block = Globals.BallItem.instantiate()
		block.set_color(i)
		emit_signal("score_changed",_scores[i],block)
		change_score_for_colored_go(_scores[i],block)
	
	#TODO2	
	#if buster.activate == false:
	#	_on_make_step()

	delete_bricks()	
	buster.queue_free()
	clear_marks()
#func _check_buster_balls	
#------------------------------------------------
# Засчитать ход
func _on_make_step():
	if Globals.DEBAG: print("(level_base) -> _on_make_step")
	if Globals.DEBAG: print ("	EMIT signal 'make_step'")
	emit_signal("make_step")
#------------------------------------------------
# Работаем со счетом
#------------------------------------------------	
# Добавление очков
func change_score(score,block):
	if Globals.DEBAG: print("(level_base) -> change_score")
	if Globals.DEBAG: print ("	EMIT signal 'score_changed'")
	emit_signal("score_changed",score,block)
	change_score_for_colored_go(score,block)

func change_score_for_colored_go(score,block):
	if block.get_type()=="ball":
		var _color =  block.get_color ()
		var gr = get_tree().get_nodes_in_group("colored")
		for item in gr:
			if item.has_method("get_color"):
				if _color == item.get_color():
					if item.has_method("change_score"):
						item.change_score(score)	
#------------------------------------------------
# Яйцо достигло земли
func _on_egg_catched(block):
	if Globals.DEBAG: print("(level_base) -> _on_egg_catched")
	if Globals.DEBAG: print ("	EMIT signal 'score_changed'")
	emit_signal("score_changed",1,block)

#------------------------------------------------
# Камень уничтожен
func _on_stone_destroyed(block):
	if Globals.DEBAG: print("(level_base) -> _on_stone_destroyed")
	if Globals.DEBAG: print ("	EMIT signal '_on_stone_destroyed'")
	emit_signal("score_changed",1,block)
