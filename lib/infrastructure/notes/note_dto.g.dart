// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NoteDto _$$_NoteDtoFromJson(Map<String, dynamic> json) => _$_NoteDto(
      id: json['id'] as String?,
      body: json['body'] as String,
      color: json['color'] as int,
      todos: (json['todos'] as List<dynamic>)
          .map((e) => TodoItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      serverTimeStamp: const ServerTimestampConverter()
          .fromJson(json['serverTimeStamp'] as Object),
    );

Map<String, dynamic> _$$_NoteDtoToJson(_$_NoteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'color': instance.color,
      'todos': instance.todos,
      'serverTimeStamp':
          const ServerTimestampConverter().toJson(instance.serverTimeStamp),
    };

_$_TodoItemDto _$$_TodoItemDtoFromJson(Map<String, dynamic> json) =>
    _$_TodoItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      done: json['done'] as bool,
    );

Map<String, dynamic> _$$_TodoItemDtoToJson(_$_TodoItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'done': instance.done,
    };
