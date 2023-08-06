extends Polygon2D

const node_type = "wall"
#const _texture = preload("res://interface/img/wall.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	update_polygon()
	pass # Replace with function body.

func update_polygon():
	var collision_shape = CollisionPolygon2D.new()
	self.uv = polygon
	# Polygon2D.polygon contains a list of all vertices on the drawn polygon
	# so just copy those points over to the new collision shape
	collision_shape.polygon = polygon
	$StaticBody2D.add_child(collision_shape)	
