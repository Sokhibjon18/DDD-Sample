import 'package:ddd_sample/domain/core/failures.dart';

class UnexpectedErrorValue extends Error {
  final ValueFailure valueFailure;

  UnexpectedErrorValue(this.valueFailure);

  @override
  String toString() {
    const explanation =
        'Encountered a ValueFailure at an unrecoverable point. Termineting.';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}
