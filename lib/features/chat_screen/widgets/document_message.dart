import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:uct_chat/helper/files_helper.dart';
import "package:open_file/open_file.dart";

class DocumentMessage extends StatefulWidget {
  final String url;
  const DocumentMessage({super.key, required this.url});

  @override
  State<DocumentMessage> createState() => _DocumentMessageState();
}

class _DocumentMessageState extends State<DocumentMessage> {
  List<int> bytes = [];
  int? contentLength;
  bool hasLoaded = false;
  double loadingPercentage = 0;
  File? cashedFile;
  bool fileIsOpen = false;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    setSource();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  String get fileExtention {
    String p = Uri.parse(widget.url).path;
    final e = path.extension(p);
    return e;
  }

  Future<void> setSource() async {
    final request = http.Request('GET', Uri.parse(widget.url));
    final http.StreamedResponse response = await http.Client().send(request);
    if (mounted) {
      setState(() {
        contentLength = response.contentLength;
      });
    }
    if (response.statusCode != 200) {
      throw Exception('failed to load records ');
    }
    response.stream.listen((value) {
      for (var i = 0; i < value.length; i++) {
        bytes.add(value[i]);
      }
      if (mounted) {
        setState(() {
          loadingPercentage = (bytes.length / contentLength!);
        });
      }
    }, onDone: () async {
      cashedFile = await FileHelper.saveToDocuments(bytes, fileExtention);
      setState(() {
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasLoaded) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  value: loadingPercentage,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            Center(
                child: Text(
              '${FileHelper.getReadableFileSize(bytes.length)} / ${FileHelper.getReadableFileSize(contentLength ?? 0)}',
            ))
          ],
        ),
      );
    } else {
      // Once the file has loaded, show a widget based on the file type
      switch (fileExtention) {
        case '.pdf':
          // If the file is a PDF, open it when the widget is tapped
          return GestureDetector(
            onTap: () {
              // Open the PDF file
              openFileFolder(cashedFile);
            },
            child: FileInfoWidget(
              fileName: cashedFile!.path.split('/').last,
              fileType: fileExtention,
              fileSize: bytes.length,
            ),
          );
        default:
          // For other file types, show a dialog with a "Show in folder" option
          return GestureDetector(
            onTap: () {
              openFileFolder(cashedFile);
            },
            child: FileInfoWidget(
              fileName: cashedFile!.path.split('/').last,
              fileType: fileExtention,
              fileSize: bytes.length,
            ),
          );
      }
    }
  }

  Future<void> openFileFolder(File? file) async {
    // Open the file with the default app
    fileIsOpen = true;
    await OpenFile.open(file!.path);
    setState(() {
      if (mounted) fileIsOpen = false;
    });
  }
}

class FileInfoWidget extends StatelessWidget {
  final String fileName;
  final String fileType;
  final int fileSize;

  const FileInfoWidget({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8),
        child: Icon(_getIconForFileType(fileType)),
      ),
      title: Text(
        fileName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(fileType),
      trailing: Text(FileHelper.getReadableFileSize(fileSize)),
    );
  }

  IconData _getIconForFileType(String fileType) {
    switch (fileType) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.xls':
      case '.xlsx':
        return Icons.table_chart;
      case '.mp3':
        return Icons.music_note;
      case '.mp4':
        return Icons.movie;
      case '.apk':
        return Icons.android;
      // Add more cases here for other file types
      default:
        return Icons.insert_drive_file;
    }
  }
}
