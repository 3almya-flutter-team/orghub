import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

class FileDownloader extends StatefulWidget {
  final String url;

  const FileDownloader({Key key, this.url}) : super(key: key);
  @override
  _FileDownloaderState createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  // final imgUrl = "http://www.pdf995.com/samples/pdf.pdf";
  final imgUrl = "https://images6.alphacoders.com/683/thumb-1920-683023.jpg";
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  Permission storagePermission = Permission.storage;
  String fileExt;
  static final Random random = Random();
  Directory externalDir;

  @override
  void initState() {
    super.initState();
    setState(() {
      fileExt = widget.url.split(".")[5];
    });
    print("file extention =-=-=> $fileExt");
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    PermissionStatus permissionStatus = await Permission.storage.status;
    // print(checkPermission1);
    if (permissionStatus.isUndetermined ||
        permissionStatus.isDenied ||
        permissionStatus.isRestricted) {
      permissionStatus = await Permission.storage.request();
    }
    if (permissionStatus.isGranted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      var randid = random.nextInt(10000);

      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(widget.url, dirloc + randid.toString() + ".$fileExt",
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress =
                ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        Get.back();
        Toast.show("تم تنزيل الملف بنجاح", context);
        progress = "Download Completed.";
        path = dirloc + randid.toString() + ".$fileExt";
      });

      OpenFile.open(path);
      // Share.share(path);
      // Share.share(File(path));
    } else {
      Get.back();
      setState(() {
        progress = "Permission Denied!";
        // _onPressed = () {
        //   downloadFile();
        // };
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: downloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Downloading File: $progress',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.transparent,
            ));
}

// import 'dart:typed_data';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// downloadFile(String url, {String filename}) async {
//   var httpClient = http.Client();
//   var request = new http.Request('GET', Uri.parse(url));
//   var response = httpClient.send(request);
//   String dir = (await getApplicationDocumentsDirectory()).path;

//   List<List<int>> chunks = new List();
//   int downloaded = 0;

//   response.asStream().listen((http.StreamedResponse r) {
//     r.stream.listen((List<int> chunk) {
//       // Display percentage of completion
//       debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

//       chunks.add(chunk);
//       downloaded += chunk.length;
//     }, onDone: () async {
//       // Display percentage of completion
//       debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

//       print("downloaded dir =-=-=-=> $dir");

//       // Save the file
//       File file = new File('$dir/$filename');
//       final Uint8List bytes = Uint8List(r.contentLength);
//       int offset = 0;
//       for (List<int> chunk in chunks) {
//         bytes.setRange(offset, offset + chunk.length, chunk);
//         offset += chunk.length;
//       }
//       await file.writeAsBytes(bytes);
//       return;
//     });
//   });
// }
