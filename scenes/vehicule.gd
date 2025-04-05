extends CharacterBody3D

const SPEED = 5.0

func _ready() -> void:
	%Area3D.body_entered.connect(func(body):
		%AIController.reward = 0
		%AIController.reset()
	)

func _physics_process(delta: float) -> void:
	velocity = global_basis.z * (%AIController.acceleration-.5)*SPEED
	rotate_y(%AIController.rotationn / 150)
	move_and_slide()
