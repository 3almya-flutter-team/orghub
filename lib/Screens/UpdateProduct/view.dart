import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:orghub/ComonServices/AllClassificationsService/bloc.dart';
import 'package:orghub/ComonServices/AllClassificationsService/events.dart';
import 'package:orghub/ComonServices/AllClassificationsService/states.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/bloc.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/events.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/states.dart';
import 'package:orghub/ComonServices/AllMarksService/bloc.dart';
import 'package:orghub/ComonServices/AllMarksService/events.dart';
import 'package:orghub/ComonServices/AllMarksService/states.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/bloc.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/events.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/states.dart';
import 'package:orghub/ComonServices/AllTagsService/bloc.dart';
import 'package:orghub/ComonServices/AllTagsService/events.dart';
import 'package:orghub/ComonServices/AllTagsService/model.dart' as tagModel;
import 'package:orghub/ComonServices/AllTagsService/states.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CityService/events.dart';
import 'package:orghub/ComonServices/CityService/states.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/events.dart';
import 'package:orghub/ComonServices/CountryService/states.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/bloc.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/events.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/states.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Helpers/flash_helper.dart';
import 'package:orghub/Screens/CustomWidgets/CustomButtons.dart';
import 'package:orghub/Screens/Home/AllCategories/bloc.dart';
import 'package:orghub/Screens/Home/AllCategories/events.dart';
import 'package:orghub/Screens/MyProducts/view.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/events.dart';
import 'package:orghub/Screens/ProductDetails/bloc.dart';
import 'package:orghub/Screens/ProductDetails/events.dart';
import 'package:orghub/Screens/ProductDetails/model.dart';
import 'package:orghub/Screens/ProductDetails/states.dart';
import 'package:orghub/Screens/UpdateProduct/DeleteImage/bloc.dart';
import 'package:orghub/Screens/UpdateProduct/DeleteImage/events.dart';
import 'package:orghub/Screens/UpdateProduct/bloc.dart';
import 'package:orghub/Screens/UpdateProduct/events.dart';
import 'package:orghub/Screens/UpdateProduct/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:orghub/Utils/FormBuilder/flutter_form_builder.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_dropdown.dart';
import 'package:orghub/Utils/FormBuilder/src/fields/form_builder_text_field.dart';
import 'package:orghub/Utils/FormBuilder/src/form_builder.dart';
import 'package:orghub/Utils/FormBuilder/src/form_builder_validators.dart';

