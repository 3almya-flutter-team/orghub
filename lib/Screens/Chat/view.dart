import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart'as dio;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:laravel_echo/laravel_echo.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_globals.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Screens/Chat/ChatBloc/bloc.dart';
import 'package:orghub/Screens/Chat/ChatBloc/events.dart';
import 'package:orghub/Screens/Chat/ChatBloc/model.dart';
import 'package:orghub/Screens/Chat/ChatBloc/states.dart';
import 'package:orghub/Screens/Chat/DownloadFileBloc/bloc.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/bloc.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/events.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';
// import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/states.dart';
import 'package:orghub/Screens/Chat/Widgets/audio_player.dart';
import 'package:orghub/Screens/Chat/Widgets/display_image_widget.dart';
import 'package:orghub/Screens/Chat/downloadFile.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/floating_modal.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:orghub/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart' as play;
import 'package:kiwi/kiwi.dart' as kiwi;

// import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Widgets/bubble.dart';

class ChatScreen extends StatefulWidget {
  final int receiverId;
  final int chatId;
  final String receiverName;
  ChatScreen({Key key, this.receiverId, this.receiverName, this.chatId})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TextEditingController msgController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  AnimationController _controller;
  AnimationController _opacityController;
  AnimationController _opacity2Controller;

  Animation<int> _animation;

  GetSingleChatBloc getSingleChatBloc =
      kiwi.KiwiContainer().resolve<GetSingleChatBloc>();
  SendMessageBloc sendMessageBloc =
      kiwi.KiwiContainer().resolve<SendMessageBloc>();
  DownloadFileBloc downloadFileBloc =
      kiwi.KiwiContainer().resolve<DownloadFileBloc>();

  bool show = false;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool _isRecording = false;
  String audioDuration = "00:00:00";

  // List<Map<String, dynamic>> allPlayers = [];
  // List<AudioPlayer> allPlayers = [];
  // Map<String, dynamic> currentAudioPlayer;
  // AudioPlayer currentAudioPlayer;

  LocalFileSystem localFileSystem;

  // Create echo instance
  Echo echo;

  int myId;

  // IO.Socket socket;

