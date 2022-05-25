import 'package:ddd_sample/domain/auth/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const Initial()) {
    on<AuthEvent>((event, emit) {});
    on<AuthCheckRequested>((event, emit) async {
      final userOption = await _authFacade.getSignedInUser();
      userOption.fold(
        () => emit(const AuthState.unauthenticated()),
        (a) => emit(const AuthState.authenticated()),
      );
    });
    on<SignedOut>((event, emit) async {
      await _authFacade.signOut();
      emit(const AuthState.unauthenticated());
    });
  }
}
