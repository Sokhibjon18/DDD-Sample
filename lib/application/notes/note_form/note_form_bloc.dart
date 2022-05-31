import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/note/i_note_repository.dart';
import 'package:ddd_sample/domain/note/note.dart';
import 'package:ddd_sample/domain/note/note_failure.dart';
import 'package:ddd_sample/domain/note/value_object.dart';
import 'package:ddd_sample/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<_Initialized>((event, emit) {
      event.initialNoteOption.fold(
        () => emit(state),
        (initialNote) => emit(state.copyWith(
          note: initialNote,
          isEditing: true,
        )),
      );
    });
    on<_BodyChanged>((event, emit) {
      emit(
        state.copyWith(
          note: state.note.copyWith(body: NoteBody(event.bodyStr)),
          saveFailureOrSuccessOption: none(),
        ),
      );
    });
    on<_ColorChanged>((event, emit) {
      emit(state.copyWith(
        note: state.note.copyWith(color: NoteColor(event.color)),
        saveFailureOrSuccessOption: none(),
      ));
    });
    on<_TodosChanged>((event, emit) {
      emit(
        state.copyWith(
          note: state.note.copyWith(todos: List3(event.todos.map((todo) => todo.toDomain()))),
          saveFailureOrSuccessOption: none(),
        ),
      );
    });
    on<_Saved>((event, emit) async {
      Either<NoteFailure, Unit>? failureOrSuccess;

      emit(state.copyWith(
        isSaving: true,
        saveFailureOrSuccessOption: none(),
      ));

      if (state.note.failureOption.isNone()) {
        failureOrSuccess = state.isEditing
            ? await _noteRepository.update(state.note)
            : await _noteRepository.create(state.note);
      }

      emit(state.copyWith(
        isSaving: false,
        showErrorMessage: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess),
      ));
    });
  }
}
