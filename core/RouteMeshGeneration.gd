@tool
extends Node


@export var iteration_count := 100
@export var wall_height := 1.
@export var path_width := 5.
@export_tool_button("Generate") var _g = generate

func generate()-> void :
	if not Engine.is_editor_hint() : return
	var road_mesh := ArrayMesh.new()
	var wall_mesh := ArrayMesh.new()
	var road_meshi : MeshInstance3D = %RoadMeshInstance3D
	for c in road_meshi.get_children() : c.queue_free()
	var wall_meshi : MeshInstance3D = %WallMeshInstance3D
	for c in wall_meshi.get_children() : c.queue_free()
	
	var road_verts := PackedVector3Array()
	var road_norms := PackedVector3Array()
	var road_uvs := PackedVector2Array()
	
	var wall_verts := PackedVector3Array()
	var wall_norms := PackedVector3Array()
	var wall_uvs := PackedVector2Array()
	
	var positions1 : Array[Vector3]
	var positions2 : Array[Vector3]
	
	for i in %Path3D.curve.point_count :
		%Path3D.curve.set_point_position(i, %Path3D.curve.get_point_position(i)*Vector3(1,0,1))

	
	for i in iteration_count+1 :
		%PathFollow3D.progress_ratio = float(i)/iteration_count
		var direction : Vector3 = (%PathFollow3D.global_basis.x*Vector3(1,0,1)).normalized()
		var delta : Vector3 = direction * path_width * .5
		var ppos : Vector3 = %PathFollow3D.global_position*Vector3(1,0,1)
		positions1.push_back(ppos-delta)
		positions2.push_back(ppos+delta)
		if i==0 : continue
		
		var h : Array[Vector3] = [positions1[i], positions2[i], positions1[i-1], positions2[i-1]]
		var hu : Array[Vector2] = [Vector2(2/64., 0), Vector2(62/64., 0), Vector2(2/64., 1), Vector2(62/64., 1)]
		
		road_verts.append_array([h[0], h[1], h[2], h[2], h[1], h[3]])
		road_uvs.append_array([hu[0], hu[1], hu[2], hu[2], hu[1], hu[3]])
		for j in 6 : road_norms.append(Vector3.UP)
		
		wall_verts.append_array([h[3], h[1], h[3]+Vector3.UP*wall_height, h[3]+Vector3.UP*wall_height, h[1], h[1]+Vector3.UP*wall_height])
		for j in 6 : wall_uvs.push_back(Vector2.ONE*.5/64.)
		for j in 6 : wall_norms.append(-direction)
		
		wall_verts.append_array([h[0], h[2], h[0]+Vector3.UP*wall_height, h[0]+Vector3.UP*wall_height, h[2], h[2]+Vector3.UP*wall_height])
		for j in 6 : wall_uvs.push_back(Vector2.ONE*63.5/64.)
		for j in 6 : wall_norms.append(direction)
		#
		#if i == 0 :
			#wall_verts.append_array([h[0], h[1], h[0]+Vector3.UP*wall_height, h[0]+Vector3.UP*wall_height, h[1], h[1]+Vector3.UP*wall_height])
			#for j in 6 : wall_uvs.push_back(Vector2.ONE*.5/64.)
			#for j in 6 : wall_norms.append(-direction)
		#if i == iteration_count :
			#wall_verts.append_array([h[3+4], h[1+4], h[2+4]+Vector3.UP*wall_height, h[2+4]+Vector3.UP*wall_height, h[1+4], h[3+4]+Vector3.UP*wall_height])
			#for j in 6 : wall_uvs.push_back(Vector2.ONE*.5/64.)
			#for j in 6 : wall_norms.append(-direction)
	#
	var road_arrays = []
	road_arrays.resize(Mesh.ARRAY_MAX)
	road_arrays[Mesh.ARRAY_VERTEX] = road_verts
	road_arrays[Mesh.ARRAY_NORMAL] = road_norms
	road_arrays[Mesh.ARRAY_TEX_UV] = road_uvs
	road_mesh.add_surface_from_arrays(Mesh.PrimitiveType.PRIMITIVE_TRIANGLES, road_arrays)
	road_meshi.mesh = road_mesh
	road_meshi.create_trimesh_collision()
	
	var wall_arrays = []
	wall_arrays.resize(Mesh.ARRAY_MAX)
	wall_arrays[Mesh.ARRAY_VERTEX] = wall_verts
	wall_arrays[Mesh.ARRAY_NORMAL] = wall_norms
	wall_arrays[Mesh.ARRAY_TEX_UV] = wall_uvs
	wall_mesh.add_surface_from_arrays(Mesh.PrimitiveType.PRIMITIVE_TRIANGLES, wall_arrays)
	wall_meshi.mesh = wall_mesh
	wall_meshi.create_trimesh_collision()
	
	%PathFollow3D.progress_ratio = 0.

var car_packed_scene : PackedScene = preload("res://scenes/Car.tscn")
func _ready() -> void:
	if Engine.is_editor_hint() : return
	%PathFollow3D.progress_ratio = 0

	var car : Node3D = car_packed_scene.instantiate()
	add_child(car)
	car.global_position = %PathFollow3D.global_position + Vector3.UP*.1
