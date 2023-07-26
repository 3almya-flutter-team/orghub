import 'package:flutter/foundation.dart';

class DownloadFileEvents {}

class FileDownloadEventStart extends DownloadFileEvents {
  String url;
  String path;
  FileDownloadEventStart({
    @required this.url,
    @required this.path,
  });
}
