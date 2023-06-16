extends Node3D

class_name Chunk
var mesh_instance
var noise
var x
var z
var chunk_size
var should_remove = true

func _init(noise, x, z, chunk_size):
	self.noise = noise
	self.x = x
	self.z = z
	self.chunk_size = chunk_size
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_chunk()
	generate_water()

func generate_chunk():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.subdivide_depth = chunk_size * 0.5
	plane_mesh.subdivide_width = chunk_size * 0.5
	
	
	#material 
	var grass_material = StandardMaterial3D.new()
	grass_material.albedo_color = Color.DARK_GREEN
	plane_mesh.material = grass_material
	
	
	
	var surface_tool = SurfaceTool.new()
	var data_tool = MeshDataTool.new()
	surface_tool.create_from(plane_mesh, 0)
	var array_plane = surface_tool.commit()
	var error = data_tool.create_from_surface(array_plane, 0)

	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		
		
		vertex.y = noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 40 
		data_tool.set_vertex(i, vertex)
		
	#remove_surface() was changed into clear_surfaces()
	array_plane.clear_surfaces()
		
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	surface_tool.set_smooth_group(1)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	
	
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.create_trimesh_collision()
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	mesh_instance.name = "Terrain"
	add_child(mesh_instance)


func generate_water():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(Color.DARK_BLUE, 40.0)
	plane_mesh.material = material
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = plane_mesh
	mesh_instance.name = "Water"
	
	add_child(mesh_instance)
	pass
