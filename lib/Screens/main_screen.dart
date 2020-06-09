import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app_fireship/constants.dart';
import 'package:quiz_app_fireship/Screens/login_screen.dart';
import 'package:quiz_app_fireship/main.dart';
import 'package:quiz_app_fireship/models/file_data.dart';
import 'package:quiz_app_fireship/widgets/file_list_widget.dart';

class MainScreen extends StatefulWidget {
  static String id = '/';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String userMail = '';

  void getUserMail() async {
    userMail = await auth.currentUserMail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUserMail();
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(userMail),
      appBar: AppBar(
        backgroundColor: kLoginBackgroundColor,
        centerTitle: true,
        title: Text(
          'Mestre de Obra',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Carregando...'),
                duration: Duration(seconds: 60),
              ));
              await network.updateDatabase().then(
                  (value) => _scaffoldKey.currentState.hideCurrentSnackBar());
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(network.updatedDB),
              ));
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: ChangeNotifierProvider<FileData>(
        create: (context) => FileData(),
        child: FileSListWidget(),
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  final _userMail;

  const MainDrawer(this._userMail);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  color: kLoginBackgroundColor,
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Projeto'),
                        Text(_userMail),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Desconectar',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            onPressed: () async {
              await auth.logoutUser();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

// TODO Return a message if the user has no permissions in any project
// TODO  Implement a function to get all the registered users and insert them into the database
