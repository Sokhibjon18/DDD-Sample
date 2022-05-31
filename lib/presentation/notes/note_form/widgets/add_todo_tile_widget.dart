import 'package:ddd_sample/application/notes/note_form/note_form_bloc.dart';
import 'package:ddd_sample/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:ddd_sample/presentation/notes/note_form/misc/build_context_x.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) => previous.isEditing != current.isEditing,
      listener: (context, state) {
        context.formToDos = state.note.todos.value.fold(
          (f) => listOf<TodoItemPrimitive>(),
          (todoItemList) => todoItemList.map((p0) => TodoItemPrimitive.fromDomain(p0)),
        );
      },
      buildWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text('Add a todo'),
          leading: const Icon(Icons.add),
          onTap: () {
            context.formToDos = context.formToDos.plusElement(TodoItemPrimitive.empty());
            context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formToDos));
          },
        );
      },
    );
  }
}
