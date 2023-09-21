import 'package:formz/formz.dart';

enum ConfirmedPassWordValidationError { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPassWordValidationError> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmedPassWordValidationError? validator(String? value) {
    return password == value ? null : ConfirmedPassWordValidationError.invalid;
  }
}
