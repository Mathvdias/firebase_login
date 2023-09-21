import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_login/recover/recover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoverPage extends StatelessWidget {
  const RecoverPage({super.key});

  static Route<void> route() =>
      CupertinoPageRoute<void>(builder: (_) => const RecoverPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esqueci a senha')),
      body: BlocProvider(
        create: (_) => RecoverCubit(
          context.read<AuthenticationRepository>(),
        ),
        child: const RecoverForm(),
      ),
    );
  }
}
