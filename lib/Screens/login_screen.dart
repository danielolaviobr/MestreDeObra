import 'package:flutter/material.dart';
import 'package:quiz_app_fireship/Screens/registration_screen.dart';
import 'package:quiz_app_fireship/main.dart';
import 'package:quiz_app_fireship/Screens/main_screen.dart';
import 'package:quiz_app_fireship/constants.dart';
import 'package:quiz_app_fireship/widgets/button.dart';
import 'package:quiz_app_fireship/widgets/text_input.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _saving = false;

  String _email;
  String _password;

  bool notNullOrEmpty(String value) {
    if (value != null && value != '') {
      return true;
    } else {
      return false;
    }
  }

  void submitCredentials() => setState(() => _saving = _saving ? false : true);

  final _scaffoldLoginKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //checkLogedIn();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldLoginKey,
      backgroundColor: kLoginBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                      color: kFileCardColor,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [kDefaultShaddow]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextInput(
                          fieldLabel: 'E-mail',
                          isPassword: false,
                          onChanged: (typedEmail) {
                            _email = typedEmail;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextInput(
                          fieldLabel: 'Senha',
                          isPassword: true,
                          onChanged: (typedPassword) {
                            _password = typedPassword;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Button(
                            text: 'Login',
                            onPressed: () async {
// TODO Refactor this function, too many if statements and diferent snacbars
                              FocusScope.of(context).unfocus();
                              if (notNullOrEmpty(_email) &&
                                  notNullOrEmpty(_password)) {
                                submitCredentials();
                                var _loginValidation =
                                    await auth.loginUser(_email, _password);
                                if (_loginValidation != null &&
                                    !auth
                                        .isError(_loginValidation.toString())) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    MainScreen.id,
                                    (_) => false,
                                  );
                                } else {
                                  submitCredentials();
                                  SnackBar errorMessage =
                                      SnackBar(content: Text(_loginValidation));
                                  _scaffoldLoginKey.currentState
                                      .showSnackBar(errorMessage);
                                }
                              } else {
                                SnackBar loginFieldsError = SnackBar(
                                    content: Text(
                                        'Preencha todos os campos para realizar o login'));
                                _scaffoldLoginKey.currentState
                                    .showSnackBar(loginFieldsError);
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Button(
                          text: 'Cadastrar-se',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
