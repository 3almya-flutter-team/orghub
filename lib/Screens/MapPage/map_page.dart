import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Screens/MapPage/Bloc/GetAddress/address_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/GetAddress/address_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/GetAddress/address_states.dart';
import 'package:orghub/Screens/MapPage/Bloc/MarkerBloc/marker_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/MarkerBloc/marker_events.dart';
import 'package:orghub/Screens/MapPage/Bloc/MarkerBloc/marker_states.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_bloc.dart';


class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AddMarkerToMapBloc addMarkerToMapBloc =
      kiwi.KiwiContainer().resolve<AddMarkerToMapBloc>();
  GetAddressBloc getAddressBloc =
      kiwi.KiwiContainer().resolve<GetAddressBloc>();

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _initialPosition;

  @override
  void initState() {
    _initialPosition = CameraPosition(
      target: LatLng((Get.arguments as UserCurrentAddress).lat,
          (Get.arguments as UserCurrentAddress).long),
      zoom: 17,
    );
    setState(() {});

    getAddressBloc.add(
      GetAddressEventStart(
        lat: (Get.arguments as UserCurrentAddress).lat,
        long: (Get.arguments as UserCurrentAddress).long,
      ),
    );

    addMarkerToMapBloc.add(OnAddMarkerEvent(
        address: (Get.arguments as UserCurrentAddress).address,
        lat: (Get.arguments as UserCurrentAddress).lat,
        long: (Get.arguments as UserCurrentAddress).long));

    super.initState();
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Directionality(
       textDirection: translator.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
          child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(translator.currentLanguage == 'ar' ? "اختر الموقع" :"Choose Location"),
        ),
        body: _initialPosition == null
            ? SpinKitHourGlass(
                color: AppTheme.primaryColor,
                size: 40.0,
              )
            : Stack(
                children: [
                  BlocBuilder(
                      bloc: addMarkerToMapBloc,
                      builder: (context, state) {
                        if (state is OnAddMarkerStateSuccess) {
                          _markers = state.markers;
                        } else {
                          _markers = null;
                        }
                        return GoogleMap(
                          mapType: MapType.normal,
                          onTap: (LatLng currentPosition) {
                            getAddressBloc.add(
                              GetAddressEventStart(
                                lat: currentPosition.latitude,
                                long: currentPosition.longitude,
                              ),
                            );
                            addMarkerToMapBloc.add(
                              OnAddMarkerEvent(
                                address: "",
                                lat: currentPosition.latitude,
                                long: currentPosition.longitude,
                              ),
                            );
                          },
                          markers: _markers,
                          initialCameraPosition: _initialPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        );
                      }),
                  Positioned(
                      bottom: 1,
                      child: BlocBuilder(
                        bloc: getAddressBloc,
                        builder: (context, state) {
                          if (state is GetAddressStateStart) {
                            return Container();
                          } else if (state is GetAddressStateSuccess) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              padding: EdgeInsets.all(9),
                              // color: AppSpecificColor.mainColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 50,
                                decoration: BoxDecoration(
                                  // color: Colors.grey[300],
                                  color: Color(getColorHexFromStr("#F2F2E5")),
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(CupertinoIcons.location),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: AutoSizeText(
                                              state.address ?? "",
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.back(
                                            result: UserCurrentAddress(
                                              lat: state.lat,
                                              long: state.long,
                                              address: state.address,
                                            ),
                                          );
                                          // Get.toNamed(
                                          //   '/add',
                                          //   arguments: UserCurrentAddress(
                                          //     lat: state.lat,
                                          //     long: state.long,
                                          //     address: state.address,
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 70,
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                            translator.currentLanguage == 'ar' ?  "المتابعه":"Continue",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )),
                ],
              ),
      ),
    );
  }
}
