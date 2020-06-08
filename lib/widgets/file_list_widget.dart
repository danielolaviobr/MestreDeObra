import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app_fireship/main.dart';
import 'package:quiz_app_fireship/models/auth.dart';
import 'package:quiz_app_fireship/models/file_data.dart';
import 'package:quiz_app_fireship/models/files.dart';
import 'package:quiz_app_fireship/widgets/file_card.dart';

class FileSListWidget extends StatefulWidget {
  @override
  _FileSListWidgetState createState() => _FileSListWidgetState();
}

class _FileSListWidgetState extends State<FileSListWidget> {
  Auth auth = Auth();

  @override
  void initState() {
    super.initState();
  }

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
            return FileCard(
              fileData: fileData,
              fileList: fileList,
              index: index,
              network: network,
            );
          },
        );
      },
    );
  }
}
