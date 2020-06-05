import 'package:flutter/material.dart';
import 'package:quiz_app_fireship/constants.dart';
import 'package:quiz_app_fireship/models/network.dart';

class FileCard extends StatelessWidget {
  final imgURL;
  final name;
  final fileType;
  final updated;

  FileCard({this.fileType, this.imgURL, this.name, this.updated});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Network().downloadFile();
      },
      child: Container(
        decoration: BoxDecoration(
          color: kFileCardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            Text(this.name),
            Text(this.updated),
          ],
        ),
      ),
    );
  }
}
