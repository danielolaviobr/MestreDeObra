import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              await auth.logoutUser();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            }),
        automaticallyImplyLeading: false,
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

// TODO Return a message if the user has no permissions in any project
// TODO Check the user permissions to display only the correct files
// TODO Create a Login and Registration screen
// TODO  Implement a function to get all the registered users and insert them into the database
