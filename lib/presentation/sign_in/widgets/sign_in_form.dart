import 'dart:developer';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ddd_sample/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (failure) {
              log(failure.toString());
              return FlushbarHelper.createError(
                message: failure.map(
                  canceledByUser: (_) => 'Canceled',
                  serverError: (_) => 'Server Error',
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) =>
                      'invalid email and password combination',
                ),
              ).show(context);
            },
            (_) => {
              // TODO: Navigate
            },
          ),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessage
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListView(
            children: [
              const Text(
                '📝',
                style: TextStyle(fontSize: 130),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (value) =>
                    context.read<SignInFormBloc>().add(EmailChanged(value)),
                validator: (_) => context
                    .read<SignInFormBloc>()
                    .state
                    .emailAddress
                    .value
                    .fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'Invalid Email',
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_rounded),
                  labelText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                onChanged: (value) =>
                    context.read<SignInFormBloc>().add(PasswordChanged(value)),
                validator: (_) =>
                    context.read<SignInFormBloc>().state.password.value.fold(
                          (f) => f.maybeMap(
                            shortPassword: (_) => 'Short Password',
                            orElse: () => null,
                          ),
                          (r) => null,
                        ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<SignInFormBloc>()
                            .add(const SignInWithEmailAndPasswordPressed());
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<SignInFormBloc>()
                            .add(const RegisterWithEmailAndPasswordPressed());
                      },
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<SignInFormBloc>()
                      .add(const SignInWithGooglePressed());
                },
                child: const Text('Sign In With Google'),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(value: null)
              ]
            ],
          ),
        );
      },
    );
  }
}
