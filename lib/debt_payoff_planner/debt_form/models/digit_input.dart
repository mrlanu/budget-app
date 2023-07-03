import 'package:formz/formz.dart';

enum MyDigitValidationError {invalid}

class MyDigit extends FormzInput<String, MyDigitValidationError>{

  const MyDigit.pure([super.value = '']) : super.pure();
  const MyDigit.dirty([super.value = '']) : super.dirty();

  static final RegExp _balanceRegex = RegExp(
    r'^([0-9]*[0-9]*(\.[0-9]+)?|0+\.[0-9]*[0-9]*)$',
  );

  @override
  MyDigitValidationError? validator(String? value) {
    final tst = _balanceRegex.hasMatch(value ?? '') && value != ''
        ? null
        : MyDigitValidationError.invalid;
    return tst;
  }
}
