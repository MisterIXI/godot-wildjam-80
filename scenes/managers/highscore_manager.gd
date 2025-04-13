extends Node
class_name Highscore_Manager
signal leaderboard_request_completed()

const GAME_API_KEY = ""
const URL_SEND = ""
const URL_GET  = ""
const DEBUG_MODE :bool = true
var highscore_table : Array[Highscore_Entry]
var send_request : HTTPRequest
var leaderboard_request : HTTPRequest
var headers = ["Content-Type: application/x-www-form-urlencoded"]
func _ready() -> void:
	highscore_table.clear()
	ReferenceManager.highscore_node = self
	if !DEBUG_MODE:
		get_leaderboard()
	else:
		highscore_table.append(Highscore_Entry.new("debug_mode","00m:00s:00ms","0","Date_Zero"))
		leaderboard_request_completed.emit()
############## GLOBAL SET HIGHSCORE FUNCTION ##############

# set new highscore (Name, Speedrun_Time, Collectables)
func set_new_highscore(_name, _score : int, _collectables : int) -> void:
	if !DEBUG_MODE:
		_send_score(_name,_score,_collectables)
	else:
		highscore_table.append(Highscore_Entry.new(_name,str(_score),str(_collectables), str(Time.get_date_string_from_system())))
#######################################################################################
func _on_score_request_completed(_result, _response_code, _header, _body) -> void:
	print("send completed")
	print(_body.get_string_from_utf8())
	# clear node
	send_request.queue_free()

func _on_leaderboard_request_completed(_result, _response_code, _headers, body) ->void:
	print("get_leaderboard_completed")
	var data = JSON.parse_string(body.get_string_from_utf8())
	print(data)
	highscore_table.clear()
	for x in data:
		print(x["player_name"], " - ", x["score"], " - ", x["collectables"], " - ", x["timestamp"])
		highscore_table.append(Highscore_Entry.new(x["player_name"],x["score"],x["collectables"], x["timestamp"]))
	
	leaderboard_request.queue_free()
	leaderboard_request_completed.emit()

func _send_score(_name: String, _score :int, _collectables : int):
	var _signature  =  (_name + str(_score) +str(_collectables) + GAME_API_KEY).sha256_text()
	print(_signature)
	var form_data = "name=%s&score=%s&collectables=%s&signature=%s" % [
        _name.uri_encode(), str(_score), str(_collectables), _signature.uri_encode()
    ]
	send_request = HTTPRequest.new()
	add_child(send_request)
	send_request.request_completed.connect(_on_score_request_completed)
	# Send request
	send_request.request(URL_SEND, headers, HTTPClient.METHOD_POST, form_data)

func get_leaderboard() -> void :
	leaderboard_request = HTTPRequest.new()
	add_child(leaderboard_request)
	leaderboard_request.request_completed.connect(_on_leaderboard_request_completed)# maybe later
	leaderboard_request.request(URL_GET)
