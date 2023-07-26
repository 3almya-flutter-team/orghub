import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orghub/Helpers/colors.dart';

import '../form_builder.dart';
import '../form_builder_validators.dart';
import '../widgets/image_source_sheet.dart';

class FormBuilderImagePicker extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final List initialValue;
  final bool readOnly;
  @Deprecated('Set the `labelText` within decoration attribute')
  final String labelText;
  final InputDecoration decoration;
  final ValueTransformer valueTransformer;
  final ValueChanged onChanged;
  final FormFieldSetter onSaved;

  final double imageWidth;
  final double imageHeight;
  final EdgeInsets imageMargin;
  final Color iconColor;

  /// Optional maximum height of image; see [ImagePicker].
  final double maxHeight;

  /// Optional maximum width of image; see [ImagePicker].
  final double maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned. See [ImagePicker].
  final int imageQuality;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`. See [ImagePicker].
  final CameraDevice preferredCameraDevice;

  final int maxImages;

  const FormBuilderImagePicker({
    Key key,
    @required this.attribute,
    this.initialValue,
    this.validators = const [],
    this.valueTransformer,
    this.labelText,
    this.onChanged,
    this.imageWidth = 130,
    this.imageHeight = 130,
    this.imageMargin,
    this.readOnly = false,
    this.onSaved,
    this.decoration = const InputDecoration(),
    this.iconColor,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxImages,
  }) : super(key: key);

  @override
  _FormBuilderImagePickerState createState() => _FormBuilderImagePickerState();
}

class _FormBuilderImagePickerState extends State<FormBuilderImagePicker> {
  bool _readOnly = false;
  List _initialValue;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;

  bool get _hasMaxImages {
    if (widget.maxImages == null) {
      return false;
    } else {
      return /*_fieldKey.currentState.value != null &&*/ _fieldKey
              .currentState.value.length >=
          widget.maxImages;
    }
  }

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _initialValue = List.of(widget.initialValue ??
        (_formState.initialValue.containsKey(widget.attribute)
            ? _formState.initialValue[widget.attribute]
            : []));
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _readOnly = _formState?.readOnly == true || widget.readOnly;

    return FormField<List>(
      key: _fieldKey,
      enabled: !_readOnly,
      initialValue: _initialValue,
      validator: (val) =>
          FormBuilderValidators.validateValidators(val, widget.validators),
      onSaved: (val) {
        var transformed;
        if (widget.valueTransformer != null) {
          transformed = widget.valueTransformer(val);
          _formState?.setAttributeValue(widget.attribute, transformed);
        } else {
          _formState?.setAttributeValue(widget.attribute, val);
        }
        if (widget.onSaved != null) {
          widget.onSaved(transformed ?? val);
        }
      },
      builder: (field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readOnly,
            errorText: field.errorText,
            // ignore: deprecated_member_use_from_same_package
            labelText: widget.decoration.labelText ?? widget.labelText,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Container(
                height: widget.imageHeight,
                margin: EdgeInsets.only(right: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...(field.value.map<Widget>((item) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Container(
                            width: widget.imageWidth,
                            height: widget.imageHeight,
                            margin: widget.imageMargin,
                            decoration: BoxDecoration(
                              color: Color(getColorHexFromStr("#F8F8F8")),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: item is String
                                      ? NetworkImage(item)
                                      : FileImage(
                                          item,
                                        ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          if (!_readOnly)
                            InkWell(
                              onTap: () {
                                field.didChange([...field.value]..remove(item));
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.7),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                height: 22,
                                width: 22,
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList()),
                    if (!_readOnly && !_hasMaxImages)
                      GestureDetector(
                        child: Container(
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color(getColorHexFromStr("#F8F8F8")),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Image.asset("assets/icons/camera.png",
                                width: 40,
                                height: 40,
                                color: _readOnly
                                    ? Theme.of(context).disabledColor
                                    : widget.iconColor ?? Colors.black),
                          ),
                          // color: (_readOnly
                          //         ? Theme.of(context).disabledColor
                          //         : widget.iconColor ??
                          //             Theme.of(context).primaryColor)
                          //     .withAlpha(50),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return ImageSourceSheet(
                                maxHeight: widget.maxHeight,
                                maxWidth: widget.maxWidth,
                                imageQuality: widget.imageQuality,
                                preferredCameraDevice:
                                    widget.preferredCameraDevice,
                                onImageSelected: (image) {
                                  field.didChange([...field.value, image]);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
