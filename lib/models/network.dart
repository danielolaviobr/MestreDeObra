import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app_fireship/models/file_data.dart';
import 'package:open_file/open_file.dart';

class Network {
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  FileData _fileData;

  String updatedDB;
  String downloadFileMessage;

  get firestoreSnapshots => _firestore.collection('files').snapshots();

  Future<void> updateDatabase() async {
    List _filesStored = [];

// ! The name of every file has to be name_A-project_B.C (being A the file name, B the project and C the file type)
    try {
      await _storage.ref().child('files').listAll().then((value) async {
        var files = value['items'].keys.toList();
        for (var file in files) {
          String _url =
              await _storage.ref().child('files/$file').getDownloadURL();
          String _name = _getFileName(file);
          String _project = _getFileProject(file);
          String _fileType = _getFileType(file);
          String _date = (DateFormat('dd/MM/yyyy kk:mm').format(DateTime.now()))
              .toString();

          Map<String, String> _data = {
            "title": _name,
            "project": _project,
            "downloadUrl": _url,
            "fileType": _fileType,
            "updated": _date,
          };

          _filesStored.add(_data['downloadUrl']);

          if (!(await duplicateCheck(_url))) {
            await _firestore.collection('files').add(_data);
            updatedDB = 'Os arquivos foram atualizados';
          } else {
            updatedDB = 'Arquivos já estão atualizados';
          }
        }
        deleteFileRecord(_filesStored);
      });
    } catch (e) {
      print(e);
    }
  }

// * The following three functions parse the file name so that the database can be fullied accordingly

  String _getFileName(file) {
    int _nameIndex = file.indexOf('name_');
    int _middleIndex = file.indexOf('-');
    return file.substring(_nameIndex + 'name_'.length, _middleIndex);
  }

  String _getFileProject(file) {
    int _projectIndex = file.indexOf('project_');
    int _endIndex = file.indexOf('.');
    return file.substring(_projectIndex + 'project_'.length, _endIndex);
  }

  String _getFileType(file) {
    int _endIndex = file.indexOf('.');
    return file.substring(_endIndex + '.'.length);
  }

// * This functon wueries all the documents in the database and if the download link is already present in one of them it returns true, beacause the url is unique to each file

  Future<bool> duplicateCheck(String filter) async {
    QuerySnapshot result = await _firestore
        .collection('files')
        .where("downloadUrl", isEqualTo: filter)
        .getDocuments();
    return result.documents.length > 0;
  }

// *  This function download the selected file to the download folder

  Future<void> downloadFile() async {
    Dio dio = Dio();
    String _name = _fileData.data['name'];
    String _downloadUrl = _fileData.data['downloadUrl'];
    String _updated = _fileData.data['updated'];
    String _fileType = _fileData.data['fileType'];
    try {
      var downloadDir = await DownloadsPathProvider.downloadsDirectory;
      String _file = '${downloadDir.path}/${_name}_$_updated.$_fileType';
// * Checks if the files exists before downloading it
      if (!(await File(_file).exists())) {
        downloadFileMessage = 'Fazendo download';
        await dio.download(
          _downloadUrl,
          _file,
          onReceiveProgress: (count, total) async {
            if (count == total) {
              await OpenFile.open(_file);
            }
          },
        );
      } else {
        downloadFileMessage = 'Abrindo arquivo';
        await OpenFile.open(_file);
      }
    } catch (e) {
      print(e);
    }
  }

// * Checks if app has permission to access the download folder, if not it asks for it and call the downloadFile function
  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request().then((value) {
        if (status.isGranted) {
          downloadFile();
        }
      });
    } else {
      downloadFile();
    }
  }

  void getFileData(FileData fileData) {
    _fileData = fileData;
  }

  void deleteFileRecord(List _filesStored) async {
    var myCollection = await _firestore.collection('files').getDocuments();
    var documentList = myCollection.documents;
    for (var document in documentList) {
      if (!_filesStored.contains(document.data['downloadUrl'])) {
        await _firestore
            .collection('files')
            .document(document.documentID)
            .delete();
        updatedDB = 'Os arquivos foram atualizados';
      }
    }
  }
// TODO handle when user tries to download file that does not exis anymore;
}
