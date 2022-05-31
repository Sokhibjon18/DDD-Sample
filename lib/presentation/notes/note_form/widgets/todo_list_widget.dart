import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ddd_sample/application/notes/note_form/note_form_bloc.dart';
import 'package:ddd_sample/domain/note/value_object.dart';
import 'package:ddd_sample/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:ddd_sample/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) => previous.note.todos.isFull != current.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: 'Want longer list? Premium',
            button: Container(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: formTodos.value.size,
            itemBuilder: ((context, index) {
              return TodoTile(index: index, key: ValueKey(context.formToDos[index].id));
            }),
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;

  const TodoTile({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = context.formToDos.getOrElse(index, (p0) => TodoItemPrimitive.empty());
    final textEditingController = useTextEditingController(text: todo.name);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.done,
          onChanged: (value) {
            context.formToDos = context.formToDos
                .map((listTodo) => listTodo == todo ? todo.copyWith(done: value!) : listTodo);
            context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formToDos));
          },
        ),
        title: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            hintText: 'Todo',
            border: InputBorder.none,
            counterText: '',
          ),
          maxLength: TodoName.maxLength,
          onChanged: (value) {
            context.formToDos = context.formToDos
                .map((listTodo) => listTodo == todo ? todo.copyWith(name: value) : listTodo);
            context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formToDos));
          },
          validator: (_) {
            return context.read<NoteFormBloc>().state.note.todos.value.fold(
                  (f) => null,
                  (todoList) => todoList[index].name.value.fold(
                        (f) => f.maybeMap(
                          empty: (_) => 'Can not be empty',
                          exceedingLegth: (_) => 'Too long',
                          multiline: (_) => 'Has to be single line',
                          orElse: () {},
                        ),
                        (_) => null,
                      ),
                );
          },
        ),
        trailing: GestureDetector(
          onTap: () {
            context.formToDos = context.formToDos.minusElement(todo);
            context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formToDos));
          },
          child: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}
