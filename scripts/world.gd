extends Node3D
const chunk_size = 64
const chunk_amount = 16

var noise
var chunks = {}
var chunk
var unready_chunks = {}
var thread : Thread

func _ready():
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi()
	thread = Thread.new()
	pass # Replace with function body.



func add_chunk(x, z):
	var key = str(x) + "," + str(z)
	if chunks.has(key) or unready_chunks.has(key):
		return
		
	#is_active() was changed into is_started()
	if not thread.is_started():
		
		#Callable.bind is introduced to 4.0
		thread.start(load_chunk.bind([thread, x, z]))
		unready_chunks[key] = 1



func load_chunk(arr):
	var thread = arr[0]
	var x = arr[1]
	var z = arr[2]
	chunk = Chunk.new(noise, x * chunk_size, z * chunk_size, chunk_size)
	
	#translation was changed into position
	chunk.position = Vector3(x * chunk_size, 0, z * chunk_size)
	
	
	#Callable.call_deffered is more readable
	load_done.call_deferred(chunk,thread)
	pass
	
func load_done(chunk, thread):
	add_child(chunk)
	var key = str(chunk.x / chunk_size) + "," + str(chunk.z / chunk_size)
	chunks[key] = chunk
	unready_chunks.erase(key)
	thread.wait_to_finish()
	
func get_chunk(x, z):
	var key = str(x) + "," + str(z)
	if chunks.has(key):
		return chunks.get(key)
	return null

func update_chunks():
	
	var player_translation = $Player.position
	var p_x = int(player_translation.x) / chunk_size
	var p_z = int(player_translation.z) / chunk_size
	
	for x in range(p_x - chunk_amount * 0.5, p_x + chunk_amount * 0.5):
		for z in range(p_z - chunk_amount * 0.5, p_z + chunk_amount * 0.5):
			
			add_chunk(x, z)
			var chunk = get_chunk(x, z)
			if chunk != null:
				chunk.should_remove = false
				

func clean_up_chunks():
	for key in chunks:
		var chunk = chunks[key]
		if chunk.should_remove:
			chunk.queue_free()
			chunks.erase(key)
	pass


func reset_chunks():
	for key in chunks:
		chunks[key].should_remove = true
	pass
	
func _process(delta):
	update_chunks()
	clean_up_chunks()
	reset_chunks()