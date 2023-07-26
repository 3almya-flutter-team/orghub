import 'package:flutter/material.dart';

Widget textField(
    {String hintText,
    Function validator,
    Function onSaved,
    Widget icon,
    bool enabled,
    bool obSecure,
    TextEditingController controller}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: obSecure,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              suffixIcon: icon,
              contentPadding: EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.2),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 13)),
          validator: validator,
          onSaved: onSaved),
    ),
  );
}
