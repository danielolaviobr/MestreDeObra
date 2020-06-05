import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final imgURL =
      'https://stockx.imgix.net/Air-Jordan-1-Retro-High-Off-White-White-Product.jpg?fit=fill&bg=FFFFFF&w=700&h=500&auto=format,compress&q=90&dpr=2&trim=color&updated_at=1538080256';
  bool downloading = false;
  double progress = 0;
  String imgData;
  bool downloadComplete = false;
  var dir;
  Firestore firestore = Firestore.instance;

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      dir = await DownloadsPathProvider.downloadsDirectory;
      await dio.download(
        imgURL,
        '${dir.path}/myimg.jpg',
        onReceiveProgress: (count, total) {
          //print('$count / $total');
          setState(() {
            downloading = true;
            progress = (count / total) * 100;
            //imgData = await File('${dir.path}/myimg.jpg')
            // .readAsString(encoding: ascii);
            // Image.file(File('${dir.path}/myimg.jpg'));
            //print(imgData);
          });
        },
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      downloadComplete = true;
    });
    print('download done');
  }

  void request() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {
      downloadFile();
    }
  }

  void getData() {
    print('try');
    firestore.collection("file").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  @override
  void initState() {
    request();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloading Data'),
      ),
      body: Center(
        child: downloading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 40.0,
                    child: downloadComplete
                        ? Image.file(File('${dir.path}/myimg.jpg'))
                        : Text('No datas'),
                  ),
                  Text(
                    '${progress.toStringAsFixed(0)} %',
                    style: TextStyle(fontSize: 30.0),
                  )
                ],
              )
            : Text('No data'),
      ),
    );
  }
}
