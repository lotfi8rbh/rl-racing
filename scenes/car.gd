extends AIController3D

var acceleration : float
var rotationn : float
#
#var r_dist : float :
	#get: return (%R.get_collision_point()-%R.global_position).length() if %R.is_colliding() else 999
#var l_dist : float :
	#get: return (%L.get_collision_point()-%L.global_position).length() if %L.is_colliding() else 999

func get_obs() -> Dictionary:
	var obs : Array = []
	for i in 24 :
		var ray : RayCast3D = get_node("../Raycasts/R"+str(i+1))
		ray.force_raycast_update()
		obs.push_back(((ray.get_collision_point()-ray.global_position)/ray.target_position.length()).length() if ray.is_colliding() else 99999 )
	return {"obs": obs}

func get_front_point()-> Vector3 :
	return global_position + global_basis.z*2

@onready var last_closest: int = Game.point_generator.get_closest_index(get_front_point())
@onready var last_front_point_closest: int = Game.point_generator.get_closest_index(get_front_point())

func get_reward() -> float :
	if Game.point_generator == null: return 0
	
	var closest_dist = Game.point_generator.get_closest_distance(global_position)
	var closest = Game.point_generator.get_closest_index(global_position)
	var front_point_closest = Game.point_generator.get_closest_index(get_front_point())
	if closest_dist < .1 :
		reset()
		return -1
	
	
	var reward: float = (closest-last_closest)*2 + (front_point_closest-last_front_point_closest)
	
	last_closest = closest
	last_front_point_closest = front_point_closest
	
	return reward*.05 + closest

func get_action_space() -> Dictionary:
	return {
		"acceleration": {"size": 1, "action_type": "continuous"},
		"steering": {"size": 1, "action_type": "continuous"},
	}
	
func set_action(action) -> void:
	acceleration = action["acceleration"][0]
	rotationn = action ["steering"][0]
