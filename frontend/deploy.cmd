haxe build-hl.hxml
haxe pak.hxml
hl packing.hl
DEL packing.hl
RENAME res.null.pak res.pak
MKDIR bin\release\bloccly
MOVE res.pak bin\release\bloccly
COPY bin\hl\game.hl bin\release\bloccly\game.hl
Pause