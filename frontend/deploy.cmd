haxe build-hl.hxml
haxe pak.hxml
hl packing.hl
DEL packing.hl
RENAME res.null.pak res.pak
MKDIR bloccly
MOVE res.pak bloccly
COPY bin\hl\game.hl bloccly\game.hl
Pause