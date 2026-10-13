class_name Utils extends Object


static func set_visible_only(visible_node: CanvasItem, invisible_nodes: Array[CanvasItem]) -> void:
	for inv_node: CanvasItem in invisible_nodes:
		if inv_node == visible_node:
			continue
			
		inv_node.visible = false
	
	visible_node.visible = true
	
static func is_web_build() -> bool:
	return OS.has_feature("web")
	
static func is_in_editor() -> bool:
	return OS.has_feature("editor")
	
static func is_release_build() -> bool:
	return OS.has_feature("release")

static func current_timestamp(include_ms: bool = true, include_hr_string: bool = true, delimiter: String = ":", ms_delimiter: String = ".") -> String:
	var ms: int = Time.get_ticks_msec()
	return get_timestr_from_ms(ms, include_ms, include_hr_string, delimiter, ms_delimiter)

static func get_timestr_from_ms(ms: int, include_ms: bool = true, include_hr_string: bool = true, delimiter: String = ":", ms_delimiter: String = ".") -> String:
	@warning_ignore_start("integer_division")
	var hr_str: String = ""
	if include_hr_string:
		hr_str = str(ms/3600000)+delimiter
	
	var seconds_str: String = str((ms%60000)/1000)
	var minutes_str: String = str((ms%3600000)/60000)

	var time_str: String = hr_str+minutes_str.pad_zeros(2)+delimiter+seconds_str.pad_zeros(2)
	if include_ms:
		var ms_str: String = str(ms)
		if ms_str.length() > 3:
			ms_str = ms_str.erase(0, ms_str.length() - 3)
		time_str = time_str + ms_delimiter + ms_str
	return time_str
	@warning_ignore_restore("integer_division")
	
# recursively gets all children with filter option, with signature:
# func filter(node: Node) -> bool
# e.g. node is BaseButton
static func collect_nodes_in_children(node: Node, filter: Callable) -> Array[Node]:
	var res: Array[Node] = []
	if filter.call(node):
		res.append(node)
		
	for child: Node in node.get_children():
		var children_nodes: Array[Node]= collect_nodes_in_children(child, filter)
		res.append_array(children_nodes)
				
	return res

static func is_base_button(node: Node) -> bool:
	return node is BaseButton

static func get_path_to_node(node: Node) -> String:
	return node.get_tree().root.get_path_to(node)
		

static func set_bus_volume(audio_type: SettingsIOClass.AudioType, volume_linear: float) -> void:
	var vol_to_use: float = volume_linear
	if vol_to_use <= 0:
		vol_to_use = 0.00001
	var bus_index: int = AudioServer.get_bus_index(Utils.get_audio_type_string(audio_type))	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol_to_use))
	#set_ui_value_by_audio_type(audio_type, volume_linear)
	
static func set_bus_muted(audio_type: SettingsIOClass.AudioType, is_muted_new: bool) -> void:
	var bus_index: int = AudioServer.get_bus_index(Utils.get_audio_type_string(audio_type))
	AudioServer.set_bus_mute(bus_index, is_muted_new)
	
static func is_bus_muted(audio_type: SettingsIOClass.AudioType) -> bool:
	var bus_index: int = AudioServer.get_bus_index(Utils.get_audio_type_string(audio_type))
	return AudioServer.is_bus_mute(bus_index)
	
static func get_audio_type_string(audio_type: SettingsIOClass.AudioType) -> String:
	match audio_type:
		SettingsIOClass.AudioType.MASTER:
			return "Master"
		SettingsIOClass.AudioType.MUSIC:
			return "Music"
		SettingsIOClass.AudioType.SFX:
			return "SFX"
		SettingsIOClass.AudioType.AMBIENCE:
			return "Ambience"
			
	push_warning("Audio type " + str(audio_type) + " not implemented...")
	return "Unknown Audio Type"
	
## Returns the best audio player in the given array. This will directly return an audio stream player if it is not playing.
## Otherwise it favors audio stream players that have progressed the most.
## Note: This is untyped due to AudioStreamPlayer, AudioStreamPlayer2D and AudioStreamPlayer3D not sharing a common base class.
static func get_most_free_audio_stream_player(audio_stream_players: Array) -> Node:
	var most_progress: float = 0
	var most_progress_player: Node = null
	for target_player: Node in audio_stream_players:
		if _is_free(target_player):
			return target_player
		
		var current_progress: float = _get_progress(target_player)
		if current_progress >= most_progress:
			most_progress = current_progress
			most_progress_player = target_player
			
	return most_progress_player

## Returns the first audio player in the given array that is not playing, or null if there is no free audio player.
## Note: This is untyped due to AudioStreamPlayer, AudioStreamPlayer2D and AudioStreamPlayer3D not sharing a common base class.
static func get_free_audio_stream_player_or_null(target_audio_players: Array) -> Node:
	var free_players: Array = target_audio_players.filter(_is_free)
	if free_players.size() > 0:
		return free_players[0]
	return null
	
static func _is_free(audio_stream_player: Node) -> bool:
	@warning_ignore("unsafe_property_access")
	return audio_stream_player.playing || audio_stream_player.stream == null

static func _get_progress(audio_stream_player: Node) -> float:
	@warning_ignore("unsafe_property_access")
	@warning_ignore("unsafe_method_access")
	return audio_stream_player.get_playback_position() / audio_stream_player.stream.get_length()
		
static func collect_audio_stream_player_2d_in_children(node: Node) -> Array[AudioStreamPlayer2D]:
	var res: Array[AudioStreamPlayer2D] = []
	for child: Node in node.get_children():
		var current_progress: Array[AudioStreamPlayer2D]= collect_audio_stream_player_2d_in_children(child)
		res.append_array(current_progress)
		
	if node is AudioStreamPlayer2D:
		res.append(node)
		
	return res
	
static func collect_audio_stream_player_in_children(node: Node) -> Array[AudioStreamPlayer]:
	var res: Array[AudioStreamPlayer] = []
	for child: Node in node.get_children():
		var current_progress: Array[AudioStreamPlayer]= collect_audio_stream_player_in_children(child)
		res.append_array(current_progress)
		
	if node is AudioStreamPlayer:
		res.append(node)
		
	return res
