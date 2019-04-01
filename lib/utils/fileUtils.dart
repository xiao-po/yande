import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileUtils {

  static Future<Directory> getDirAndCreate(String path) async {
    Directory dir = Directory(path);
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

  static Future<List<MyDirectoryStat>> getAllDirectoryChildren(Directory dir) async{
    List<MyDirectoryStat> list = List();
    List dirChildren =await dir.list().toList();
    for (FileSystemEntity entity in dirChildren) {
      FileStat stat =await entity.stat();
      if (stat.type == FileSystemEntityType.directory) {
        list.add(MyDirectoryStat(
            directory: Directory(entity.path),
            name: basename(entity.path),
            path: (entity.path),
          )
        );
      }
    }

    list.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    return list;
  }
}

class MyDirectoryStat {
  Directory directory;
  String name;
  String path;

  MyDirectoryStat({
    this.directory,
    this.name,
    this.path
  }):assert(directory != null),assert(name != null),assert(path != null);
}