import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/UpdateProduct/DeleteImage/events.dart';
import 'package:orghub/Screens/UpdateProduct/DeleteImage/states.dart';

class DeleteImageBloc extends Bloc<DeleteImageEvents, DeleteImageStates> {
  DeleteImageBloc() : super(DeleteImageStates());
  ServerGate serverGate = ServerGate();

  @override
  Stream<DeleteImageStates> mapEventToState(DeleteImageEvents event) async* {
    if (event is DeleteImageEventsStart) {
      yield DeleteImageStatesStart();

      CustomResponse response = await deleteImage(imageId: event.imageId);

      if (response.success) {
        yield DeleteImageStatesSuccess();
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield DeleteImageStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield DeleteImageStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield DeleteImageStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> deleteImage({@required int imageId}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.sendToServer(
      url: "delete_app_image/$imageId",
      body: {
        "_method": "delete",
      },
      headers: {
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
        "Accept": "application/json",
      },
    );

    return response;
  }
}
