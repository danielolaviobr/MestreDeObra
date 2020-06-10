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
  String project = '';
  bool loading = true;

  get _setState {
    if (loading) {
      loading = false;
      return setState(() {});
    }
  }

  void getUserData() async {
    userMail = await auth.currentUserMail();
    project = await network.firstUserProject(userMail) ?? 'Nenhum projeto';
    _setState;
  }

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(userMail, project),
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
  final _project;

  const MainDrawer(this._userMail, this._project);

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
                        RoundedContainer(
                          child: Text(_project),
                        ),
                        RoundedContainer(
                          child: Text(_userMail),
                        ),
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
                  child: RoundedContainer(
                    child: Text(
                      'Desconectar',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    color: Colors.lightBlue,
                  )),
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

class RoundedContainer extends StatelessWidget {
  final child;
  final color;

  RoundedContainer({this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [kDefaultShaddow],
      ),
      child: this.child,
    );
  }
}

// TODO  Implement a function to get all the registered users and insert them into the database
