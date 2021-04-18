part of 'services.dart';

class FileHelper {
  static FileHelper _fileHelper;

  FileHelper._createObject();

  factory FileHelper() {
    if (_fileHelper == null) {
      _fileHelper = FileHelper._createObject();
    }
    return _fileHelper;
  }

  Future<String> get localPath async {
    final directory = await getDatabasesPath();

    return directory;
  }

  Future<File> get databaseFile async {
    final path = await localPath;
    return File('$path/pdil.db');
  }

  deleteDatabaseFile() async {
    final path = await localPath;
    File('$path/pdil.db').delete().then((value) => print("file has been deleted!!!"));
  }
}