import 'package:ddd_sample/application/notes/note_form/note_form_bloc.dart';
import 'package:ddd_sample/domain/note/value_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BodyField extends HookWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: 'Note',
            counterText: '',
          ),
          minLines: 5,
          maxLines: null,
          maxLength: NoteBody.maxLength,
          onChanged: (value) => context.read<NoteFormBloc>().add(NoteFormEvent.bodyChanged(value)),
          validator: (_) => context.read<NoteFormBloc>().state.note.body.value.fold(
                (f) => f.maybeMap(
                  empty: (_) => 'Cannot be empty',
                  exceedingLegth: (_) => 'Exceeding length',
                  orElse: () => null,
                ),
                (r) => null,
              ),
        ),
      ),
    );
  }
}
