extends Node2D
@export var fuse_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(15):
		var x = randi() % 1920
		var y = randi() % 1080
		var pos = Vector2(x , y)
		
		var fuse = fuse_scene.instantiate()
		fuse.randomize(2, pos)
		
		add_child(fuse)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
