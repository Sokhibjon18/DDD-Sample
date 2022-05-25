import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/core/failures.dart';
import 'package:kt_dart/collection.dart';

Either<ValueFailure<String>, String> validateMaxStringLegth(
  String input,
  int maxLength,
) {
  return input.length <= maxLength
      ? right(input)
      : left(ValueFailure.exceedingLegth(failedValue: input, max: maxLength));
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  return input.isNotEmpty
      ? right(input)
      : left(ValueFailure.empty(failedValue: input));
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  return !input.contains('\n')
      ? right(input)
      : left(ValueFailure.empty(failedValue: input));
}

Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLegth<T>(
  KtList<T> input,
  int maxLength,
) {
  return input.size <= maxLength
      ? right(input)
      : left(ValueFailure.listTooLong(failedValue: input, max: maxLength));
}

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r'''^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$''';
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(
      ValueFailure.invalidEmail(failedValue: input),
    );
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(
      ValueFailure.shortPassword(failedValue: input),
    );
  }
}
