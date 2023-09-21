import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../cubit/recover_cubit.dart';

class RecoverForm extends StatelessWidget {
  const RecoverForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BlocListener<RecoverCubit, RecoverState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: colorScheme.error,
                content:
                    Text(state.errorMessage ?? 'Falha ao processar requisição'),
              ),
            );
        } else if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: colorScheme.secondary,
                content: const Text('Um link foi enviado para seu e-mail'),
              ),
            );
          Navigator.pop(context);
        } else {
          return;
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Para recuperar sua senha digite seu e-mail',
                style: theme.textTheme.titleLarge,
              ),
            ),
            _EmailInput(),
            const Spacer(),
            _RecoverButton()
          ],
        ),
      ),
    );
  }
}

final class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverCubit, RecoverState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<RecoverCubit>().emailChanged(email),
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

final class _RecoverButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverCubit, RecoverState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: double.maxFinite,
                child: FilledButton(
                  onPressed: state.isValid
                      ? () => context.read<RecoverCubit>().sendPassowordReset()
                      : null,
                  child: const Text('Enviar'),
                ),
              ),
      );
    });
  }
}
