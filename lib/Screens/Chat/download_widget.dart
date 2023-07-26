// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';

// import 'package:after_layout/after_layout.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'downloadFile.dart';

// class DownloadFileWidget extends StatefulWidget {
//   DownloadFileWidget({Key key}) : super(key: key);

//   @override
//   _DownloadFileWidgetState createState() => _DownloadFileWidgetState();
// }

// class _DownloadFileWidgetState extends State<DownloadFileWidget>
//     with AfterLayoutMixin {
//   _TaskInfo _task;
//   _ItemHolder _item;
//   bool _isLoading;
//   bool _permissionReady;
//   String _localPath;
//   ReceivePort _port = ReceivePort();

//   Future<bool> _checkPermission(TargetPlatform platform) async {
//     if (platform == TargetPlatform.android) {
//       PermissionStatus permission = await Permission.storage.status;
//       if (permission != PermissionStatus.granted) {
//         PermissionStatus permissions = await Permission.storage.request();
//         if (permissions == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//     return false;
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _unbindBackgroundIsolate();
//     super.dispose();
//   }

//   Future<Null> _prepare(TargetPlatform platform) async {
//     _permissionReady = await _checkPermission(platform);

//     _localPath =
//         (await _findLocalPath(platform)) + Platform.pathSeparator + 'Download';
//     setState(() {});

//     final savedDir = Directory(_localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<String> _findLocalPath(TargetPlatform platform) async {
//     final directory = platform == TargetPlatform.android
//         ? await getExternalStorageDirectory()
//         : await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   void _bindBackgroundIsolate() {
//     bool isSuccess = IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     if (!isSuccess) {
//       _unbindBackgroundIsolate();
//       _bindBackgroundIsolate();
//       return;
//     }
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];

//       // setState(() {
//       //   _task.status = status;
//       //   _task.progress = progress;
//       // });
//     });
//   }

//   void _unbindBackgroundIsolate() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }

//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     // if (debug) {
//     //   print(
//     //       'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
//     // }
//     final SendPort send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send.send([id, status, progress]);
//   }

//   Widget _buildActionForTask(_TaskInfo task) {
//     if (task.status == DownloadTaskStatus.undefined) {
//       return new RawMaterialButton(
//         onPressed: () {
//           _requestDownload(task);
//         },
//         child: new Icon(Icons.file_download),
//         shape: new CircleBorder(),
//         constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
//       );
//     } else if (task.status == DownloadTaskStatus.running) {
//       return new RawMaterialButton(
//         onPressed: () {
//           _pauseDownload(task);
//         },
//         child: new Icon(
//           Icons.pause,
//           color: Colors.red,
//         ),
//         shape: new CircleBorder(),
//         constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
//       );
//     } else if (task.status == DownloadTaskStatus.paused) {
//       return new RawMaterialButton(
//         onPressed: () {
//           _resumeDownload(task);
//         },
//         child: new Icon(
//           Icons.play_arrow,
//           color: Colors.green,
//         ),
//         shape: new CircleBorder(),
//         constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
//       );
//     } else if (task.status == DownloadTaskStatus.complete) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           new Text(
//             'Ready',
//             style: new TextStyle(color: Colors.green),
//           ),
//           RawMaterialButton(
//             onPressed: () {
//               // _delete(task);
//             },
//             child: Icon(
//               Icons.delete_forever,
//               color: Colors.red,
//             ),
//             shape: new CircleBorder(),
//             constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
//           )
//         ],
//       );
//     } else if (task.status == DownloadTaskStatus.canceled) {
//       return new Text('Canceled', style: new TextStyle(color: Colors.red));
//     } else if (task.status == DownloadTaskStatus.failed) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           new Text('Failed', style: new TextStyle(color: Colors.red)),
//           RawMaterialButton(
//             onPressed: () {
//               _retryDownload(task);
//             },
//             child: Icon(
//               Icons.refresh,
//               color: Colors.green,
//             ),
//             shape: new CircleBorder(),
//             constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
//           )
//         ],
//       );
//     } else {
//       return null;
//     }
//   }

//   void _requestDownload(_TaskInfo task) async {
//     task.taskId = await FlutterDownloader.enqueue(
//         url: task.link,
//         // headers: {"auth": "test_for_sql_encoding"},
//         savedDir: _localPath,
//         showNotification: true,
//         openFileFromNotification: true);
//   }

//   void _cancelDownload(_TaskInfo task) async {
//     await FlutterDownloader.cancel(taskId: task.taskId);
//   }

//   void _pauseDownload(_TaskInfo task) async {
//     await FlutterDownloader.pause(taskId: task.taskId);
//   }

//   void _resumeDownload(_TaskInfo task) async {
//     String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
//     task.taskId = newTaskId;
//   }

//   void _retryDownload(_TaskInfo task) async {
//     String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
//     task.taskId = newTaskId;
//   }

//   // Future<bool> _openDownloadedFile(_TaskInfo task) {
//   //   return FlutterDownloader.open(taskId: task.taskId);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: IconButton(
//             icon: Icon(Icons.file_download),
//             onPressed: () async {
//               //   await FlutterDownloader.enqueue(
//               //     url:
//               //         "https://www.bignerdranch.com/documents/objective-c-prereading-assignment.pdf",
//               //     // headers: {"auth": "test_for_sql_encoding"},
//               //     savedDir: _localPath,
//               //     showNotification: true,
//               //     openFileFromNotification: true,
//               //   );
//               // }),
//               downloadFile(
//                   "https://www.bignerdranch.com/documents/objective-c-prereading-assignment.pdf");
//             }),
//       ),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return new Scaffold(

