class_name PressurizedWaterMesh
extends Node3D

static var water_mesh := preload("res://assets/models/equipments/Water/water.tscn")
var pressurized_water: PressurizedWater

func initialize(pressurized_water_instance: PressurizedWater):
	pressurized_water = pressurized_water_instance


func draw_cube(start, end, thickness, height, index) -> void:
	var mesh: MeshInstance3D = water_mesh.instantiate()
	var custom_scale = Vector3(thickness, height, (end - start).length())
	mesh.scale = custom_scale
	var mid_point = (start + end) / 2
	mesh.transform.origin = mid_point
	var direction = (end - start).normalized()
	var right = direction.cross(Vector3.UP).normalized()
	var new_up = right.cross(direction).normalized()
	if new_up != Vector3.ZERO:
		mesh.look_at_from_position(mesh.transform.origin, mesh.transform.origin + direction, new_up)
	if pressurized_water.mesh_container.get_child_count() >= index + 1:
		var child = pressurized_water.mesh_container.get_child(index)
		pressurized_water.mesh_container.add_child(mesh)
		pressurized_water.mesh_container.move_child(mesh, index)
		child.queue_free()
	else:
		pressurized_water.mesh_container.add_child(mesh)

func stop_steam_emitting() -> void:
	pressurized_water.steam_particle.emitting = false

func kill_other_mesh(index) -> void:
	var child_count = pressurized_water.mesh_container.get_child_count()
	if child_count > index + 1:
		for i in range(index + 1, child_count):
			var child = pressurized_water.mesh_container.get_child(i)
			child.queue_free()
