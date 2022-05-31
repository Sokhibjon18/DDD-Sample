import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/note/i_note_repository.dart';
import 'package:ddd_sample/domain/note/note_failure.dart';
import 'package:ddd_sample/domain/note/note.dart';
import 'package:ddd_sample/infrastructure/notes/note_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:ddd_sample/infrastructure/core/firestore_helper.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _fireStore;

  NoteRepository(this._fireStore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _fireStore.userDocument();
    final query = userDoc.collection('notes').orderBy('serverTimeStamp', descending: true);
    final snapshotStream = query.snapshots();

    yield* snapshotStream.map((snapshot) {
      final docs = snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain());
      final docsList = docs.toImmutableList();
      return right<NoteFailure, KtList<Note>>(docsList);
    }).onErrorReturnWith((error, stackTrace) {
      if (error is FirebaseException && stackTrace.toString().contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncomleted() async* {
    final userDoc = await _fireStore.userDocument();
    final query = userDoc.collection('notes').orderBy('serverTimeStamp', descending: true);
    final snapshotStream = query.snapshots();

    yield* snapshotStream.map((snapshot) {
      final docs = snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain());
      final uncomplatedTodos = docs.where((note) => noteHasUncompletedTodo(note)).toImmutableList();
      return right<NoteFailure, KtList<Note>>(uncomplatedTodos);
    }).onErrorReturnWith((error, stackTrace) {
      if (error is FirebaseException && stackTrace.toString().contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  bool noteHasUncompletedTodo(Note note) => note.todos.getOrCrash().any((todo) => !todo.done);

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _fireStore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.collection('notes').doc(noteDto.id).set(noteDto.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.toString().contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _fireStore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      final json = noteDto.toJson();
      await userDoc.collection('notes').doc(noteDto.id).update(json);

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.toString().contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message.toString().contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _fireStore.userDocument();
      final noteId = note.id.getOrCrash();

      await userDoc.collection('notes').doc(noteId).delete();

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.toString().contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message.toString().contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
