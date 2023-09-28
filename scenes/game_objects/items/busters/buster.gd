extends RigidBody2D
class_name BusterItem 

signal buster_clicked (block)
signal make_step(block)

const node_type = "buster"

#------------------------------------------------
# Зона захвата бустера
const w = 1200
const h = 100
#------------------------------------------------
var _level =0
var delete=false
var activate = false
#------------------------------------------------
func _ready():
	add_to_group(Globals.GO_GROUPS_NAMES[Globals.GO_TYPES.BUSTER]);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if activate:
		#if Global.DEBAG:
		print ("-- bum --")	
		destroy()
	pass
#------------------------------------------------
# Нажатие на бустер
func _on_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Globals.DEBAG: print("buster clicked, lvl:",_level)
		destroy()
		emit_signal("make_step") 	
	pass # Replace with function body.
		
		
#------------------------------------------------
func destroy():
	if Globals.DEBAG: print("buster clicked, lvl:",_level)
	emit_signal("buster_clicked",self) 	
		
#------------------------------------------------
# Получение типа
func get_type()-> String:
	return node_type
#------------------------------------------------	
# Уровень бустера
func set_level(value:int):
	_level=value
	update_texture()

func level_up():
	_level= clamp(_level+1, 1, 3)
	
	update_texture()
#------------------------------------------------
	
# Работа с текстурой
func update_texture():
	$Sprite.texture = Globals.BUSTER_BIRDS_TEXTURES[_level]
	#$shape.scale = 1
#------------------------------------------------
#------------------------------------------------
# Коллизии
#------------------------------------------------
# Проверка что элемент входит в зону поражения
func check_ball_in_rect(item:Node):
	var _center = global_position
	#var _point = item.global_position
	match _level: 
		1: # Для бустера 1 уровня - линия
			var _left = Vector2(_center.x - float(w)/2,_center.y - float(h)/2)
			var _rect = Rect2(_left,Vector2(w,h))
			return Globals.check_item_in_rect(item,_rect)
			#if  (_point.x >_center.x-w) and (_point.x <_center.x+w) and (_point.y >_center.y-h) and (_point.y <_center.y+h) :
				#return true
		2: # Для бустера 2 уровня	- крест		
			var _left = Vector2(_center.x - float(w)/2,_center.y - float(h)/2)
			var _rect1 = Rect2(_left,Vector2(w,h))
			_left = Vector2(_center.x - float(h)/2,_center.y - float(w)/2)
			var _rect2 = Rect2(_left,Vector2(h,w))
			return Globals.check_item_in_rect(item,_rect1) or Globals.check_item_in_rect(item,_rect2) 
			#if  ((_point.x >_center.x-w) and (_point.x <_center.x+w) and (_point.y >_center.y-h) and (_point.y <_center.y+h)) or  ((_point.x >_center.x-h) and (_point.x <_center.x+h) and (_point.y >_center.y-w) and (_point.y <_center.y+w)):
			#	return true
		3: # Для бустера 3 уровня - квадрат
			var size = 800
			var _left = Vector2(_center.x - float(size)/2,_center.y - float(size)/2)
			var _rect = Rect2(_left,Vector2(size,size))
			return Globals.check_item_in_rect(item,_rect)
			#if  (_point.x >_center.x-w) and (_point.x <_center.x+w) and (_point.y >_center.y-w) and (_point.y <_center.y+w) :
			#	return true		
	return false		
#------------------------------------------------
# Столкновение с другим бустером

func _on_buster_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.has_method("get_type"):
		if body.get_type()==node_type: # Другой бустер
			if body._level == self._level and not self._level ==3 : # Одинаковые и не максимальные
				level_up()
				body.queue_free()
				if Globals.DEBAG: print("enter",body)
#------------------------------------------------
# Мышь попала в позиции бустера
#------------------------------------------------
func check_inside(pos)->bool:
	var size = 36
	if pos.x >position.x - size and pos.x<position.x+size and pos.y >position.y - size and pos.y<position.y+size:
		return true
	return false
#------------------------------------------------		

func serialize():
	return {
		"type": node_type,
		"pos" : {
			"x": global_position.x,
			"y": global_position.y
			},
		"lvl": _level	
	}

func deserialize (data:Dictionary):
	if (data["type"])!= node_type:
		return false
	position = Vector2(data["pos"]["x"],data["pos"]["y"])
	_level =data["lvl"] 
	return true



