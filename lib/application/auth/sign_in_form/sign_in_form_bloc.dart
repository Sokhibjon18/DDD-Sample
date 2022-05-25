import 'package:dartz/dartz.dart';
import 'package:ddd_sample/domain/auth/i_auth_facade.dart';
import 'package:ddd_sample/domain/auth/value_objects.dart';
import 'package:ddd_sample/domain/auth/auth_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  //! This is translated function from bloc vertion < 8
  //! Should be used in
  //! RegisterWithEmailAndPasswordPressed,
  //! SignInWithEmailAndPasswordPressed
  // void performActionOnAuthFacadeWithEmailAndPassword(
  //   Future<Either<AuthFailure, Unit>> Function({
  //     required EmailAddress emailAddress,
  //     required Password password,
  //   })
  //       forwardedCall,
  // ) async {
  //   Either<AuthFailure, Unit>? failureOrSuccess;

  //   final isEmailValid = state.emailAddress.isValid();
  //   final isPasswordValid = state.password.isValid();

  //   if (isEmailValid && isPasswordValid) {
  //     emit(state.copyWith(
  //       isSubmitting: true,
  //       authFailureOrSuccessOption: none(),
  //     ));

  //     failureOrSuccess = await forwardedCall(
  //       emailAddress: state.emailAddress,
  //       password: state.password,
  //     );
  //   }
  //   emit(state.copyWith(
  //     isSubmitting: false,
  //     showErrorMessage: true,
  //     authFailureOrSuccessOption: optionOf(failureOrSuccess),
  //   ));
  // }

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(
        emailAddress: EmailAddress(event.emailStr),
        authFailureOrSuccessOption: none(),
      ));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: Password(event.password),
        authFailureOrSuccessOption: none(),
      ));
    });

    on<RegisterWithEmailAndPasswordPressed>((event, emit) async {
      Either<AuthFailure, Unit>? failureOrSuccess;

      final isEmailValid = state.emailAddress.isValid();
      final isPasswordValid = state.password.isValid();

      if (isEmailValid && isPasswordValid) {
        emit(state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ));

        failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
          email: state.emailAddress,
          password: state.password,
        );

        emit(state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        ));
      }

      //! optionOf => failureOrSuccess == null ? none() : some(failureOrSuccess)
      emit(state.copyWith(
        showErrorMessage: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ));
    });

    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      Either<AuthFailure, Unit>? failureOrSuccess;

      final isEmailValid = state.emailAddress.isValid();
      final isPasswordValid = state.password.isValid();

      if (isEmailValid && isPasswordValid) {
        emit(state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ));

        failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
          email: state.emailAddress,
          password: state.password,
        );
      }

      //! optionOf => failureOrSuccess == null ? none() : some(failureOrSuccess)
      emit(state.copyWith(
        isSubmitting: false,
        showErrorMessage: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ));
    });

    on<SignInWithGooglePressed>((event, emit) async {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      final failureOrSuccess = await _authFacade.signInWithGoogle();

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess),
      ));
    });
  }
}
