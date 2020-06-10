import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app_fireship/main.dart';
import 'package:quiz_app_fireship/models/file_data.dart';
import 'package:quiz_app_fireship/models/files.dart';
import 'package:quiz_app_fireship/widgets/file_card.dart';

class FileSListWidget extends StatefulWidget {
  @override
  _FileSListWidgetState createState() => _FileSListWidgetState();
}

class _FileSListWidgetState extends State<FileSListWidget> {
  List allowed = [];

  dynamic getPermissions() async {
    var permissions =
        await network.queryUserPermissions(auth.currentUserMail());
    if (permissions != null) {
      for (var permission in permissions) {
        allowed.add(permission);
      }
    }
  }

  Widget streamData(AsyncSnapshot snapshot, FileData fileData) {
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

      if (allowed.contains(_data['project'])) {
        network.lastUserView(_data['downloadUrl']);
        fileList.add(Files(
          title: _data['title'],
          url: _data['downloadUrl'],
          fileType: _data['fileType'],
          updated: _data['updated'],
          lastAuthorizedAccess: _data['lastAuthorizedAccess'],
        ));
      }
    }

    if (allowed.length != 0) {
      return ListView.builder(
        itemCount: fileList.length,
        itemBuilder: (context, index) {
          return FileCard(
            fileData: fileData,
            fileList: fileList,
            index: index,
            network: network,
          );
        },
      );
    } else {
      return Center(
        child: Text(
          'Nenhum projeto habilitado',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final fileData = Provider.of<FileData>(context);
    network.getFileData(fileData);
    return StreamBuilder(
      stream: network.firestoreSnapshots,
      builder: (context, snapshot) {
        return streamData(snapshot, fileData);
      },
    );
  }
}
