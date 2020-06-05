import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app_fireship/models/file_data.dart';
import 'package:quiz_app_fireship/models/files.dart';
import 'package:quiz_app_fireship/models/network.dart';

void main() {
  runApp(FirebaseApp());
}

Network network = Network();

class FirebaseApp extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FileData>(
      create: (context) => FileData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Mestre de Obra',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
// TODO Implement a loading indicator when the update buttom is pressed
                  await network.updateDatabase();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(network.updatedDB),
                  ));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ],
          ),
          body: FileWidget(),
        ),
      ),
    );
  }
}

class FileWidget extends StatefulWidget {
  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  @override
  Widget build(BuildContext context) {
    final fileData = Provider.of<FileData>(context);
    network.getFileData(fileData);
    return StreamBuilder(
      stream: network.firestoreSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final files = snapshot.data.documents;
        List<Files> fileList = [];
        for (var file in files) {
          var _data = file.data;
          fileList.add(Files(
            title: _data['title'],
            url: _data['downloadUrl'],
            fileType: _data['fileType'],
            updated: _data['updated'],
          ));
        }
        return ListView.builder(
          itemCount: fileList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  var _file = fileList[index];
                  fileData.updateData(
                    _file.url,
                    _file.title,
                    _file.fileType,
                    _file.updated,
                  );
                  print(fileList[index].url);
                  await network.requestPermission();
                  SnackBar snackBar =
                      SnackBar(content: Text(network.downloadFileMessage));
                  Scaffold.of(context).showSnackBar(snackBar);
                },
                child: Container(
                  color: Colors.green,
                  height: 100.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(fileList[index].title),
                      Text(fileList[index].url),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// TODO Create a sing up method using firebase auth (email and google sign in)
// TODO Create a collection in firestore to hold the user permissions to projects