  @override
  void initState() {
    // if (io.Platform.isAndroid) {
    HttpOverrides.global = new MyHttpOverrides();
    // }

    Prefs.getIntF("userId").then((value) {
      setState(() {
        myId = value;
      });
    });

    if (io.Platform.isIOS) {
      Prefs.getStringF("authToken").then((value) {
        print("=-=-=> token xxxxxxxxxxxxxxxx =-=-=> $value");
        echo = new Echo({
          'broadcaster': 'socket.io',
          'client': IO.io,
          'auth': {
            'headers': {'Authorization': 'Bearer $value'}
          },
          // "host": "https://orghub.store:6010",
          "host": "https://org.taha.rmal.com.sa:6010",
        });

        echo.socket.on('connect', (_) {
          print(
              '][-0-0-0-0-0-0-0-0-0- echo echo echo echo ][][][][][][=-=-=-=> connect');
        });

        if (widget.chatId == null) {
          getSingleChatBloc
              .getAllMessages(receiverId: widget.receiverId)
              .then((response) {
            SingleChatModel allChatsModel =
                SingleChatModel.fromJson(response.response.data);
            print("chat id =-=-=-> ${allChatsModel.chatId}");
            echo
                .private('org-chat.${allChatsModel.chatId}')
                .listen('Chat.ChatEvent', (e) {
              SendMessageData sendMessageData = SendMessageData.fromJson(e);
              print("from socket -=-=> $e");
              getSingleChatBloc.add(
                GetSingleChatEventsUpdated(mssage: sendMessageData),
              );
            });
          });
        } else {
          print("chat id =-=-=-> ${widget.chatId}");
          echo.private('org-chat.${widget.chatId}').listen('Chat.ChatEvent',
              (e) {
            SendMessageData sendMessageData = SendMessageData.fromJson(e);
            print("from socket -=-=> $e");
            getSingleChatBloc.add(
              GetSingleChatEventsUpdated(mssage: sendMessageData),
            );
          });
        }
      });
      print("socket -=-=-=> ");
    } else {
      if (widget.chatId == null) {
        getSingleChatBloc
            .getAllMessages(receiverId: widget.receiverId)
            .then((response) {
          SingleChatModel allChatsModel =
              SingleChatModel.fromJson(response.response.data);
          print("chat id =-=-=-> ${allChatsModel.chatId}");
          // echo
          //     .private('org-chat.${allChatsModel.chatId}')
          //     .listen('Chat.ChatEvent', (e) {
          //   SendMessageData sendMessageData = SendMessageData.fromJson(e);
          //   print("from socket -=-=> $e");
          //   getSingleChatBloc.add(
          //     GetSingleChatEventsUpdated(mssage: sendMessageData),
          //   );
          // });
        });
      } else {
        // print("chat id =-=-=-> ${widget.chatId}");
        // echo.private('org-chat.${widget.chatId}').listen('Chat.ChatEvent',
        //     (e) {
        //   SendMessageData sendMessageData = SendMessageData.fromJson(e);
        //   print("from socket -=-=> $e");
        //   getSingleChatBloc.add(
        //     GetSingleChatEventsUpdated(mssage: sendMessageData),
        //   );
        // });
      }

      getIt.get<AppGlobals>().controller.stream.listen((event) {
        print(
            "=-=-=- from stream ya kjkjkjjk 00909090909009090 ${event.toJson().toString()}");
        getSingleChatBloc.add(
          GetSingleChatEventsUpdated(mssage: event),
        );
      });
    }

    getSingleChatBloc.add(
      GetSingleChatEventsStart(
        receiverId: widget.receiverId,
      ),
    );

    localFileSystem = LocalFileSystem();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacity2Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = new IntTween(begin: 0, end: 45).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // AudioPlayer.setIosCategory(IosCategory.playback);

    super.initState();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 90000000000,
      // _scrollController.position.maxScrollExtent ,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _scrollToEndIos() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 600,
      // _scrollController.position.maxScrollExtent ,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.AAC);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Get.snackbar("Error", "You must accept permissions");
        // Scaffold.of(context).showSnackBar(
        //     new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  void onPlayAudio() async {
    play.AudioPlayer playRecorder = play.AudioPlayer();
    await playRecorder.play(_current.path, isLocal: true);
  }

