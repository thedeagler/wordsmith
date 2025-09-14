class_name DialogDataBuilder
extends Node

var _dialog: DialogData

func _init():
	_dialog = DialogData.new()

func add_text(text: String) -> DialogDataBuilder:
	_dialog.dialog_texts.append(text)
	return self

func add_texts(texts: Array[String]) -> DialogDataBuilder:
	_dialog.dialog_texts.append_array(texts)
	return self

func add_speaker(speaker_name: String) -> DialogDataBuilder:
	_dialog.speaker_name = speaker_name
	return self

func build() -> DialogData:
	return _dialog