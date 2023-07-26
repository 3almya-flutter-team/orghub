import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Chat/DownloadFileBloc/events.dart';
import 'package:orghub/Screens/Chat/DownloadFileBloc/states.dart';


class DownloadFileBloc extends Bloc<DownloadFileEvents, DownloadFileStates> {
  DownloadFileBloc() : super(DownloadFileStates());
  ServerGate serverGate = ServerGate();

  @override
  Stream<DownloadFileStates> mapEventToState(DownloadFileEvents event) async* {
    if (event is FileDownloadEventStart) {
      yield FileDownloadStatesStart();
      CustomResponse response = await downloadFile(
        downloadFile: event.url,
        savePath: event.path,
        
      );
      if (response.success) {
        yield FileDownloadStatesStart();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield FileDownloadStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield FileDownloadStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield FileDownloadStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> downloadFile({
    @required String downloadFile,
    @required String savePath,
  }) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.downloadFromServer(
      url: downloadFile, path: savePath,
    );
    return response;
  }
}
