class validateText{
  
  String? validateEmail(String? value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (value!.isEmpty) {
      return 'por favor ingrese el email';
    } else {
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value)) {
        return 'Enter Valid Email';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'por favor ingrese el password';
    } else {
      if (6 > value.length) {
        return 'por favor ingrese una constraseña de 6 caracteres';
      }
    }
    return null;
  }
}