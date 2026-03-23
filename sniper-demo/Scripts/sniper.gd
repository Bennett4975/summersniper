extends Node3D

enum {
	IDLE,
	ALERT,
	GONE,
}

var state = IDLE

@onready var raycast = $RayCast3D
@onready var mesh = $MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		IDLE:
		
		ALERT:
			
		STUNNED:
	pass
