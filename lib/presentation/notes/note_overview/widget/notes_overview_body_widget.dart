import 'package:ddd_sample/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:ddd_sample/presentation/notes/note_overview/widget/critical_failure_display_widget.dart';
import 'package:ddd_sample/presentation/notes/note_overview/widget/error_note_card_widget.dart';
import 'package:ddd_sample/presentation/notes/note_overview/widget/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const Center(child: CircularProgressIndicator()),
          loadSuccess: (success) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final note = success.note[index];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(note: note);
                } else {
                  return NoteCard(note: note);
                }
              },
              itemCount: success.note.size,
            );
          },
          loadFailure: (failure) => CriticalFailureDisplay(failure: failure.failure),
        );
      },
    );
  }
}
