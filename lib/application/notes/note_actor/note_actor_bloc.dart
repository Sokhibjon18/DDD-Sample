import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/note/i_note_repository.dart';
import 'package:ddd_sample/domain/note/note.dart';
import 'package:ddd_sample/domain/note/note_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const _Initial()) {
    on<_Deleted>((event, emit) async {
      emit(const NoteActorState.actionInProgress());
      Either<NoteFailure, Unit> failureOrDeleted = await _noteRepository.delete(event.note);
      failureOrDeleted.fold(
        (failure) => emit(NoteActorState.deleteFailure(failure)),
        (_) => emit(const NoteActorState.deleteSuccess()),
      );
    });
  }
}
