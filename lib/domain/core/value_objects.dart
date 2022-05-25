import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/core/errors.dart';
import 'package:ddd_sample/domain/core/failures.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  /// Throws [UnexpectedErrorValue] containing [ValueFilure]
  T getOrCrash() {
    // id = identity same as writing (right) => right
    return value.fold((f) => throw UnexpectedErrorValue(f), id);
  }

  Either<ValueFailure<dynamic>, dynamic> get failureOrUnit {
    return value.fold(
      (l) => left(l),
      (r) => right(unit),
    );
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ValueObject($value)';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  const UniqueId._(this.value);

  factory UniqueId() {
    return UniqueId._(right(const Uuid().v1()));
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(right(uniqueId));
  }
}
