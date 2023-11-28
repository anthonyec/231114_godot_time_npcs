class_name Timeline
extends Node

signal changed
signal added_track(track: Track)
signal removed_track(track_id: String)
signal added_clip(clip: Clip, track: Track)
signal removed_clip(clip_id: String)

@export var size: float = 10

class Clip:
	var id: String
	var start: float
	var end: float
	
	func _init(id: String, start: float, end: float) -> void:
		self.id = id
		self.start = start
		self.end = end
		
	func to_serialized() -> Dictionary:
		return { "id": id, "start": start, "end": end }
		
	static func from_serialized(serialized_clip: Dictionary) -> Clip:
		var clip_id = serialized_clip.get("id")
		assert(clip_id != null and typeof(clip_id) == TYPE_STRING, "Expected clip ID to exist and be a string")
		
		var start = serialized_clip.get("start")
		assert(start != null and (typeof(start) == TYPE_INT or typeof(start) == TYPE_FLOAT), "Expected clip start to exist and be a number")
		
		var end = serialized_clip.get("end")
		assert(end != null and (typeof(end) == TYPE_INT or typeof(end) == TYPE_FLOAT), "Expected clip end to exist and be a number")
		
		return Clip.new(clip_id, float(start), float(end))
	
class Track:
	var id: String
	var clips: Array[Clip]
	
	func _init(id: String) -> void:
		self.id = id
		
	func to_serialized() -> Dictionary:
		var serialized_clips: Array[Dictionary] = []
		
		for clip in clips:
			serialized_clips.append(clip.to_serialized())
		
		return { "id": id, "clips": serialized_clips }
		
	static func from_serialized(serialized_track: Dictionary) -> Track:
		var track_id = serialized_track.get("id")
		assert(track_id != null and typeof(track_id) == TYPE_STRING, "Expected track ID to exist and be a string")
		
		var serialized_clips = serialized_track.get("clips")
		assert(serialized_clips != null and typeof(serialized_clips) == TYPE_ARRAY, "Expected clips to exist and be an array")
		
		var track = Track.new(track_id)
		
		for serialized_clip in serialized_clips:
			var clip = Clip.from_serialized(serialized_clip)
			track.clips.append(clip)
		
		return track
	
var tracks: Array[Track] = []

func import(serialized_tracks: Array[Dictionary]) -> void:
	tracks = []
	
	for serialized_track in serialized_tracks:
		tracks.append(Track.from_serialized(serialized_track))

func export() -> Array[Dictionary]:
	var serialized_tracks: Array[Dictionary] = []
	
	for track in tracks:
		serialized_tracks.append(track.to_serialized())
		
	return serialized_tracks

func get_track_or_null(track_id: String) -> Track:
	var found_track: Track
	
	for track in tracks:
		if track.id == track_id:
			return track
			
	return found_track
	
func add_track(track_id: String) -> void:
	var track = Track.new(track_id)
	
	tracks.append(track)
	added_track.emit(track)
	
func remove_track(track_id: String) -> void:
	for index in range(tracks.size() - 1, -1, -1):
		var track = tracks[index]
		
		if track.id == track_id:
			tracks.remove_at(index)
			break
			
	removed_track.emit(track_id)
	
func add_clip_to_track(clip_id: String, track_id: String, start: float, end: float) -> void:
	var track = get_track_or_null(track_id)
	if not track: return
	
	var clip = Clip.new(clip_id, start, end)
	
	track.clips.append(clip)
	added_clip.emit(clip, track)
	
func remove_clip(clip_id: String) -> void:
	for track in tracks:
		for index in range(track.clips.size() - 1, -1, -1):
			var clip = track.clips[index]
			
			if clip.id == clip_id:
				track.clips.remove_at(index)
				break
				
	removed_clip.emit(clip_id)
