extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Input.is_action_just_pressed("sprint"):
		$World/Matter/ColorBoxes/SpecialBox.material_override.albedo_texture.noise.offset.x += 100
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
