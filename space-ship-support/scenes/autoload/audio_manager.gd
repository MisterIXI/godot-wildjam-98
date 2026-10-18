class_name AudioManagerClass
extends Node

enum SfxType {
	ACCEPT,
	CANCEL,
	HOVER,
	PING,
	UTIL_A,
	UTIL_B
}
@export var accept_asp: AudioStreamPlayer
@export var cancel_asp: AudioStreamPlayer
@export var hover_asp: AudioStreamPlayer
@export var ping_asp: AudioStreamPlayer
@export var util_a_asp: AudioStreamPlayer
@export var util_b_asp: AudioStreamPlayer

func play_sfx(sfx_type: SfxType) -> void:
	match sfx_type:
		SfxType.ACCEPT: accept_asp.play()
		SfxType.CANCEL: cancel_asp.play()
		SfxType.HOVER: hover_asp.play()
		SfxType.PING: ping_asp.play()
		SfxType.UTIL_A: util_a_asp.play()
		SfxType.UTIL_B: util_b_asp.play()
		
