
abstract class StringValidator {
  bool isValid(String text);
}

class NonEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String text) {
    return text.isNotEmpty;
  }
}

class EmailAndPasswordValidators{
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Введите Email';
  final String invalidPasswordErrorText = 'Введите пароль';
}