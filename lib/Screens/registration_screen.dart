import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quiz_app_fireship/Screens/main_screen.dart';
import 'package:quiz_app_fireship/constants.dart';
import 'package:quiz_app_fireship/main.dart';
import 'package:quiz_app_fireship/widgets/button.dart';
import 'package:quiz_app_fireship/widgets/text_input.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _saving = false;

  String _email;
  String _password;
  String _passwordCheck;

  void _submit() => setState(() => _saving = _saving ? false : true);

  bool notNullOrEmpty(String value) {
    if (value != null && value != '') {
      return true;
    } else {
      return false;
    }
  }

  void submitCredentials() => setState(() => _saving = _saving ? false : true);

  final _scaffoldRegisterKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldRegisterKey,
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
                            _email = typedEmail.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextInput(
                          fieldLabel: 'Senha',
                          isPassword: true,
                          onChanged: (typedPassword) {
                            _password = typedPassword.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextInput(
                          fieldLabel: 'Repita a Senha',
                          isPassword: true,
                          onChanged: (typedPassword) {
                            _passwordCheck = typedPassword.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Button(
                          text: 'Cadastrar-se',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (notNullOrEmpty(_email) &&
                                notNullOrEmpty(_password) &&
                                notNullOrEmpty(_passwordCheck)) {
                              if (_password != _passwordCheck) {
                                _scaffoldRegisterKey.currentState.showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'As senhas devem ser iguais')));
                              } else {
                                _submit();
                                var registrationCheck =
                                    await auth.registerUser(_email, _password);
                                if (!auth.isError(registrationCheck)) {
                                  await auth.loginUser(_email, _password);
                                  _submit();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    MainScreen.id,
                                    (_) => false,
                                  );
                                } else {
                                  // ! handle this else
                                }
                              }
                            } else {
                              _submit();
                              _scaffoldRegisterKey.currentState
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Todos os campos devem ser preenchidos'),
                              ));
                            }
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
