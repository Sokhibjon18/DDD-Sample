import 'package:ddd_sample/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

extension FormTodoX on BuildContext {
  KtList<TodoItemPrimitive> get formToDos => Provider.of<FormTodos>(this, listen: false).value;
  set formToDos(KtList<TodoItemPrimitive> value) =>
      Provider.of<FormTodos>(this, listen: false).value = value;
}
