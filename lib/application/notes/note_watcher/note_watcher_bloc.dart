import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/note/i_note_repository.dart';
import 'package:ddd_sample/domain/note/note.dart';
import 'package:ddd_sample/domain/note/note_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>? _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository) : super(const _Initial()) {
    on<_WatchAllStarted>((event, emit) async {
      emit(const NoteWatcherState.loadInProgress());
      await _noteStreamSubscription?.cancel();
      _noteStreamSubscription = _noteRepository.watchAll().listen((failureOrNotes) {
        add(NoteWatcherEvent.notesReceived(failureOrNotes));
      });
    });
    on<_WatchUncompletedStarted>((event, emit) async {
      emit(const NoteWatcherState.loadInProgress());
      await _noteStreamSubscription?.cancel();
      _noteStreamSubscription = _noteRepository.watchUncomleted().listen((failureOrNotes) {
        add(NoteWatcherEvent.notesReceived(failureOrNotes));
      });
    });
    on<_NotesReceived>((event, emit) {
      event.failureOrNotes.fold(
        (noteFailure) => emit(NoteWatcherState.loadFailure(noteFailure)),
        (noteList) => emit(NoteWatcherState.loadSuccess(noteList)),
      );
    });
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
