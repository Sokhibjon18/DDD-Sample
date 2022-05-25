import 'package:ddd_sample/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:ddd_sample/injection.dart';
import 'package:ddd_sample/presentation/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider(
        create: (_) => getIt<SignInFormBloc>(),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SignInForm(),
        ),
      ),
    );
  }
}
