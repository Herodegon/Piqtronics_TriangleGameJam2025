extends Node2D
var objects: Array[Array] = []

@onready var cir_shape := CircleShape2D.new()
@export var spawnRad: float = 10
@export var tex: Texture2D
@export var piss_color: Color = Color(1.0, 1.0, 0.0, 1.0)
@export var ball_rad: float = 8
@export var piss_angle_range: float
@export var piss_magnitude_range: Vector2 = Vector2(50, 200)
var pointer: bool = true
@export var spawn_count: int = 1
@onready var attrForce: float = get_parent().attrForce

func _ready() -> void:
	cir_shape.radius = ball_rad
	cir_shape.custom_solver_bias = 0.1
	piss_angle_range = deg_to_rad(piss_angle_range)


	#await get_tree().create_timer(3).timeout
	#while Engine.get_frames_per_second() > 90:
		#create_object(global_position + Vector2.from_angle(randf()*TAU)*spawnRad*randf())
		#await get_tree().create_timer(0.001).timeout

func create_object(pos: Vector2):
	var ps := PhysicsServer2D
	var object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, cir_shape)
	ps.body_set_param(object, ps.BODY_PARAM_FRICTION, 0.1)
	ps.body_set_param(object, ps.BODY_PARAM_MASS, 0.1)
	ps.body_set_mode(object, ps.BODY_MODE_RIGID_LINEAR)
	var trans := Transform2D(0, pos)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, trans)
	

	var rs := RenderingServer
	var img := rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	rs.canvas_item_add_circle(img, Vector2.ZERO, ball_rad * 4, piss_color, 0)
	rs.canvas_item_set_z_as_relative_to_parent(img, true)
	rs.canvas_item_set_z_index(img, 1)
	# var scaled_tex_size = texSize * ball_scale
	# rs.canvas_item_add_texture_rect(
	# 	img, 
	# 	Rect2(Vector2(-scaled_tex_size / 2, -scaled_tex_size / 2), Vector2(scaled_tex_size, scaled_tex_size)),
	# 	tex,
	# 	false,
	# 	piss_color
	# )
	rs.canvas_item_set_transform(img, trans)

	objects.append([object, img])
	return [object, img]

func _physics_process(_delta):
	var index: int = 0
	for pair in objects:
		var object: RID = pair[0]
		var img: RID = pair[1]
		var trans: Transform2D = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
		trans.origin -= global_position
		if trans.origin.y > 648 - global_position.y:
			objects.remove_at(index)
			PhysicsServer2D.free_rid(object)
			RenderingServer.free_rid(img)
		else:
			RenderingServer.canvas_item_set_transform(img, trans)
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (get_global_mouse_position() - global_position).distance_to(trans.origin) < 60 * $"../UI/Icon".scale.x and not pointer:
				PhysicsServer2D.body_set_constant_force(object, ((get_global_mouse_position() - global_position) - trans.origin).normalized()*attrForce)
			else:
				PhysicsServer2D.body_set_constant_force(object, Vector2.ZERO)
		index += 1

func _exit_tree():
	for pair in objects:
		var object: RID = pair[0]
		var img: RID = pair[1]
		PhysicsServer2D.free_rid(object)
		RenderingServer.free_rid(img)


func _process(_delta: float) -> void:
	attrForce = get_parent().attrForce
	pointer = get_parent().pointer
	var piss_force_mag = randf_range(piss_magnitude_range.x, piss_magnitude_range.y)
	var piss_force_angle = randf_range(PI - piss_angle_range, PI + piss_angle_range)
	var piss_force = Vector2.from_angle(piss_force_angle) * piss_force_mag

	for i in range(spawn_count):
		var pair = create_object(global_position + Vector2(randf()-0.5, randf()-0.5).normalized()*spawnRad*randf())
		var object = pair[0]
		PhysicsServer2D.body_apply_impulse(object, piss_force)

