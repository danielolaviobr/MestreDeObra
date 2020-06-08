import 'package:flutter/material.dart';
import 'package:quiz_app_fireship/constants.dart';

class FileCard extends StatelessWidget {
  final index;
  final fileList;
  final network;
  final fileData;

  const FileCard({this.index, this.fileList, this.network, this.fileData});

  @override
  Widget build(BuildContext context) {
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
          await network.requestPermission().then((value) {
            SnackBar snackBar = SnackBar(content: Text('Abrindo Arquivo'));
            Scaffold.of(context).showSnackBar(snackBar);
          });
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: kFileCardColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [kDefaultShaddow],
          ),
          child: Column(
            children: <Widget>[
              Text(fileList[index].title),
              SizedBox(
                height: 10.0,
              ),
              Text(fileList[index].updated),
            ],
          ),
        ),
      ),
    );
  }
}
