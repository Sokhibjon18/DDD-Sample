import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/auth/auth_failure.dart';
import 'package:ddd_sample/domain/auth/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthFacade {
  Future<Option<User>> getSignedInUser();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}
