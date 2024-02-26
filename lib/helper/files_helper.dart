import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart' as path;

class FileHelper {
  static Future<File> saveToDocuments(List<int> bytes, String ext) async {
    var fileData = Uint8List.fromList(bytes);
    print('------------------ getting file directory');
    Directory tempDir = await path.getTemporaryDirectory();
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    String tempPath = tempDir.path;
    String fileName = '/cashedFile$id$ext';
    print('------------------ trying to save file with name of $fileName');
    String filePath = tempPath + fileName;
    File f = File(filePath);
    print('------------------  writing file to ${f.path}');
    await f.writeAsBytes(fileData);
    print('------------------ success');
    return f;
  }

    static String getReadableFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes bytes';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}
