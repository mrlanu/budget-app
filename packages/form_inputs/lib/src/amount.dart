import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum AmountValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Amount extends FormzInput<String, AmountValidationError> {
  /// {@macro email}
  const Amount.pure() : super.pure('');

  /// {@macro email}
  const Amount.dirty([super.value = '']) : super.dirty();

  static final RegExp _amountRegExp = RegExp(
    r'^-?[0-9][0-9,\.]+$',
  );

  @override
  AmountValidationError? validator(String? value) {
    return _amountRegExp.hasMatch(value ?? '')
        ? null
        : AmountValidationError.invalid;
  }
}
