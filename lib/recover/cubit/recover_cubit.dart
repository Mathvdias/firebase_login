import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:form_inputs/form_inputs.dart';

part 'recover_state.dart';

class RecoverCubit extends Cubit<RecoverState> {
  final AuthenticationRepository _authenticationRepository;

  RecoverCubit(this._authenticationRepository) : super(const RecoverState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    log(email.toString());
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  Future<void> sendPassowordReset() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.forgotPassword(
        email: state.email.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on ForgotPasswordFailure catch (_) {
      emit(state.copyWith(
        errorMessage: "Ocorreu um erro",
        status: FormzSubmissionStatus.failure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
