extends Control
signal player_win
@export var fuse_assembly_scene: PackedScene
@export var fusebox_pos: Vector2
@export var toolbox_pos: Vector2
var broken_count
# color, type
var broken_fuses = []
var box_assemblies = []
var toolbox_assemblies = []
# Called when the node enters the scene tree for the first time.


func spawn_box_fuses(start_pos: Vector2, num_broken: int, x_spawn: int, y_spawn: int):
	var is_fuse_good = []
	var broken_fuse_indices = []
	
	for i in range(x_spawn * y_spawn):
		is_fuse_good.append(1)
	
	var broken_index = randi() % (x_spawn * y_spawn)
	for i in range(num_broken):
		broken_fuse_indices.append(broken_index)
		is_fuse_good[broken_index] = 0
		print("broken fuse %d" % broken_index)
		
		while broken_index in broken_fuse_indices:
			broken_index = randi() % (x_spawn * y_spawn)
			#print("Chosen index %d" % broken_index)
	
	var cur_spawn_pos = start_pos
	var fuse_num = 0
	for x in range(x_spawn):
		for y in range(y_spawn):
			var assembly: Control = fuse_assembly_scene.instantiate()
			assembly.generate_slot(true)
			assembly.position = cur_spawn_pos
			var fuse: Control = assembly.generate_random_fuse(is_fuse_good[fuse_num])
			if not fuse.good:
				broken_fuses.append([fuse.cover_color, fuse.type])
			assembly.add_to_group("box_assemblies")
			box_assemblies.append(assembly)
			add_child(assembly)		
			
			fuse_num += 1			
			cur_spawn_pos.y += 90
		
		cur_spawn_pos.x += 90
		cur_spawn_pos.y = start_pos.y
	print(broken_fuses)

func spawn_toolbox_fuses(start_pos: Vector2, num_fuses: int, num_broken: int, x_spawn: int, y_spawn: int):
	if num_fuses < num_broken:
		print("ERROR NOT ENOUGH FUSES TO FIX BOX")
		return
	
	var is_fuse_real = []
	var is_fuse_fixer = []
	var real_fuse_indices = []
	var fixer_fuse_indices = []
	
	for i in range(x_spawn * y_spawn):
		is_fuse_real.append(0)
		is_fuse_fixer.append(0)
	
	var real_index = randi() % (x_spawn * y_spawn)
	for i in range(num_fuses):
		real_fuse_indices.append(real_index)
		is_fuse_real[real_index] = 1
		print("Real fuse %d" % real_index)
		
		while real_index in real_fuse_indices:
			real_index = randi() % (x_spawn * y_spawn)
			#print("Chosen index %d" % broken_index)
			
	var fixer_index = real_fuse_indices[randi() % num_fuses]
	for i in range(num_broken):
		fixer_fuse_indices.append(fixer_index)
		is_fuse_fixer[fixer_index] = 1
		print("Fixer Fuse %d" % fixer_index)
		while fixer_index in fixer_fuse_indices:
			fixer_index = real_fuse_indices[randi() % num_fuses]
	
	var cur_spawn_pos = start_pos
	var fuse_num = 0
	for x in range(x_spawn):
		for y in range(y_spawn):
			var assembly: Control = fuse_assembly_scene.instantiate()
			assembly.generate_slot(0)
			assembly.position = cur_spawn_pos
			if is_fuse_real[fuse_num]:
				if is_fuse_fixer[fuse_num]:
					var fuse_index = randi() % broken_fuses.size()
					var fuse_params = broken_fuses.pop_at(fuse_index)
					assembly.generate_fuse(fuse_params[0], fuse_params[1], 1)
				else:
					assembly.generate_random_fuse(1)
				
			assembly.add_to_group("toolbox_assemblies")
			toolbox_assemblies.append(assembly)
			add_child(assembly)
					
			fuse_num += 1
			
			cur_spawn_pos.y += 90
		
		cur_spawn_pos.x += 90
		cur_spawn_pos.y = start_pos.y
	print(broken_fuses)

func win():
	$Problems.text = "All fuses fixed!"
	$Problems.visible = true
	player_win.emit()

func update_broken_count():
	broken_count = 0
	for assembly in box_assemblies:
		if not assembly.has_fuse or not assembly.fuse.good:
			broken_count += 1
	$Problems.text = "Broken Fuses: %d" % broken_count
	$Problems.visible = true

	if broken_count == 0:
		print("All fuses fixed!")
		win()

func _notification(what: int):
	if what != NOTIFICATION_DRAG_END:
		return
	var viewport = get_viewport()
	if not viewport.gui_is_drag_successful():
		return
	update_broken_count()
		
		# var box_assembly = drag_data.get_parent()
		# var fuse_data = box_assembly.get_fuse_data()
		# var fuse_color = fuse_data["color"]
		# var fuse_type = fuse_data["type"]
		# var fuse_good = fuse_data["state"]
		# var fuse_break_pos = fuse_data["break_pos"]
		
		# for assembly in get_tree().get_nodes_in_group("toolbox_assemblies"):
		# 	if assembly.can_drop_data(fuse_color, fuse_type, fuse_good):
		# 		assembly.drop_data(fuse_color, fuse_type, fuse_good, fuse_break_pos)
		# 		break
		# box_assembly.remove_fuse()
		# box_assembly.queue_free()
		# if not get_tree().get_nodes_in_group("box_assemblies"):
		# 	print("All fuses fixed!")
	

func reset():
	for assembly in box_assemblies:
		assembly.reset_fuse()
	for assembly in toolbox_assemblies:
		assembly.reset_fuse()
	update_broken_count()

func _ready():
	spawn_box_fuses(fusebox_pos, 10, 6, 6)
	toolbox_pos = Vector2(fusebox_pos.x + 650, fusebox_pos.y)
	spawn_toolbox_fuses(toolbox_pos, 15, 10, 5, 5)
	update_broken_count()

func _process(_delta):
	if Input.is_action_pressed("reset_minigame"):
		reset()
