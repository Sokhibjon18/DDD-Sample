import 'package:ddd_sample/domain/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/core/value_objects.dart';
import 'package:ddd_sample/domain/core/value_transformers.dart';
import 'package:ddd_sample/domain/core/value_validators.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';

class NoteBody extends ValueObject {
  @override
  final Either<ValueFailure, dynamic> value;

  static const maxLength = 1000;

  factory NoteBody(String input) {
    return NoteBody._(
      validateMaxStringLegth(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }

  const NoteBody._(this.value);
}

class TodoName extends ValueObject {
  @override
  final Either<ValueFailure, dynamic> value;

  static const maxLength = 30;

  factory TodoName(String input) {
    return TodoName._(
      validateMaxStringLegth(input, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateSingleLine),
    );
  }

  const TodoName._(this.value);
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> predefinedColors = [
    Color(0xfffafafa),
    Color(0xfffa8072),
    Color(0xfffedc56),
    Color(0xffd0f0c0),
    Color(0xfffca3b7),
    Color(0xff997950),
    Color(0xfffffdd0),
  ];

  @override
  final Either<ValueFailure<Color>, Color> value;

  static const maxLength = 30;

  factory NoteColor(Color input) {
    return NoteColor._(right(makeColorFullOpacity(input)));
  }

  const NoteColor._(this.value);
}

class List3<T> extends ValueObject<KtList<T>> {
  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const maxLength = 3;

  factory List3(KtList<T> input) {
    return List3._(validateMaxListLegth(input, maxLength));
  }

  const List3._(this.value);

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull => maxLength == length;
}