import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:orghub/Utils/FormBuilder/src/widgets/image_source_sheet.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class UpdateProductScreen extends StatefulWidget {
  final int advertId;
  final int countryId;
  UpdateProductScreen({Key key, @required this.advertId, this.countryId})
      : super(key: key);

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  GetAllMarksBloc getAllMarksBloc =
      kiwi.KiwiContainer().resolve<GetAllMarksBloc>();
  GetAllSpecificationsBloc getAllSpecificationsBloc =
      kiwi.KiwiContainer().resolve<GetAllSpecificationsBloc>();
  GetAllClassificationsBloc getAllClassificationsBloc =
      kiwi.KiwiContainer().resolve<GetAllClassificationsBloc>();
  GetAllCurrenciesBloc getAllCurrenciesBloc =
      kiwi.KiwiContainer().resolve<GetAllCurrenciesBloc>();
  GetAllTagsBloc getAllTagsBloc =
      kiwi.KiwiContainer().resolve<GetAllTagsBloc>();

  GetAllCategoriesBloc getAllCategoriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCategoriesBloc>();

  GetAllCountries getAllCountriesBloc =
      kiwi.KiwiContainer().resolve<GetAllCountries>();

  GetAllCitiesBloc getAllCitiesBloc =
      kiwi.KiwiContainer().resolve<GetAllCitiesBloc>();

  GetSingleAdvertDataBloc getSingleAdvertDataBloc =
      kiwi.KiwiContainer().resolve<GetSingleAdvertDataBloc>();

  DeleteImageBloc deleteImageBloc =
      kiwi.KiwiContainer().resolve<DeleteImageBloc>();

  GetAllRecursionCategoriesBloc getAllRecursionCategoriesBloc =
      kiwi.KiwiContainer().resolve<GetAllRecursionCategoriesBloc>();

  List<AdType> types = [
    AdType(
      nameAr: "بيع",
      nameEn: "sell",
    ),
    AdType(
      nameAr: "شراء",
      nameEn: "buy",
    ),
  ];

  // bool _showPriceField = false;
  int _selectedCountryId;

  @override
  void initState() {
    getAllMarksBloc.add(GetAllMarksEventStart());
    getAllSpecificationsBloc.add(GetAllSpecificationsEventStart());
    getAllClassificationsBloc.add(GetAllClassificationsEventStart());
    getAllCurrenciesBloc.add(GetAllCurrenciesEventStart());
    getAllTagsBloc.add(GetAllTagsEventStart());
    getAllCategoriesBloc.add(GetAllCategoriesEventStart());
    getAllCountriesBloc.add(GetAllCountriesEventStart());
    getAllRecursionCategoriesBloc.add(GetAllRecursionCategoriesEventStart());
    getSingleAdvertDataBloc.add(
      GetSingleAdvertEventsStart(
        advertId: widget.advertId,
      ),
    );

    getSingleAdvertDataBloc
        .getSingleAdvertData(advertId: widget.advertId)
        .then((value) {
      if (value.success) {
        SingleAdvertModel singleAdvertModel =
            SingleAdvertModel.fromJson(value.response.data);
        selectedImages.addAll(singleAdvertModel.data.images);
        tagList = singleAdvertModel.data.tags
            .map(
              (e) => tagModel.Tag(
                id: e.id,
                name: e.name,
                desc: e.desc,
                adCount: e.adCount,
              ),
            )
            .toList();
        setState(() {});
      }
    }).catchError((value) {});

    if (widget.countryId != null) {
      getAllCitiesBloc.add(
        GetAllCitiesEventStart(
          countryId: widget.countryId,
        ),
      );
    }

    super.initState();
  }

  List<tagModel.Tag> tagList = [];

  void displayTagsBottomSheet({BuildContext context, List<tagModel.Tag> tags}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(9),
            child: Column(
              children: [
                Text(translator.currentLanguage == "en"
                    ? "Please choose tag"
                    : "من فضلك قم باختيار شعار "),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: tags.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            if (tagList.indexWhere((element) =>
                                    element.id == tags[index].id) !=
                                -1) {
                              FlashHelper.errorBar(context,
                                  message: translator.currentLanguage == 'en'
                                      ? "Have been added before."
                                      : "تم اضافتها من قبل");
                            } else {
                              tagList.add(tags[index]);
                            }
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(tags[index].name ?? ""),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    getAllMarksBloc.close();
    getAllSpecificationsBloc.close();
    getAllClassificationsBloc.close();
    getAllCurrenciesBloc.close();
    getAllTagsBloc.close();
    getAllCategoriesBloc.close();
    getAllCountriesBloc.close();
    getAllCitiesBloc.close();
    getSingleAdvertDataBloc.close();
    getAllRecursionCategoriesBloc.close();
    deleteImageBloc.close();
    super.dispose();
  }

  File mainImage;
  void openImagePicker({BuildContext context, String type}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageSourceSheet(
            preferredCameraDevice: CameraDevice.rear,
            maxHeight: 100,
            maxWidth: 100,
            onImageSelected: (image) {
              print(image.toString());
              setState(() {
                mainImage = image;
              });
              Navigator.of(context).pop();
            },
          );
        });
  }

  void _submit({BuildContext context}) async {
    if (!_fbKey.currentState.validate()) {
      return;
    } else {
      _fbKey.currentState.save();

      Map<String, dynamic> adverData;
      setState(() {
        adverData = _fbKey.currentState.value;
      });

      if (tagList.isNotEmpty) {
        adverData.putIfAbsent(
          "tag_list",
          () => tagList.map((tag) => tag.id).toList(),
        );
      }

      if (mainImage is File) {
        adverData.putIfAbsent(
          "main_image",
          () => dio.MultipartFile.fromFileSync(
            mainImage.path,
            filename: basename(mainImage.path),
          ),
        );
      } else {
        adverData.putIfAbsent(
          "main_image",
          () => null,
        );
      }

      int imageIndex = 0;
      selectedImages.forEach((file) {
        if (file != null && file is File) {
          print(
              imageIndex.toString() + "====================================>");
          adverData.putIfAbsent(
              "images[${imageIndex++}]",
              () => dio.MultipartFile.fromFileSync(file.path,
                  filename: basename(file.path)));
        }
      });

      // if (selectedImages) {
      //   print("=-=-=-= [ YEAH IAM HERE ] =-=-=-==");
      //   adverData.update(
      //     "images",
      //     (existingValue) => null,
      //     ifAbsent: () => null,
      //   );
      // }

      // if (images.isNotEmpty) {
      //   List<MultipartFile> multipartImageList = new List<MultipartFile>();

      //   for (Asset asset in images) {
      //     ByteData byteData = await asset.getByteData();
      //     List<int> imageData = byteData.buffer.asUint8List();
      //     List<int> resultList = await compressImageList(imageData);
      //     MultipartFile multipartFile = MultipartFile.fromFile(
      //       resultList,
      //       filename: asset.name,
      //       contentType: MediaType("image", "jpg"),
      //     );
      //     multipartImageList.add(multipartFile);
      //   }

      //   setState(() {
      //     adverData.putIfAbsent(
      //       "images",
      //       () => multipartImageList,
      //     );
      //   });
      // }
      // else {
      //   FlashHelper.errorBar(
      //     context,
      //     message: translator.currentLanguage == 'en'
      //         ? "Advert images is required"
      //         : "صور الاعلان مطلوبه",
      //   );
      //   return;
      // }

      adverData.putIfAbsent(
        "_method",
        () => "put",
      );

      print("from create screen => ${adverData.toString()}");

      BlocProvider.of<UpdateAdvertBloc>(context).add(
        UpdateAdvertEventStart(
          advertData: adverData,
          advertId: widget.advertId,
        ),
      );
    }
  }

  void _handleError({BuildContext context, UpdateAdvertStatesFailed state}) {
    if (state.errType == 0) {
      FlashHelper.infoBar(
        context,
        message: translator.currentLanguage == "ar"
            ? "من فضلك تاكد من الاتصال بالانترنت"
            : "PLEASE CHECK YOUR NETWORK CONNECTION",
      );
    } else if (state.errType == 1) {
      FlashHelper.errorBar(context, message: state.msg ?? "");
    } else {
      // other error
      FlashHelper.errorBar(context, message: state.msg ?? "");
    }
  }

  Future<Uint8List> compressImageList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 96,
      // rotate: 135,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  Container imageWidget({dynamic image, int index}) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image is File ? FileImage(image) : NetworkImage(image),
        ),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 3,
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> selectedImages = [];
  void openImagesPicker({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageSourceSheet(
            maxHeight: 100,
            maxWidth: 100,
            onImageSelected: (image) {
              setState(() {
                selectedImages.add(image);
              });
              Get.back();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        context: context,
        title: translator.currentLanguage == "en"
            ? "Update Advert"
            : "تعديل الاعلان",
        leading: true,
      ),
      body: BlocBuilder(
          bloc: getSingleAdvertDataBloc,
          builder: (context, oldAdvertState) {
            if (oldAdvertState is GetSingleAdvertStatesStart) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinKitThreeBounce(
                  color: AppTheme.primaryColor,
                  size: 30,
                ),
              );
            } else if (oldAdvertState is GetSingleAdvertStatesSuccess) {
              return FormBuilder(
                key: _fbKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          openImagePicker(context: context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color(
                              getColorHexFromStr("#F8F8F8"),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            image: mainImage == null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        oldAdvertState.advertData.image),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: FileImage(mainImage),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/camera.png",
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(translator.currentLanguage == 'en'
                                  ? "Main Image"
                                  : "صوره رئسيه"),
                            ],
                          ),
                        ),
                      ),
                      //----
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppTheme.backGroundColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                openImagesPicker(context: context);
                              },
                              child: Row(
                                children: [
                                  Text(translator.currentLanguage == 'en'
                                      ? "Add another images for that advert :"
                                      : "اضافه صور اخرى للاعلان : "),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            selectedImages.isEmpty
                                ? Container()
                                : Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        itemCount: selectedImages.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  border: Border.all(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    width: 3,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: selectedImages[index]
                                                          is File
                                                      ? Image.file(
                                                          selectedImages[index],
                                                        )
                                                      : Image.network(
                                                          selectedImages[index]
                                                              .img,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (selectedImages[index]
                                                        is ImageData) {
                                                      deleteImageBloc.add(
                                                        DeleteImageEventsStart(
                                                          imageId:
                                                              selectedImages[
                                                                      index]
                                                                  .imageId,
                                                        ),
                                                      );
                                                      selectedImages.remove(
                                                          selectedImages[
                                                              index]);
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Container(
                      //   height: 200,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: FormBuilderImagePicker(
                      //     attribute: "images",
                      //     initialValue: oldAdvertState.advertData.images == null
                      //         ? null
                      //         : oldAdvertState.advertData.images
                      //             .map((e) => e.img)
                      //             .toList(),
                      //     imageHeight: 150,
                      //     imageWidth: 150,
                      //     valueTransformer: (images) {
                      //       return images.map((image) {
                      //         if (image is File) {
                      //           return MultipartFile.fromFileSync(
                      //             image.path,
                      //             filename: basename(image.path),
                      //           );
                      //         } else {
                      //           return null;
                      //         }
                      //       }).toList()
                      //         ..removeWhere((image) => image == null);
                      //     },
                      //     decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //     ),
                      //     imageMargin: EdgeInsets.all(5),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderDropdown(
                          attribute: "ad_type",
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            labelText: translator.currentLanguage == "en"
                                ? "Advert Type"
                                : "نوع الاعلان",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                          initialValue: oldAdvertState.advertData.adType,
                          onChanged: (val) {
                            if (val == "sell") {
                              // show price field
                              setState(() {
                                oldAdvertState.advertData.adType = "sell";
                                // _showPriceField = true;
                              });
                            } else {
                              setState(() {
                                oldAdvertState.advertData.adType = "buy";
                                // _showPriceField = false;
                              });
                            }
                          },
                          hint: Text(
                            translator.currentLanguage == "en"
                                ? "Advert Type"
                                : 'نوع الاعلان',
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 12,
                              color: Color(getColorHexFromStr("#949494")),
                            ),
                          ),
                          validators: [
                            FormBuilderValidators.required(
                              errorText: translator.currentLanguage == "en"
                                  ? "This field is required."
                                  : "هذا الحقل مطلوب",
                            )
                          ],
                          items: types
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type.nameEn,
                                  child: Text(
                                    "${type.nameAr}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "ar[name]",
                          initialValue: oldAdvertState.advertData.name,
                          decoration: InputDecoration(
                            labelText: translator.currentLanguage == "en"
                                ? "Name"
                                : "الاسم",
                            hintText: translator.currentLanguage == "en"
                                ? "Advert name"
                                : "اسم الاعلان",
                            hintStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 12,
                              color: Color(getColorHexFromStr("#949494")),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                          validators: [],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "address",
                          initialValue: oldAdvertState.advertData.address ?? "",
                          decoration: InputDecoration(
                            labelText: translator.currentLanguage == "en"
                                ? "Address"
                                : "العنوان",
                            hintText: translator.currentLanguage == "en"
                                ? "Address in details"
                                : "العنوان بالتفصيل",
                            hintStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 12,
                              color: Color(getColorHexFromStr("#949494")),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                          validators: [],
                        ),
                      ),

                      //----------------------
                      // SELECT PRODUCT CATEGORY
                      //----------------------

                      BlocBuilder(
                          bloc: getAllRecursionCategoriesBloc,
                          builder: (context, state) {
                            if (state is GetAllRecursionCategoriesStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state
                                is GetAllRecursionCategoriesStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "category_id",
                                  initialValue:
                                      oldAdvertState.advertData.category.id,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    enabled:
                                        state.allRecursionCategories.isEmpty
                                            ? false
                                            : true,
                                    labelText:
                                        translator.currentLanguage == 'en'
                                            ? "Category"
                                            : "القسم",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  // initialValue: 'بيع',
                                  hint: Text(
                                    translator.currentLanguage == 'en'
                                        ? "Select Category"
                                        : 'اختار القسم',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText:
                                          translator.currentLanguage == "en"
                                              ? "This field is required."
                                              : "هذا الحقل مطلوب",
                                    )
                                  ],
                                  items: state.allRecursionCategories
                                      .map(
                                        (category) => DropdownMenuItem(
                                          value: category.id,
                                          child: Text(
                                            "${category.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state
                                is GetAllRecursionCategoriesStateFaild) {
                              if (state.errType == 0) {
                                // FlashHelper.errorBar(context,
                                //     message: translator.currentLanguage == 'en'
                                //         ? "Please check your network connection."
                                //         : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: state.msg ?? "");
                                return Container();
                              }
                            } else {
                              // FlashHelper.errorBar(context, message: state.msg ?? "");
                              return Container();
                            }
                          }),

                      // BlocBuilder(
                      //     bloc: getAllCategoriesBloc,
                      //     builder: (context, state) {
                      //       if (state is GetAllCategoriesStateStart) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: SpinKitThreeBounce(
                      //             color: AppTheme.primaryColor,
                      //             size: 30,
                      //           ),
                      //         );
                      //       } else if (state is GetAllCategoriesStateSucess) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: FormBuilderDropdown(
                      //             attribute: "category_id",
                      //             decoration: InputDecoration(
                      //               contentPadding: EdgeInsets.all(8),
                      //               enabled: state.allCategories.isEmpty
                      //                   ? false
                      //                   : true,
                      //               labelText:
                      //                   translator.currentLanguage == "en"
                      //                       ? "Category"
                      //                       : "القسم",
                      //               labelStyle: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: 20,
                      //                 fontFamily: AppTheme.fontName,
                      //               ),
                      //             ),
                      //             initialValue:
                      //                 oldAdvertState.advertData.category.id,
                      //             hint: Text(
                      //               translator.currentLanguage == "en"
                      //                   ? "Select Category"
                      //                   : 'اختار القسم',
                      //               style: TextStyle(
                      //                 fontFamily: AppTheme.fontName,
                      //                 fontSize: 12,
                      //                 color:
                      //                     Color(getColorHexFromStr("#949494")),
                      //               ),
                      //             ),
                      //             validators: [
                      //               FormBuilderValidators.required(
                      //                 errorText:
                      //                     translator.currentLanguage == "en"
                      //                         ? "This field is required."
                      //                         : "هذا الحقل مطلوب",
                      //               )
                      //             ],
                      //             items: state.allCategories
                      //                 .map(
                      //                   (category) => DropdownMenuItem(
                      //                     value: category.id,
                      //                     child: Text(
                      //                       "${category.name}",
                      //                       style: TextStyle(
                      //                         fontSize: 12,
                      //                         color: Color(getColorHexFromStr(
                      //                             "#949494")),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 )
                      //                 .toList(),
                      //           ),
                      //         );
                      //       } else if (state is GetAllCategoriesStateFaild) {
                      //         if (state.errType == 0) {
                      //           FlashHelper.errorBar(context,
                      //               message: translator.currentLanguage == 'en'
                      //                   ? "Please check your network connection."
                      //                   : "برجاء التاكد من الاتصال بالانترنت ");
                      //           return noInternetWidget(context);
                      //         } else {
                      //           FlashHelper.errorBar(context,
                      //               message: state.msg ?? "");
                      //           return Container();
                      //         }
                      //       } else {
                      //         FlashHelper.errorBar(context,
                      //             message: state.msg ?? "");
                      //         return Container();
                      //       }
                      //     }),

                      //----------------------
                      // END SELECT PRODUCT CATEGORY
                      //----------------------

                      //----------------------
                      // SELECT PRODUCT COUNTRY
                      //----------------------

                      BlocBuilder(
                          bloc: getAllCountriesBloc,
                          builder: (context, state) {
                            if (state is GetAllCountriesStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state is GetAllCountriesStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "country_id",
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    enabled:
                                        state.allCountriesModel.data.isEmpty
                                            ? false
                                            : true,
                                    labelText:
                                        translator.currentLanguage == "en"
                                            ? "Country"
                                            : "الدوله",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  initialValue:
                                      oldAdvertState.advertData.country == null
                                          ? null
                                          : oldAdvertState
                                              .advertData.country.id,
                                  hint: Text(
                                    translator.currentLanguage == "en"
                                        ? "Select Country"
                                        : 'اختر الدوله',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    print(val);
                                    setState(() {
                                      _selectedCountryId = val;
                                    });

                                    getAllCitiesBloc.add(
                                      GetAllCitiesEventStart(
                                        countryId: val,
                                      ),
                                    );
                                  },
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText:
                                          translator.currentLanguage == "en"
                                              ? "This field is required."
                                              : "هذا الحقل مطلوب",
                                    )
                                  ],
                                  items: state.allCountriesModel.data
                                      .map(
                                        (country) => DropdownMenuItem(
                                          value: country.id,
                                          child: Text(
                                            "${country.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state is GetAllCountriesStateFaild) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context,
                                //     message: state.msg ?? "");
                                return Container();
                              }
                            } else {
                              // FlashHelper.errorBar(context,
                              //     message: state.msg ?? "");
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT COUNTRY
                      //----------------------

                      //----------------------
                      // SELECT PRODUCT CITY
                      //----------------------

                      BlocBuilder(
                          bloc: getAllCitiesBloc,
                          builder: (context, state) {
                            if (state is GetAllCitesStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state is GetAllCitesStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "city_id",
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    enabled: state.allCitiesModel.data.isEmpty
                                        ? false
                                        : true,
                                    labelText:
                                        translator.currentLanguage == "en"
                                            ? "City"
                                            : "المدينه",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  initialValue:
                                      oldAdvertState.advertData.city == null
                                          ? null
                                          : oldAdvertState.advertData.city.id,
                                  hint: Text(
                                    translator.currentLanguage == "en"
                                        ? "Select City"
                                        : 'اختر المدينه',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  // validators: [
                                  //   FormBuilderValidators.required()
                                  // ],
                                  items: state.allCitiesModel.data
                                      .map(
                                        (city) => DropdownMenuItem(
                                          value: city.id,
                                          child: Text(
                                            "${city.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state is GetAllCitesStateFaild) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: "");
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT City
                      //----------------------

                      //----------------------
                      // SELECT PRODUCT MARK
                      //----------------------

                      BlocBuilder(
                          bloc: getAllMarksBloc,
                          builder: (context, state) {
                            if (state is GetAllMarksStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state is GetAllMarksStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "mark_id",
                                  initialValue:
                                      oldAdvertState.advertData.mark.id,
                                  decoration: InputDecoration(
                                    enabled: state.allMarksModel.data.isEmpty
                                        ? false
                                        : true,
                                    contentPadding: EdgeInsets.all(8),
                                    labelText:
                                        translator.currentLanguage == 'en'
                                            ? "Mark"
                                            : "الماركه",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  hint: Text(
                                    translator.currentLanguage == "en"
                                        ? "Select Mark"
                                        : 'اختر الماركه',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText:
                                          translator.currentLanguage == "en"
                                              ? "This field is required."
                                              : "هذا الحقل مطلوب",
                                    )
                                  ],
                                  items: state.allMarksModel.data
                                      .map(
                                        (mark) => DropdownMenuItem(
                                          value: mark.id,
                                          child: Text(
                                            "${mark.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state is GetAllMarksStateFaild) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context,
                                //     message: state.msg ?? "");
                                return Container();
                              }
                            } else {
                              // FlashHelper.errorBar(context,
                              //     message: state.msg ?? "");
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT MARK
                      //----------------------

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          attribute: "stock",
                          initialValue:
                              oldAdvertState.advertData.stock.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: translator.currentLanguage == "en"
                                ? "Quantity"
                                : "الكميه",
                            hintText: translator.currentLanguage == "en"
                                ? "Available Quantity"
                                : "الكميه المتاحه",
                            hintStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 12,
                              color: Color(getColorHexFromStr("#949494")),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                          validators: [
                            FormBuilderValidators.required(
                              errorText: translator.currentLanguage == "en"
                                  ? "This field is required."
                                  : "هذا الحقل مطلوب",
                            )
                          ],
                        ),
                      ),

                      () {
                        if (oldAdvertState.advertData.adType == 'sell') {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderTextField(
                              attribute: "price",
                              initialValue: oldAdvertState.advertData.price,
                              decoration: InputDecoration(
                                labelText: translator.currentLanguage == "en"
                                    ? "Price"
                                    : "السعر",
                                hintText: translator.currentLanguage == "en"
                                    ? "Advert Price"
                                    : "سعر الاعلان",
                                hintStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontSize: 12,
                                  color: Color(getColorHexFromStr("#949494")),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                              validators: [
                                FormBuilderValidators.required(
                                  errorText: translator.currentLanguage == "en"
                                      ? "This field is required."
                                      : "هذا الحقل مطلوب",
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }(),
                      // : Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: FormBuilderTextField(
                      //       attribute: "price",
                      //       initialValue: oldAdvertState.advertData.price,
                      //       decoration: InputDecoration(
                      //         labelText: "السعر",
                      //         hintText: "سعر الاعلان",
                      //         hintStyle: TextStyle(
                      //           fontFamily: AppTheme.fontName,
                      //           fontSize: 12,
                      //           color: Color(getColorHexFromStr("#949494")),
                      //         ),
                      //         labelStyle: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 15,
                      //           fontFamily: AppTheme.fontName,
                      //         ),
                      //       ),
                      //       validators: [FormBuilderValidators.required()],
                      //     ),
                      //   ),

                      //----------------------
                      // SELECT PRODUCT Currency
                      //----------------------

                      BlocBuilder(
                          bloc: getAllCurrenciesBloc,
                          builder: (context, state) {
                            if (state is GetAllCurrenciesStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state is GetAllCurrenciesStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "currency_id",
                                  decoration: InputDecoration(
                                    enabled:
                                        state.allCurrenciesModel.data.isEmpty
                                            ? false
                                            : true,
                                    contentPadding: EdgeInsets.all(8),
                                    labelText:
                                        translator.currentLanguage == "en"
                                            ? "Currency"
                                            : "العمله",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  initialValue:
                                      oldAdvertState.advertData.currency == null
                                          ? null
                                          : oldAdvertState
                                              .advertData.currency.id,
                                  hint: Text(
                                    translator.currentLanguage == "en"
                                        ? "Select Currency"
                                        : 'اختر العمله',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText:
                                          translator.currentLanguage == "en"
                                              ? "This field is required."
                                              : "هذا الحقل مطلوب",
                                    )
                                  ],
                                  items: state.allCurrenciesModel.data
                                      .map(
                                        (currency) => DropdownMenuItem(
                                          value: currency.id,
                                          child: Text(
                                            "${currency.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state is GetAllCurrenciesStateFaild) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: "");
                                return Container();
                              }
                            } else {
                              // FlashHelper.errorBar(context, message: "");
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT Currency
                      //----------------------

                      //----------------------
                      // SELECT PRODUCT TAGS
                      //----------------------

                      // BlocBuilder(
                      //     bloc: getAllTagsBloc,
                      //     builder: (context, state) {
                      //       if (state is GetAllTagsStateStart) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: SpinKitThreeBounce(
                      //             color: AppTheme.primaryColor,
                      //             size: 30,
                      //           ),
                      //         );
                      //       } else if (state is GetAllTagsStateSucess) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: FormBuilderChipsInput(
                      //             attribute: "tag_list",
                      //             initialValue: oldAdvertState.advertData.tags,
                      //             decoration: InputDecoration(
                      //               contentPadding: EdgeInsets.all(8),
                      //               labelText:
                      //                   translator.currentLanguage == "en"
                      //                       ? "Tags"
                      //                       : "الكلمات الدلاليه",
                      //               labelStyle: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: 14,
                      //                 fontFamily: AppTheme.fontName,
                      //               ),
                      //             ),
                      //             // initialValue: 'بيع',
                      //             valueTransformer: (tags) {
                      //               return tags.map((tag) => tag.id).toList();
                      //             },
                      //             validators: [
                      //               FormBuilderValidators.required(
                      //                 errorText:
                      //                     translator.currentLanguage == "en"
                      //                         ? "This field is required."
                      //                         : "هذا الحقل مطلوب",
                      //               )
                      //             ],
                      //             chipBuilder: (BuildContext context,
                      //                 ChipsInputState<dynamic> state, tag) {
                      //               return InputChip(
                      //                 key: ObjectKey(tag),
                      //                 label: Text(tag.name),
                      //                 avatar: CircleAvatar(
                      //                   backgroundColor: Colors.grey,
                      //                   backgroundImage: NetworkImage(
                      //                     "https://i.imgur.com/OUKKo6U.png",
                      //                   ),
                      //                 ),
                      //                 onDeleted: () => state.deleteChip(tag),
                      //                 materialTapTargetSize:
                      //                     MaterialTapTargetSize.shrinkWrap,
                      //               );
                      //             },
                      //             findSuggestions: (String query) {
                      //               if (query.length != 0) {
                      //                 var lowercaseQuery = query.toLowerCase();
                      //                 return state.allTagsModel.data
                      //                     .where((tag) {
                      //                   return tag.name.toLowerCase().contains(
                      //                           query.toLowerCase()) ||
                      //                       tag.desc
                      //                           .toLowerCase()
                      //                           .contains(query.toLowerCase());
                      //                 }).toList(growable: false)
                      //                       ..sort((a, b) => a.name
                      //                           .toLowerCase()
                      //                           .indexOf(lowercaseQuery)
                      //                           .compareTo(b.name
                      //                               .toLowerCase()
                      //                               .indexOf(lowercaseQuery)));
                      //               } else {
                      //                 return const <Tag>[];
                      //               }
                      //             },

                      //             suggestionBuilder: (BuildContext context,
                      //                 ChipsInputState<dynamic> state, tag) {
                      //               return ListTile(
                      //                 key: ObjectKey(tag),
                      //                 leading: CircleAvatar(
                      //                   backgroundImage: NetworkImage(
                      //                       "https://i.imgur.com/OUKKo6U.png"),
                      //                 ),
                      //                 title: Text(tag.name),
                      //                 subtitle: Text(tag.desc),
                      //                 onTap: () => state.selectSuggestion(tag),
                      //               );
                      //             },
                      //           ),
                      //         );
                      //       } else if (state is GetAllTagsStateFaild) {
                      //         if (state.errType == 0) {
                      //           FlashHelper.errorBar(context,
                      //               message: translator.currentLanguage == 'en'
                      //                   ? "Please check your network connection."
                      //                   : "برجاء التاكد من الاتصال بالانترنت ");
                      //           return noInternetWidget(context);
                      //         } else {
                      //           // FlashHelper.errorBar(context, message: "");
                      //           return Container();
                      //         }
                      //       } else {
                      //         // FlashHelper.errorBar(context, message: "");
                      //         return Container();
                      //       }
                      //     }),

                      BlocBuilder(
                          bloc: getAllTagsBloc,
                          builder: (context, state) {
                            if (state is GetAllTagsStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state is GetAllTagsStateSucess) {
                              return InkWell(
                                onTap: () {
                                  displayTagsBottomSheet(
                                      context: context,
                                      tags: state.allTagsModel.data);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          translator.currentLanguage == 'en'
                                              ? "Tags"
                                              : "الكلمات الدلاليه",
                                      enabled: false,
                                      hintStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 12,
                                        color: Color(
                                            getColorHexFromStr("#949494")),
                                      ),
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      contentPadding: EdgeInsets.all(8),
                                      labelText:
                                          translator.currentLanguage == 'en'
                                              ? "Tags"
                                              : "الكلمات الدلاليه",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: AppTheme.fontName,
                                      ),
                                    ),
                                    // initialValue: 'بيع',

                                    // items: state.allTagsModel.data
                                    //     .map(
                                    //       (tag) => DropdownMenuItem(
                                    //         value: tag.id,
                                    //         onTap: () {
                                    //           if (tagList.indexWhere((element) =>
                                    //                   element.id == tag.id) !=
                                    //               -1) {
                                    //             FlashHelper.errorBar(context,
                                    //                 message:
                                    //                     translator.currentLanguage == 'en'
                                    //                         ? "Have been added before."
                                    //                         : "تم اضافتها من قبل");
                                    //           } else {
                                    //             tagList.add(tag);
                                    //           }
                                    //           setState(() {});
                                    //         },
                                    //         child: Text(
                                    //           "${tag.name}",
                                    //           style: TextStyle(
                                    //             fontSize: 12,
                                    //             color:
                                    //                 Color(getColorHexFromStr("#949494")),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     )
                                    //     .toList(),
                                  ),
                                ),
                              );
                            } else if (state is GetAllTagsStateFaild) {
                              if (state.errType == 0) {
                                // FlashHelper.errorBar(context,
                                //     message: translator.currentLanguage == 'en'
                                //         ? "Please check your network connection."
                                //         : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: "");
                                return errorWidget(
                                    context, state.msg ?? "", state.statusCode);
                              }
                            } else {
                              // FlashHelper.errorBar(context, message: "");
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT TAGS
                      //----------------------

                      //     tagList = oldAdvertState.advertData.tags
                      // .map(
                      //   (e) => tagModel.Tag(
                      //     id: e.id,
                      //     name: e.name,
                      //     desc: e.desc,
                      //     adCount: e.adCount,
                      //   ),
                      // )
                      // .toList();

                      tagList.isEmpty || tagList == null
                          ? Container()
                          : Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tagList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.all(6),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              tagList.remove(tagList[index]);
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Center(
                                              child: Text(
                                                tagList[index].name ?? "",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),

                      //----------------------
                      // END SELECT PRODUCT TAGS
                      //----------------------

                      //----------------------
                      // SELECT PRODUCT Classifications
                      //----------------------

                      BlocBuilder(
                          bloc: getAllClassificationsBloc,
                          builder: (context, state) {
                            if (state is GetAllClassificationsStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state
                                is GetAllClassificationsStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "classification_id",
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    labelText:
                                        translator.currentLanguage == "en"
                                            ? "Classifications"
                                            : "المواصفات",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  initialValue: oldAdvertState
                                      .advertData.classification.id,
                                  hint: Text(
                                    translator.currentLanguage == "en"
                                        ? "Advert Classifications"
                                        : 'موصفات الاعلان',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText:
                                          translator.currentLanguage == "en"
                                              ? "This field is required."
                                              : "هذا الحقل مطلوب",
                                    )
                                  ],
                                  items: state.allClassificationsModel.data
                                      .map(
                                        (classify) => DropdownMenuItem(
                                          value: classify.id,
                                          child: Text(
                                            "${classify.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state
                                is GetAllClassificationsStateFaild) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: "");
                                return Container();
                              }
                            } else {
                              // FlashHelper.errorBar(context, message: "");
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT Classifications
                      //----------------------

                      //----------------------
                      // SELECT PRODUCT SPECIFICATIONS
                      //----------------------

                      BlocBuilder(
                          bloc: getAllSpecificationsBloc,
                          builder: (context, state) {
                            if (state is GetAllSpecificationsStateStart) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              );
                            } else if (state
                                is GetAllSpecificationsStateSucess) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FormBuilderDropdown(
                                  attribute: "specification_id",
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    labelText:
                                        translator.currentLanguage == "en"
                                            ? "Specifications"
                                            : "التصنيفات",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ),
                                  initialValue: oldAdvertState
                                      .advertData.specification.id,
                                  hint: Text(
                                    translator.currentLanguage == "en"
                                        ? "Advert Specifications"
                                        : 'تصنيفات الاعلان',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color:
                                          Color(getColorHexFromStr("#949494")),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                      errorText:
                                          translator.currentLanguage == "en"
                                              ? "This field is required."
                                              : "هذا الحقل مطلوب",
                                    )
                                  ],
                                  items: state.allSpecificationsModel.data
                                      .map(
                                        (specify) => DropdownMenuItem(
                                          value: specify.id,
                                          child: Text(
                                            "${specify.name}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(getColorHexFromStr(
                                                  "#949494")),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            } else if (state
                                is GetAllSpecificationsStateFaild) {
                              if (state.errType == 0) {
                                FlashHelper.errorBar(context,
                                    message: translator.currentLanguage == 'en'
                                        ? "Please check your network connection."
                                        : "برجاء التاكد من الاتصال بالانترنت ");
                                return noInternetWidget(context);
                              } else {
                                // FlashHelper.errorBar(context, message: "");
                                return Container();
                              }
                            } else {
                              // FlashHelper.errorBar(context, message: "");
                              return Container();
                            }
                          }),

                      //----------------------
                      // END SELECT PRODUCT SPECIFICATIONS
                      //----------------------

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          maxLines: 4,
                          initialValue: oldAdvertState.advertData.desc,
                          attribute: "ar[desc]",
                          decoration: InputDecoration(
                            labelText: translator.currentLanguage == "en"
                                ? "Advert Details"
                                : "تفاصيل الاعلان",
                            hintText: translator.currentLanguage == "en"
                                ? "Advert Details"
                                : "تفاصيل الاعلان",
                            hintStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 12,
                              color: Color(getColorHexFromStr("#949494")),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                          validators: [],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      BlocConsumer<UpdateAdvertBloc, UpdateAdvertStates>(
                        builder: (context, state) {
                          if (state is UpdateAdvertStatesStart) {
                            return SpinKitCircle(
                              color: AppTheme.primaryColor,
                              size: 30,
                            );
                          } else {
                            return btn(
                                context,
                                translator.currentLanguage == "en"
                                    ? "Update"
                                    : "تعديل", () {
                              _submit(context: context);
                            });
                          }
                        },
                        listener: (context, state) {
                          if (state is UpdateAdvertStatesSuccess) {
                            Toast.show(
                                translator.currentLanguage == "en"
                                    ? "Done"
                                    : "تم تعديل الاعلان بنجاح",
                                context);
                            Get.off(MyProductsView());
                            // Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___){
                            //   return MyProductsView();
                            // });
                          } else if (state is UpdateAdvertStatesFailed) {
                            _handleError(context: context, state: state);
                          }
                        },
                      ),

                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              );
            } else if (oldAdvertState is GetAllSpecificationsStateFaild) {
              if (oldAdvertState.errType == 0) {
                // FlashHelper.errorBar(context,
                //     message: translator.currentLanguage == 'en'
                //         ? "Please check your network connection."
                //         : "برجاء التاكد من الاتصال بالانترنت ");
                return noInternetWidget(context);
              } else {
                // FlashHelper.errorBar(context, message: "");
                return errorWidget(context, oldAdvertState.msg ?? "",
                    oldAdvertState.statusCode);
              }
            } else {
              // FlashHelper.errorBar(context, message: "");
              return Container();
            }
          }),
    );
  }
}

class AdType {
  String nameAr;
  String nameEn;

  AdType({
    this.nameAr,
    this.nameEn,
  });
}
