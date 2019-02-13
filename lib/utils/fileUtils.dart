import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FileUtils {

  static Future<Directory> getDirAndCreate(String path) async {
    Directory dir = new Directory(path);
    bool isDirExist = await dir.exists();
    if (!isDirExist) {
      await dir.create();
    }
    return dir;
  }


  static Future<Directory> getExternalDir() async {
    String myPath = '/Android/data/com.example.yande';
    Directory dir = await getExternalStorageDirectory();
    return await getDirAndCreate('${dir.path}$myPath');
  }
  static Future<Directory> getExternalDatabaseDir() async {
    Directory dir = await getExternalDir();
    return await getDirAndCreate('${dir.path}/databases');
  }

  static Future<List<Directory>> getAllDirectoryChildren(Directory dir) async{
    List<Directory> list = new List();
    List dirChildren =await dir.list().toList();
    for (FileSystemEntity entity in dirChildren) {
      FileStat stat =await entity.stat();
      if (stat.type == FileSystemEntityType.directory) {
        list.add(new Directory(entity.path));
      }
    }

    return list;
  }
}