
import 'package:orghub/Screens/Auth/ProviderSignUp/provider_input_model.dart';

class ProviderRegisterEvents {}

class ProviderRegisterEventStart extends ProviderRegisterEvents {
  ProviderInputData providerInputData;
  ProviderRegisterEventStart({this.providerInputData});
}

class ProviderRegisterEventFailed extends ProviderRegisterEvents {}

class ProviderRegisterEventSuccess extends ProviderRegisterEvents {}