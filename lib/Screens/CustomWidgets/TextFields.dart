import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Helpers/colors.dart';

Widget passwordTextField(
    {BuildContext context,
    Function validator,
    Function onSaved,
    bool obscureText,
    Function onSuffixIconTapped,
    String hintText,
    TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      textAlign: TextAlign.center,
      obscureText: obscureText,
      style: TextStyle(
          fontFamily: AppTheme.fontName,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            color: Colors.red,
            fontSize: 13,
          ),
          contentPadding:
              EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
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
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppTheme.secondary2Color,
          fontSize: 9,
          ),
          suffixIcon: InkWell(
            onTap: onSuffixIconTapped,
            child: Icon(
              
              obscureText ? Icons.visibility_off : Icons.visibility,
              size: 18,
              color: AppTheme.secondaryColor,
            ),
          )),
    ),
  );
}

Widget txtField(
    {BuildContext context,
    Function validator,
    Function onSaved,
    dynamic initVal,
    String hintText,
    TextInputType textInputType,
    bool obscureText,
    TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      initialValue: initVal,
      textAlign: TextAlign.center,
      keyboardType: textInputType,
      obscureText: obscureText,
      style: TextStyle(
          fontFamily: AppTheme.fontName,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontFamily: AppTheme.fontName,
          color: Colors.red,
          fontSize: 13,
        ),
        contentPadding:
            EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
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
        focusColor: AppTheme.primaryColor,
        fillColor: Color(
          getColorHexFromStr("#FAFAFA"),
        ),
        enabled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppTheme.secondary2Color,
          fontSize: 9,
          // fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget technicalSupportTextFormField(
    {BuildContext context,
    Function validator,
    Function onSaved,
    String hintText,
    TextInputType textInputType,
    int maxLines,
    TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      maxLines: maxLines,
      keyboardType: TextInputType.text,
      style: TextStyle(
          fontFamily: AppTheme.fontName,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontFamily: AppTheme.fontName,
          color: Colors.red,
          fontSize: 13,
        ),
        contentPadding:
            EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(
          getColorHexFromStr("#FBFBFD"),
        ),
        enabled: true,
        hintText: hintText,
        hintStyle: TextStyle(
            color: AppTheme.secondaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget commentTextField(
    {BuildContext context, TextEditingController controller}) {
  return Container(
    width: MediaQuery.of(context).size.width - 100,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
          fontFamily: AppTheme.fontName,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontFamily: AppTheme.fontName,
          color: Colors.red,
          fontSize: 13,
        ),
        contentPadding:
            EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(
          getColorHexFromStr("#F7F8FA"),
        ),
        enabled: true,
        hintText: translator.currentLanguage == "en"
            ? "Write your commrnt here .."
            : "اكتب تعليقك هنا",
        hintStyle: TextStyle(
            color: AppTheme.secondaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget rateTextField({BuildContext context, TextEditingController controller}) {
  return Container(
    width: MediaQuery.of(context).size.width - 100,
    child: TextFormField(
      controller: controller,
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
        contentPadding:
            EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
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
            ? "Write your commrnt here .."
            : "اكتب تعليقك هنا",
        hintStyle: TextStyle(
            color: AppTheme.secondaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget biddingTextField(
    {BuildContext context,
    int number,
    Function onAddTapped,
    Function onMinusTapped,
    Function onSaved,
    Function onChanged,
    TextEditingController controller,
    Function validator}) {
  return Container(
    width: MediaQuery.of(context).size.width - 100,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      autofocus: true,
      validator: validator,
      readOnly: true,
      enabled: true,
      onChanged: onChanged,
      onSaved: onSaved,
      style: TextStyle(
          fontFamily: AppTheme.fontName,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontFamily: AppTheme.fontName,
          color: Colors.red,
          fontSize: 13,
        ),
        suffixIcon: IconButton(
          onPressed: onAddTapped,
          icon: Icon(
            Icons.add,
            color: AppTheme.secondaryColor,
          ),
        ),
        prefixIcon: IconButton(
          onPressed: onMinusTapped,
          icon: Icon(
            Icons.remove,
            color: AppTheme.secondaryColor,
          ),
        ),
        contentPadding:
            EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(
          getColorHexFromStr("#F7F8FA"),
        ),
        enabled: true,
        hintText: number.toString(),
        hintStyle: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w900),
      ),
    ),
  );
}

Widget searchTextFormFiled(
    {BuildContext context, Function onChange, Function onSearchTapped}) {
  return Padding(
    padding: EdgeInsets.only(right: 20, left: 20, top: 20),
    child: Container(
      height: 50,
      child: TextFormField(
        onChanged: onChange,
        keyboardType: TextInputType.text,
        style: TextStyle(color: AppTheme.primaryColor, fontSize: 15),
        decoration: InputDecoration(
            errorStyle: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
            ),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(getColorHexFromStr('#EAEAEA')), width: 1.0),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            suffixIcon: InkWell(
              onTap: onSearchTapped,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: AppTheme.primaryColor),
                  child: Center(
                    child: Image.asset(
                      "assets/icons/search-1.png",
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            fillColor: Color(
              getColorHexFromStr('#FAFAFA'),
            ),
            hintText:
                translator.currentLanguage == "en" ? "Search here" : "ابحث هنا",
            hintStyle: TextStyle(
                color: Color(getColorHexFromStr('#E1E1E1')),
                fontFamily: AppTheme.fontName,
                // fontWeight: FontWeight.bold,
                fontSize: 12)),
      ),
    ),
  );
}

Widget sizedBox() {
  return SizedBox(
    height: 15,
  );
}

Widget textFormFieldUpdate(
    {BuildContext context,
    Function(String) validator,
    TextInputType textInputType,
    Function(String) onSaved,
    String hint,
    bool secure,
    TextEditingController controller}) {
  return Padding(
    padding: EdgeInsets.only(
      right: 10,
      left: 10,
    ),
    child: TextFormField(
      onSaved: onSaved,
      validator: validator,
      keyboardType: textInputType,
      obscureText: secure,
      controller: controller,
      style: TextStyle(
          color: AppTheme.secondaryColor,
          fontSize: 15,
          fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Color(getColorHexFromStr('#FEFEFE')),
            fontSize: 13,
          ),
          filled: true,
          hintText: hint,
          fillColor: Colors.transparent,
          focusColor: AppTheme.secondaryColor,
          hintStyle: TextStyle(
              color: Color(getColorHexFromStr('#A3A3A3')),
              fontSize: 12,
              fontWeight: FontWeight.w500)),
    ),
  );
}
