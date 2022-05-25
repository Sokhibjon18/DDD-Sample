import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/note/note.dart';
import 'package:ddd_sample/domain/note/note_failure.dart';
import 'package:kt_dart/collection.dart';

abstract class INoteRepository {
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();
  Stream<Either<NoteFailure, KtList<Note>>> watchUncomleted();
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);
}
