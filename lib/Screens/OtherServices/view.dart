import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Screens/OrderDetail/view.dart';
import 'package:orghub/Screens/OtherServices/bloc.dart';
import 'package:orghub/Screens/OtherServices/events.dart';
import 'package:orghub/Screens/OtherServices/states.dart';
import 'package:toast/toast.dart';

class OtherServicesView extends StatefulWidget {
  final int orderId;
  OtherServicesView({Key key, this.orderId}) : super(key: key);

  @override
  _OtherServicesViewState createState() => _OtherServicesViewState();
}

class _OtherServicesViewState extends State<OtherServicesView> {
  String _radioValue; //Initial definition of radio button value
  String choice;

  SelectOtherServiceBloc selectOtherServiceBloc =
      kiwi.KiwiContainer().resolve<SelectOtherServiceBloc>();

  @override
  void dispose() {
    selectOtherServiceBloc.close();
    super.dispose();
  }

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'store':
          choice = value;
          break;
        case 'supply':
          choice = value;
          break;
        case 'shipping':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
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
      print("-=-=-=-=> oooooo => ${state.msg.toString()}");
      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Directionality(
      textDirection: translator.currentLanguage == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        appBar: appBar(
            context: context,
            title: translator.currentLanguage == "en"
                ? "Other Services"
                : "خدمات اخرى",
            leading: true),
        body: Column(
          children: [
            Row(
              children: <Widget>[
                Radio(
                  value: 'store',
                  groupValue: _radioValue,
                  onChanged: radioButtonChanges,
                ),
                Text(
                  translator.currentLanguage == 'en' ? "store" : "طلب تخزين",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'supply',
                  groupValue: _radioValue,
                  onChanged: radioButtonChanges,
                ),
                Text(
                  translator.currentLanguage == 'en' ? "supply" : "طلب توريد",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'shipping',
                  groupValue: _radioValue,
                  onChanged: radioButtonChanges,
                ),
                Text(
                  translator.currentLanguage == 'en' ? "shipping" : "طلب شحن",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            BlocConsumer(
              bloc: selectOtherServiceBloc,
              builder: (context, state) {
                if (state is SelectOtherServiceStateStart)
                  return SpinKitCircle(
                    color: AppTheme.primaryColor,
                    size: 40.0,
                  );
                else
                  return btn(context,
                      translator.currentLanguage == 'en' ? "Choose" : "اختيار",
                      () {
                    selectOtherServiceBloc.add(
                      SelectOtherServiceEventStart(service: choice, orderId: widget.orderId),
                    );
                  });
              },
              listener: (context, state) {
                if (state is SelectOtherServiceStateSuccess) {
                  Toast.show(
                      translator.currentLanguage == 'en'
                          ? "Done"
                          : "تم الارسال بنجاح ",
                      context);
                      Get.off(DetailsOrder(orderId: widget.orderId,));
                } else if (state is SelectOtherServiceStateFailed) {
                  _handleError(state: state, context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
