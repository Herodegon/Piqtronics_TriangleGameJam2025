extends Node2D
@export var slot_scene: PackedScene
@export var fusebox_pos: Vector2
@export var toolbox_pos: Vector2
@export var fuse_scene: PackedScene
# color, type
var broken_fuses = []

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
			var slot = slot_scene.instantiate()
			slot.spawn(0, cur_spawn_pos)
			slot.add_to_group("box_slots")
			add_child(slot)
			
			var fuse = fuse_scene.instantiate()
			
			fuse.randomize(is_fuse_good[fuse_num], cur_spawn_pos)
			if not fuse.good:
				broken_fuses.append([fuse.cover_color, fuse.type])
			
			fuse.add_to_group("box_fuses")
			add_child(fuse)
			
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
			var slot = slot_scene.instantiate()
			slot.spawn(1, cur_spawn_pos)
			slot.add_to_group("toolbox_slots")
			add_child(slot)
			
			if is_fuse_real[fuse_num]:
				
				var fuse = fuse_scene.instantiate()
				fuse.randomize(1, cur_spawn_pos)
				if is_fuse_fixer[fuse_num]:
					var fuse_index = randi() % broken_fuses.size()
					var fuse_params = broken_fuses.pop_at(fuse_index)
					fuse.set_color(fuse_params[0])
					fuse.set_type(fuse_params[1])
					fuse.set_state(1)					
				
				
				fuse.add_to_group("toolbox_fuses")
				add_child(fuse)
			
			fuse_num += 1
			
			cur_spawn_pos.y += 90
		
		cur_spawn_pos.x += 90
		cur_spawn_pos.y = start_pos.y
	print(broken_fuses)

func _ready():
	spawn_box_fuses(fusebox_pos, 10, 10,10)
	spawn_toolbox_fuses(toolbox_pos, 15, 10, 5, 5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
