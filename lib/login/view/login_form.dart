import 'package:firebase_login/login/login.dart';
import 'package:firebase_login/recover/recover.dart';
import 'package:firebase_login/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Autenticação falhou'),
              ),
            );
        } else {
          return;
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const Icon(Icons.flutter_dash_outlined, size: 128),
              const Spacer(),
              _EmailInput(),
              _PasswordInput(),
              _LoginButton(),
              _ForgotPassword(),
              const Spacer(),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            decoration: InputDecoration(
              labelText: 'E-mail',
              helperText: '',
              errorText:
                  state.email.displayError != null ? 'E-mail inválido' : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscure != current.obscure,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            autofillHints: const [AutofillHints.password],
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: state.obscure,
            decoration: InputDecoration(
              suffixIcon: !state.obscure
                  ? IconButton(
                      onPressed: () =>
                          context.read<LoginCubit>().obscurePassword(),
                      icon: const Icon(Icons.remove_red_eye_outlined))
                  : IconButton(
                      onPressed: () =>
                          context.read<LoginCubit>().obscurePassword(),
                      icon: const Icon(Icons.visibility_off_outlined),
                    ),
              labelText: 'Senha',
              helperText: '',
              errorText:
                  state.password.displayError != null ? 'Senha inválida' : null,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: FilledButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    onPressed: state.isValid
                        ? () =>
                            context.read<LoginCubit>().logInWithCredentials()
                        : null,
                    child: const Text('Login'),
                  ),
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text('Login com Google'),
      icon: const Icon(FontAwesomeIcons.google),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        key: const Key('loginForm_createAccount_flatButton'),
        onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        child: Text('Registrar', style: TextStyle(color: theme.primaryColor)),
      ),
    );
  }
}

class _ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: SizedBox(
        width: double.maxFinite,
        child: TextButton(
          key: const Key('forgot_password_resend_email'),
          onPressed: () =>
              Navigator.of(context).push<void>(RecoverPage.route()),
          child: const Text('Recuperar senha'),
        ),
      ),
    );
  }
}