//   //     body: Builder(
//   //         builder: (context) =>  _permissionReady
//   //                 ? new Container(
//   //                     child: _item.task == null
//   //                         ? new Container(
//   //                             padding: const EdgeInsets.symmetric(
//   //                                 horizontal: 16.0, vertical: 8.0),
//   //                             child: Text(
//   //                               _item.name,
//   //                               style: TextStyle(
//   //                                   fontWeight: FontWeight.bold,
//   //                                   color: Colors.blue,
//   //                                   fontSize: 18.0),
//   //                             ),
//   //                           )
//   //                         : new Container(
//   //                             padding:
//   //                                 const EdgeInsets.only(left: 16.0, right: 8.0),
//   //                             child: InkWell(
//   //                               onTap: _item.task.status ==
//   //                                       DownloadTaskStatus.complete
//   //                                   ? () {
//   //                                       _openDownloadedFile(_item.task)
//   //                                           .then((success) {
//   //                                         if (!success) {
//   //                                           Scaffold.of(context).showSnackBar(
//   //                                               SnackBar(
//   //                                                   content: Text(
//   //                                                       'Cannot open this file')));
//   //                                         }
//   //                                       });
//   //                                     }
//   //                                   : null,
//   //                               child: new Stack(
//   //                                 children: <Widget>[
//   //                                   new Container(
//   //                                     width: double.infinity,
//   //                                     height: 64.0,
//   //                                     child: new Row(
//   //                                       crossAxisAlignment:
//   //                                           CrossAxisAlignment.center,
//   //                                       children: <Widget>[
//   //                                         new Expanded(
//   //                                           child: new Text(
//   //                                             _item.name,
//   //                                             maxLines: 1,
//   //                                             softWrap: true,
//   //                                             overflow: TextOverflow.ellipsis,
//   //                                           ),
//   //                                         ),
//   //                                         new Padding(
//   //                                           padding: const EdgeInsets.only(
//   //                                               left: 8.0),
//   //                                           child:
//   //                                               _buildActionForTask(_item.task),
//   //                                         ),
//   //                                       ],
//   //                                     ),
//   //                                   ),
//   //                                   _item.task.status ==
//   //                                               DownloadTaskStatus.running ||
//   //                                           _item.task.status ==
//   //                                               DownloadTaskStatus.paused
//   //                                       ? new Positioned(
//   //                                           left: 0.0,
//   //                                           right: 0.0,
//   //                                           bottom: 0.0,
//   //                                           child: new LinearProgressIndicator(
//   //                                             value: _item.task.progress / 100,
//   //                                           ),
//   //                                         )
//   //                                       : new Container()
//   //                                 ].where((child) => child != null).toList(),
//   //                               ),
//   //                             ),
//   //                           ),
//   //                   )
//   //                 : new Container(
//   //                     child: Center(
//   //                       child: Column(
//   //                         mainAxisSize: MainAxisSize.min,
//   //                         crossAxisAlignment: CrossAxisAlignment.center,
//   //                         children: [
//   //                           Padding(
//   //                             padding:
//   //                                 const EdgeInsets.symmetric(horizontal: 24.0),
//   //                             child: Text(
//   //                               'Please grant accessing storage permission to continue -_-',
//   //                               textAlign: TextAlign.center,
//   //                               style: TextStyle(
//   //                                   color: Colors.blueGrey, fontSize: 18.0),
//   //                             ),
//   //                           ),
//   //                           SizedBox(
//   //                             height: 32.0,
//   //                           ),
//   //                           FlatButton(
//   //                               onPressed: () {
//   //                                 final platform = Theme.of(context).platform;
//   //                                 _checkPermission(platform).then((hasGranted) {
//   //                                   setState(() {
//   //                                     _permissionReady = hasGranted;
//   //                                   });
//   //                                 });
//   //                               },
//   //                               child: Text(
//   //                                 'Retry',
//   //                                 style: TextStyle(
//   //                                     color: Colors.blue,
//   //                                     fontWeight: FontWeight.bold,
//   //                                     fontSize: 20.0),
//   //                               ))
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   )),
//   //   );
//   // }

//   @override
//   void afterFirstLayout(BuildContext context) {
//     final platform = Theme.of(context).platform;
//     setState(() {
//       _item = _ItemHolder(
//         name: "firstFile",
//         task: _TaskInfo(
//           name: "Objective-C Programming (Pre-Course Workbook",
//           link:
//               "https://www.bignerdranch.com/documents/objective-c-prereading-assignment.pdf",
//         ),
//       );
//     });

//     _bindBackgroundIsolate();

//     FlutterDownloader.registerCallback(downloadCallback);

//     _isLoading = true;
//     _permissionReady = false;

//     _prepare(platform);
//   }
// }

// class _TaskInfo {
//   final String name;
//   final String link;

//   String taskId;
//   int progress = 0;
//   DownloadTaskStatus status = DownloadTaskStatus.undefined;

//   _TaskInfo({this.name, this.link});
// }

// class _ItemHolder {
//   final String name;
//   final _TaskInfo task;

//   _ItemHolder({this.name, this.task});
// }