  _start(StateSetter rebuild) async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      rebuild(() {
        _isRecording = true;
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          // rebuild(() {
          //   _isRecording = false;
          // });
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);

        rebuild(() {
          _current = current;
          _currentStatus = _current.status;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              current.duration.inMilliseconds,
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          audioDuration = txt.substring(0, 8);
        });
      });
    } catch (e) {
      // rebuild(() {
      //   _isRecording = false;
      // });
      print(e);
    }
  }

  _stop(StateSetter rebuild) async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    rebuild(() {
      // _isRecording = false;
      _current = result;
      _currentStatus = _current.status;
    });
  }

  void _sendVoiceToServer({BuildContext context}) async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    // rebuild(() {
    //   _isRecording = false;
    //   _current = result;
    //   _currentStatus = _current.status;
    // });

    sendMessageBloc.add(
      SendMessageEventsStart(
          receiverId: widget.receiverId,
          message: dio.MultipartFile.fromFileSync(
            file.path,
            filename: basename(file.path),
          ),
          messageType: "sound"),
    );
  }

  io.File _image;
  final picker = ImagePicker();

  Future _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = io.File(pickedFile.path);
        Navigator.of(context).pop();

        imagePreview(context: context, image: _image);
      });
    }
  }

  void _imagePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(
                translator.currentLanguage == 'en' ? "Cancel" : "الغاء",
                style: TextStyle(
                  fontFamily: "Neosans",
                  color: AppTheme.primaryColor,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.photo_camera_solid,
                      color: Color(getColorHexFromStr("#2c6468")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      translator.currentLanguage == 'en'
                          ? "Camera"
                          : "الكاميرا",
                      style: TextStyle(
                        fontFamily: "Neosans",
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.camera),
              ),
              CupertinoButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.insert_photo,
                      color: Color(getColorHexFromStr("#2c6468")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      translator.currentLanguage == 'en'
                          ? "Gallery"
                          : "الاستوديو",
                      style: TextStyle(
                        fontFamily: "Neosans",
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _getImage(context, ImageSource.gallery),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    getSingleChatBloc.close();
    _controller.dispose();
    _opacityController.dispose();
    _opacity2Controller.dispose();
    sendMessageBloc.close();
    downloadFileBloc.close();
    _recorder.stop();
    // closeAllPlayers();
    super.dispose();
  }

  // void closeAllPlayers() {
  //   if (allPlayers.isNotEmpty) {
  //     allPlayers.forEach((player) {
  //       player.dispose();
  //     });
  //   }
  // }

  Widget me(
      {BuildContext context,
      String userImage,
      String type,
      String msg,
      String time}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            // color: Colors.blueAccent,/
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                userImage ??
                    "https://cdn.pixabay.com/photo/2018/03/12/12/32/woman-3219507_1280.jpg",
              ),
            ),
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: 60,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(
                    getColorHexFromStr("#F8F8F8"),
                  ),
                ),
                child: () {
                  if (type == 'text') {
                    print("here =-=-=");
                    return textMsg(msg: msg);
                  } else if (type == 'image') {
                    return DisplayImageWidget(imageUrl: msg);
                    // return FadeInImage.assetNetwork(
                    //   image: msg,
                    //   placeholder:
                    //       "assets/icons/review_image.png", // your assets image path
                    //   fit: BoxFit.cover,
                    // );
                    // return Image.network(
                    //   msg,
                    //   fit: BoxFit.cover,
                    // );
                  } else if (type == 'file') {
                    return fileMsg(msg: msg, context: context);
                  } else {
                    // return textMsg(msg: msg);
                    // print("audio =-=-= CURRENT AUDIO PLAYER => $msg");
                    // AudioPlayer player = AudioPlayer();

                    // allPlayers.add(player);
                    // currentAudioPlayer = player;

                    // print("=-=-==-= allPlayers $allPlayers");
                    // initPlayer(player: player, audioUrl: msg);
                    // return audioMsg(player: player);
                    return AudioPlayerWidget(audio: msg);
                  }
                }(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 8),
                child: Text(
                  time ?? "",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(getColorHexFromStr("#C0C0C0")),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget textMsg({String msg}) {
    return Text(
      msg ?? "",
      style: TextStyle(
        fontSize: 12,
        color: Color(
          getColorHexFromStr("#787878"),
        ),
      ),
    );
  }

  Widget imageMsg({String msg}) {
    return null;
  }

  // Future<String> _findLocalPath(BuildContext context) async {
  //   final directory = Theme.of(context).platform == TargetPlatform.android
  //       ? await getExternalStorageDirectory()
  //       : await getApplicationDocumentsDirectory();
  //   print("=-=-=> ${directory.path}");
  //   return directory.path;
  // }

  // void showDownloadProgress(received, total) {
  //   if (total != -1) {
  //     print((received / total * 100).toStringAsFixed(0) + "%");
  //   }
  // }

  // void downloadFileDialog({BuildContext context, String url}) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: 400,
  //           width: double.infinity,
  //           color: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 30),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 BlocConsumer(
  //                   bloc: downloadFileBloc,
  //                   builder: (context, state) {
  //                     if (state is FileDownloadStatesStart)
  //                       return Padding(
  //                         padding: const EdgeInsets.all(4.0),
  //                         child: CupertinoActivityIndicator(
  //                           animating: true,
  //                           radius: 13,
  //                         ),
  //                       );
  //                     else {
  //                       return InkWell(
  //                         onTap: () async {
  //                           // Get.to(FileDownloader());
  //                           // downloadFile(
  //                           //     "https://www.bignerdranch.com/documents/objective-c-prereading-assignment.pdf");
  //                           // downloadFileBloc.add(
  //                           //   FileDownloadEventStart(
  //                           //       url: url,
  //                           //       path:
  //                           //           "$filePath/${url.split("-")[url.split("-").length - 1]}"),
  //                           // );
  //                         },
  //                         // child: Icon(
  //                         //   Icons.cloud_download,
  //                         //   color: AppTheme.primaryColor,
  //                         // ),
  //                         child: FileDownloader(),
  //                       );
  //                     }
  //                   },
  //                   listener: (context, state) {
  //                     if (state is FileDownloadStatesSuccess) {
  //                     } else if (state is FileDownloadStatesFailed) {
  //                       _handleError(state: state, context: context);
  //                     }
  //                   },
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("${url.split("-")[url.split("-").length - 1]}"),
  //                     SizedBox(
  //                       width: 10,
  //                     ),
  //                     Image.asset(
  //                       "assets/icons/file.png",
  //                       width: 30,
  //                       height: 30,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  // final imgUrl = "https://images6.alphacoders.com/683/thumb-1920-683023.jpg";
  // bool downloading = false;
  // var progress = "";
  // var path = "No Data";
  // var platformVersion = "Unknown";
  // Permission storagePermission = Permission.storage;
  // var _onPressed;
  // static final Random random = Random();
  // Directory externalDir;

  // Future<void> downloadFile() async {
  //   Dio dio = Dio();

  //   PermissionStatus permissionStatus = await Permission.storage.status;
  //   // print(checkPermission1);
  //   if (permissionStatus.isUndetermined ||
  //       permissionStatus.isDenied ||
  //       permissionStatus.isRestricted) {
  //     permissionStatus = await Permission.storage.request();
  //   }
  //   if (permissionStatus.isGranted) {
  //     String dirloc = "";
  //     if (Platform.isAndroid) {
  //       dirloc = "/sdcard/download/";
  //     } else {
  //       dirloc = (await getApplicationDocumentsDirectory()).path;
  //     }

  //     var randid = random.nextInt(10000);

  //     try {
  //       FileUtils.mkdir([dirloc]);
  //       await dio.download(imgUrl, dirloc + randid.toString() + ".jpg",
  //           onReceiveProgress: (receivedBytes, totalBytes) {
  //         setState(() {
  //           downloading = true;
  //           progress =
  //               ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
  //         });
  //       });
  //     } catch (e) {
  //       print(e);
  //     }

  //     setState(() {
  //       downloading = false;
  //       progress = "Download Completed.";
  //       path = dirloc + randid.toString() + ".jpg";
  //     });
  //   } else {
  //     setState(() {
  //       progress = "Permission Denied!";
  //       _onPressed = () {
  //         downloadFile();
  //       };
  //     });
  //   }
  // }

  void downloadFileDialog({BuildContext context, String fileUrl}) {
    showFloatingModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context, scrollController) => Container(
          color: Colors.transparent,
          height: 200,
          width: MediaQuery.of(context).size.width / 2,
          child: FileDownloader(
            url: fileUrl,
          )),
    );
  }

  Widget fileMsg({String msg, BuildContext context}) {
    print(msg.split("/")[msg.split("/").length - 1]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              downloadFileDialog(context: context, fileUrl: msg);
            },
            child: Icon(
              Icons.cloud_download,
              color: AppTheme.primaryColor,
            ),
          ),
          Row(
            children: [
              // Text(""),
              Text("${msg.split("___file_")[1]}"),
              // Text("${msg.split("/")[msg.split("/").length - 1].split("___file_")[1]}"),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/icons/file.png",
                width: 30,
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void openAudioRecoderBottomSheet({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, rebuild) {
              return Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                onPlayAudio();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  translator.currentLanguage == 'en'
                                      ? "Recording a voice "
                                      : "تسجيل مقطع صوتى",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.secondary2Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          audioDuration ?? "",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 30,
                          ),
                        ),
                        _isRecording
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _stop(rebuild);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height: 50,
                                      margin: EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Center(
                                        child: Text(
                                          translator.currentLanguage == 'en'
                                              ? "Cancel"
                                              : "انهاء",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  BlocConsumer(
                                    bloc: sendMessageBloc,
                                    builder: (context, state) {
                                      if (state is SendMessageStatesStart)
                                        return CupertinoActivityIndicator(
                                          animating: true,
                                          radius: 13,
                                        );
                                      else {
                                        return InkWell(
                                          onTap: () {
                                            _sendVoiceToServer(
                                                context: context);
                                            // Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            height: 50,
                                            margin: EdgeInsets.all(9),
                                            decoration: BoxDecoration(
                                              color: CupertinoColors.activeBlue,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                translator.currentLanguage ==
                                                        'en'
                                                    ? "Send"
                                                    : "ارسال",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    listener: (context, state) {
                                      if (state is SendMessageStatesSuccess) {
                                        // get all messages or add new message to messages list
                                        msgController.text = "";
                                        // getSingleChatBloc.add(
                                        //   GetSingleChatEventsUpdated(
                                        //       mssage: state.message.data),
                                        // );

                                        if (io.Platform.isAndroid) {
                                          getSingleChatBloc.add(
                                            GetSingleChatEventsUpdated(
                                                mssage: state.message.data),
                                          );
                                        }

                                        _isRecording = false;
                                        audioDuration = "00:00:00";

                                        Navigator.of(context).pop();
                                        // _scrollToEnd();
                                        // FlashHelper.successBar(context, message: "ok");
                                      } else if (state
                                          is SendMessageStatesFailed) {
                                        _handleError(
                                            state: state, context: context);
                                      }
                                    },
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  _start(rebuild);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  margin: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Center(
                                    child: Text(
                                      translator.currentLanguage == 'en'
                                          ? "Record"
                                          : "تسجيل",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          if (_recorder != null) {
                            _recorder.stop();
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: CupertinoColors.systemGrey6,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  // void initPlayer({AudioPlayer player, String audioUrl}) {
  //   player
  //       .setUrl(audioUrl ??
  //           "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3")
  //       .catchError((error) {
  //     // catch audio error ex: 404 url, wrong url ...
  //     print(error);
  //   });
  // }

  // Widget audioMsg({AudioPlayer player}) {
  //   return StreamBuilder<FullAudioPlaybackState>(
  //     stream: player.fullPlaybackStateStream,
  //     builder: (context, snapshot) {
  //       final fullState = snapshot.data;
  //       final state = fullState?.state;
  //       final buffering = fullState?.buffering;
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 4),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: StreamBuilder<Duration>(
  //                 stream: player.durationStream,
  //                 builder: (context, snapshot) {
  //                   final duration = snapshot.data ?? Duration.zero;
  //                   return StreamBuilder<Duration>(
  //                     stream: player.getPositionStream(),
  //                     builder: (context, snapshot) {
  //                       var position = snapshot.data ?? Duration.zero;
  //                       if (position > duration) {
  //                         position = duration;
  //                       }
  //                       return SeekBar(
  //                         duration: duration,
  //                         position: position,
  //                         onChangeEnd: (newPosition) {
  //                           player.seek(newPosition);
  //                         },
  //                       );
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),

  //             if (state == AudioPlaybackState.connecting || buffering == true)
  //               Padding(
  //                 padding: const EdgeInsets.all(3.0),
  //                 child: CupertinoActivityIndicator(
  //                   animating: true,
  //                   radius: 8,
  //                 ),
  //               )
  //             else if (state == AudioPlaybackState.playing)
  //               InkWell(
  //                 onTap: player.stop,
  //                 child: Container(
  //                   width: 35,
  //                   height: 35,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: AppTheme.primaryColor,
  //                     ),
  //                     borderRadius: BorderRadius.circular(30),
  //                   ),
  //                   child: Center(
  //                       child: Icon(
  //                     CupertinoIcons.pause_solid,
  //                     size: 20,
  //                     color: AppTheme.primaryColor,
  //                   )),
  //                 ),
  //               )
  //             else
  //               InkWell(
  //                 // onTap: player.play,
  //                 onTap: () {
  //                   // closeOtherPlayers(currentPlayer: player);
  //                   // print(allPlayers);
  //                   player.play();
  //                 },
  //                 child: Container(
  //                   width: 35,
  //                   height: 35,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: AppTheme.primaryColor,
  //                     ),
  //                     borderRadius: BorderRadius.circular(30),
  //                   ),
  //                   child: Center(
  //                     child: Icon(
  //                       CupertinoIcons.play_arrow_solid,
  //                       size: 20,
  //                       color: AppTheme.primaryColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             // IconButton(
  //             //   icon: Icon(Icons.stop),
  //             //   iconSize: 64.0,
  //             //   onPressed: state == AudioPlaybackState.stopped ||
  //             //           state == AudioPlaybackState.none
  //             //       ? null
  //             //       : player.stop,
  //             // ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget other(
      {BuildContext context,
      String userImage,
      String type,
      String msg,
      String time}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 60,
                ),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(
                    getColorHexFromStr("#F8F8F8"),
                  ),
                ),
                child: () {
                  if (type == 'text') {
                    print("here =-=-=");
                    return textMsg(msg: msg);
                  } else if (type == 'image') {
                    return DisplayImageWidget(imageUrl: msg);
                  } else if (type == 'file') {
                    return fileMsg(msg: msg, context: context);
                  } else {
                    return AudioPlayerWidget(
                      audio: msg,
                    );
                  }
                }(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 8),
                child: Text(
                  time ?? "",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(getColorHexFromStr("#C0C0C0")),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                userImage ??
                    "https://cdn.pixabay.com/photo/2015/01/06/16/14/woman-590490_1280.jpg",
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _sendMessage({BuildContext context}) {
    BlocProvider.of<SendMessageBloc>(context).add(
      SendMessageEventsStart(
          receiverId: widget.receiverId,
          message: msgController.text,
          messageType: "text"),
    );
  }

  void _handleError({BuildContext context, dynamic state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      // error from server
      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  void imagePreview({BuildContext context, io.File image}) {
    showFloatingModalBottomSheet(
      context: context,
      builder: (context, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(translator.currentLanguage == 'en'
                ? "Preview Image"
                : "عرض الصوره"),
          ),
          Image.file(
            image,
            height: MediaQuery.of(context).size.height / 3,
          ),
          BlocConsumer(
            bloc: sendMessageBloc,
            builder: (context, state) {
              if (state is SendMessageStatesStart)
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SpinKitWave(
                    size: 17,
                    color: AppTheme.primaryColor,
                  ),
                );
              else {
                return FlatButton(
                  onPressed: () {
                    sendMessageBloc.add(SendMessageEventsStart(
                        message: dio.MultipartFile.fromFileSync(
                          image.path,
                          filename: basename(
                            image.path,
                          ),
                        ),
                        messageType: "image",
                        receiverId: widget.receiverId));
                  },
                  child: Text(
                    translator.currentLanguage == 'en' ? "Send" : "ارسال",
                    style: TextStyle(
                      fontFamily: "Neosans",
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is SendMessageStatesSuccess) {
                // get all messages or add new message to messages list
                msgController.text = "";
                // getSingleChatBloc.add(
                //   GetSingleChatEventsUpdated(mssage: state.message.data),
                // );

                if (io.Platform.isAndroid) {
                  getSingleChatBloc.add(
                    GetSingleChatEventsUpdated(mssage: state.message.data),
                  );
                }
                Navigator.of(context).pop();
                // _scrollToEnd();
                // FlashHelper.successBar(context, message: "ok");
              } else if (state is SendMessageStatesFailed) {
                _handleError(state: state, context: context);
              }
            },
          ),
        ],
      ),
    );
  }

  void filePreview({BuildContext context, io.File file}) {
    showFloatingModalBottomSheet(
      context: context,
      builder: (context, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("عرض الملف"),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  basename(file.path),
                ),
                SizedBox(
                  width: 30,
                ),
                Image.asset(
                  "assets/icons/file.png",
                  width: 30,
                  height: 30,
                ),
              ],
            ),
          ),
          BlocConsumer(
            bloc: sendMessageBloc,
            builder: (context, state) {
              if (state is SendMessageStatesStart)
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SpinKitWave(
                    size: 17,
                    color: AppTheme.primaryColor,
                  ),
                );
              else {
                return FlatButton(
                  onPressed: () {
                    sendMessageBloc.add(SendMessageEventsStart(
                        message: dio.MultipartFile.fromFileSync(
                          file.path,
                          filename: basename(
                            file.path,
                          ),
                        ),
                        messageType: "file",
                        receiverId: widget.receiverId));
                  },
                  child: Text(
                    "ارسال",
                    style: TextStyle(
                      fontFamily: "Neosans",
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is SendMessageStatesSuccess) {
                // get all messages or add new message to messages list
                msgController.text = "";

                if (io.Platform.isAndroid) {
                  getSingleChatBloc.add(
                    GetSingleChatEventsUpdated(mssage: state.message.data),
                  );
                }

                Navigator.of(context).pop();
                // _scrollToEnd();
                // FlashHelper.successBar(context, message: "ok");
              } else if (state is SendMessageStatesFailed) {
                _handleError(state: state, context: context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    // _scrollToEnd();
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "${widget.receiverName}",
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 15,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        floatingActionButtonLocation: translator.currentLanguage == "en"
            ? FloatingActionButtonLocation.endDocked
            : FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            right: translator.currentLanguage == "en"
                ? MediaQuery.of(context).size.width - 80
                : 13,
            bottom: 10,
          ),
          child: SpeedDial(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: RotationTransition(
              turns: new AlwaysStoppedAnimation(_animation.value / 360),
              child: Image.asset(
                "assets/icons/attach.png",
                width: 25,
                height: 25,
              ),
            ),
            closeManually: false,
            curve: Curves.bounceIn,
            overlayOpacity: 0.5,
            onOpen: () {
              _controller.forward();
            },
            onClose: () {
              _controller.reverse();
            },
            children: [
              SpeedDialChild(
                elevation: 0,
                onTap: () {
                  _imagePicker(context);
                },
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 13, bottom: 10, top: 8),
                  child: Image.asset(
                    "assets/icons/metro.png",
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
              SpeedDialChild(
                elevation: 0,
                onTap: () async {
                  io.File file = await FilePicker.getFile();
                  filePreview(context: context, file: file);
                },
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 13, bottom: 10, top: 8),
                  child: Image.asset(
                    "assets/icons/file.png",
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
              SpeedDialChild(
                onTap: () {
                  _isRecording = false;
                  audioDuration = "00:00:00";
                  _init();
                  openAudioRecoderBottomSheet(context: context);
                },
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 13, bottom: 10, top: 8),
                  child: Image.asset(
                    "assets/icons/mic.png",
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              BlocConsumer(
                bloc: getSingleChatBloc,
                builder: (context, state) {
                  if (state is GetSingleChatStatesStart) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    );
                  } else if (state is GetSingleChatStatesSucess) {
                    print("=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
                    return Column(
                      children: [
                        Expanded(
                          child: state.messages.isEmpty
                              ? Center(
                                  child: Text(translator.currentLanguage == "en"
                                      ? "Empty"
                                      : "لايوجد"),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  itemCount: state.messages.length,
                                  itemBuilder: (context, index) {
                                    if (index == (state.messages.length - 1)) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 100),
                                        child: Bubble(
                                          elevation: 0,
                                          stick: false,
                                          padding: BubbleEdges.all(3),
                                          margin: BubbleEdges.all(3),
                                          child: () {
                                            if (state.messages[index]
                                                    .messageSender ==
                                                myId) {
                                              return me(
                                                context: context,
                                                userImage: state.messages[index]
                                                    .senderData.image,
                                                msg: state
                                                    .messages[index].message,
                                                time: state
                                                    .messages[index].createdAt,
                                                type: state.messages[index]
                                                    .messageType,
                                              );
                                            } else {
                                              return other(
                                                context: context,
                                                userImage: state.messages[index]
                                                    .senderData.image,
                                                msg: state
                                                    .messages[index].message,
                                                time: state
                                                    .messages[index].createdAt,
                                                type: state.messages[index]
                                                    .messageType,
                                              );
                                            }
                                          }(),
                                        ),
                                      );
                                    } else {
                                      return Bubble(
                                        elevation: 0,
                                        stick: false,
                                        padding: BubbleEdges.all(3),
                                        margin: BubbleEdges.all(3),
                                        child: () {
                                          if (state.messages[index]
                                                  .messageSender ==
                                              myId) {
                                            return me(
                                              context: context,
                                              userImage: state.messages[index]
                                                  .senderData.image,
                                              msg:
                                                  state.messages[index].message,
                                              time: state
                                                  .messages[index].createdAt,
                                              type: state
                                                  .messages[index].messageType,
                                            );
                                          } else {
                                            return other(
                                              context: context,
                                              userImage: state.messages[index]
                                                  .senderData.image,
                                              msg:
                                                  state.messages[index].message,
                                              time: state
                                                  .messages[index].createdAt,
                                              type: state
                                                  .messages[index].messageType,
                                            );
                                          }
                                        }(),
                                      );
                                    }
                                  }),
                        ),
                      ],
                    );
                  } else if (state is GetSingleChatStatesFailed) {
                    if (state.errType == 0) {
                      // FlashHelper.errorBar(context,
                      //     message: "برجاء التاكد من الاتصال بالانترنت ");
                      return noInternetWidget(context);
                    } else {
                      // FlashHelper.errorBar(context, message: state.msg ?? "");
                      return errorWidget(context, state.msg ?? "",state.statusCode);
                    }
                  } else {
                    // FlashHelper.errorBar(context, message: state.msg ?? "");
                    return Container();
                  }
                },
                listener: (BuildContext context, state) {
                  if (state is GetSingleChatStatesSucess) {
                    print("=-=-=-> i am here ya scroll");
                    Future.delayed(Duration(seconds: 2), () {
                      print("=-=-=-> i am here ya scroll");

                      if (io.Platform.isIOS) {
                        _scrollToEndIos();
                      } else {
                        _scrollToEnd();
                      }
                    });
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 3, left: 3, bottom: 6),
                          child: TextField(
                            controller: msgController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                color: Colors.red,
                                fontSize: 13,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, top: 15, bottom: 15, right: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: AppTheme.filledColor,
                              enabled: true,
                              hintText: translator.currentLanguage == "en"
                                  ? "Write your message here .."
                                  : "اكتب رسالتك  هنا",
                              hintStyle: TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      BlocConsumer<SendMessageBloc, SendMessageStates>(
                        builder: (context, state) {
                          if (state is SendMessageStatesStart) {
                            return Container(
                              width: 40,
                              height: 42,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.5),
                                    blurRadius: 9.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      5.0, // Move to right 10  horizontally
                                      5.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SpinKitCircle(
                                color: Colors.white,
                                size: 30.0,
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                _sendMessage(context: context);
                              },
                              child: Container(
                                width: 40,
                                height: 42,
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      blurRadius: 9.0, // soften the shadow
                                      spreadRadius: 0.0, //extend the shadow
                                      offset: Offset(
                                        5.0, // Move to right 10  horizontally
                                        5.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/icons/sendx.png",
                                    width: 24,
                                    height: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        listener: (context, state) {
                          if (state is SendMessageStatesSuccess) {
                            // get all messages or add new message to messages list
                            msgController.text = "";

                            if (io.Platform.isAndroid) {
                              getSingleChatBloc.add(
                                GetSingleChatEventsUpdated(
                                    mssage: state.message.data),
                              );
                            }

                            // _scrollToEnd();
                            // FlashHelper.successBar(context, message: "ok");
                          } else if (state is SendMessageStatesFailed) {
                            _handleError(state: state, context: context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.currentLanguage == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Slider(
        min: 0.0,
        activeColor: AppTheme.primaryColor,
        inactiveColor: AppTheme.secondary2Color,
        max: widget.duration.inMilliseconds.toDouble(),
        value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
        onChanged: (value) {
          setState(() {
            _dragValue = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged(Duration(milliseconds: value.round()));
          }
        },
        onChangeEnd: (value) {
          _dragValue = null;
          if (widget.onChangeEnd != null) {
            widget.onChangeEnd(Duration(milliseconds: value.round()));
          }
        },
      ),
    );
  }
}
