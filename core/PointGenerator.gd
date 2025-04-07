extends Node
class_name PointGenerator
@export var point_count := 5000

var points_progress : Dictionary[PathFollow3D, float]

func _ready() -> void:
	Game.point_generator = self
	for i in point_count :
		var new_point = PathFollow3D.new()
		%Path3D.add_child.call_deferred(new_point)
		new_point.ready.connect(func():
			new_point.progress_ratio = float(i)/point_count
		)
		points_progress[new_point] = float(i)/point_count

func get_closest_distance(pos:Vector3) -> float:
	var closest_point = points_progress.keys()[0]
	for point in points_progress :
		if (point.global_position - pos).length() < (closest_point.global_position - pos).length():
			closest_point = point
	return (closest_point.global_position-pos).length()

func get_closest_index(pos:Vector3) -> int:
	var closest_point = points_progress.keys()[0]
	for point in points_progress :
		if (point.global_position - pos).length() < (closest_point.global_position - pos).length():
			closest_point = point
	return points_progress.keys().find(closest_point)

func get_position(index: int)-> Vector3 :
	return points_progress.keys()[index].global_position
