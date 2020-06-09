import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  List<String> _errorList = [
    "E-mail mal formatado, favor verificar",
    "Senha incorreta",
    "Usuário não encontrado",
    "Usuário desabilitado",
    "Muitas requisiçoes simultaneas, favor tentar novamente",
    "Operação não autorizada",
    "Um erro inesperado ocorreu"
  ];

  Future registerUser(email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      return _errorTypeCheck(error);
    }
  }

  Future loginUser(email, password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      return _errorTypeCheck(error);
    }
  }

  Future<FirebaseUser> _currentUser() async {
    var user = await _auth.currentUser();
    return user;
  }

  bool checkLogedIn() {
    return _currentUser() != null ? true : false;
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error);
    }
  }

  String _errorTypeCheck(error) {
    String _errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        _errorMessage = "E-mail mal formatado, favor verificar";
        break;
      case "ERROR_WRONG_PASSWORD":
        _errorMessage = "Senha incorreta";
        break;
      case "ERROR_USER_NOT_FOUND":
        _errorMessage = "Usuário não encontrado";
        break;
      case "ERROR_USER_DISABLED":
        _errorMessage = "Usuário desabilitado";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        _errorMessage =
            "Muitas requisiçoes simultaneas, favor tentar novamente";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        _errorMessage = "Operação não autorizada";
        break;
      default:
        _errorMessage = "Um erro inesperado ocorreu";
    }
    return _errorMessage;
  }

  bool isError(String validation) {
    return _errorList.contains(validation) ? true : false;
  }

  Future<String> currentUserMail() async {
    if (_currentUser() != null) {
      return await _currentUser().then((value) => value.email);
    } else {
      return '';
    }
  }
}
