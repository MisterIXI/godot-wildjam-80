class_name Highscore_Entry
var rank : String = "0"
var playername : String  =""
var time : String =""
var collectable : String =""

func get_entry():
    return ("" + rank + "-" + playername + "-" + time)
func _init(_rank,_playername,_time, _collectable):
    rank = _rank
    playername = _playername
    time = _time
    collectable = _collectable