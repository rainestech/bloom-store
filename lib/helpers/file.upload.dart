
import 'dart:io' as IO;
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getImageFromNetwork(String url) async {
    IO.File file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }

  Future<IO.File> saveImage(String url) async {
    final file = await getImageFromNetwork(url);
    //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());

    Image thumbnail = copyResize(image, width: 120, height: 120);

    // Save the thumbnail as a PNG.
    IO.File savedFile = new IO.File('$path/profile.png')
      ..writeAsBytesSync(encodePng(thumbnail));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImage', savedFile.path);

    return savedFile;
  }

  Future<IO.File> saveFile(File file, String prefKey) async {
    //retrieve local path for device
    var path = await _localPath;
    final fileName = basename(file.path);
    final IO.File localImage = await IO.File(file.path).copy('$path/$fileName');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefKey, localImage.path);

    return localImage;
  }

  Future<void> deleteImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uri = prefs.getString('profileImage') ?? null;

    if (uri != null) {
      IO.File file = IO.File(uri);
      file.delete();

      prefs.remove('profileImage');
    }
  }
}
