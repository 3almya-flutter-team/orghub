

import 'package:orghub/Screens/Auth/ClientSignUp/client_input_model.dart';

class ClientRegisterEvents {}

class ClientRegisterEventStart extends ClientRegisterEvents {
  ClientInputData clientInputData;
  ClientRegisterEventStart({this.clientInputData});
}

class ClientRegisterEventFailed extends ClientRegisterEvents {}

class ClientRegisterEventSuccess extends ClientRegisterEvents {}