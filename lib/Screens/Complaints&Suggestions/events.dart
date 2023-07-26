import 'package:flutter/material.dart';

class ContactEvents {}

class ContactEventsStart extends ContactEvents {
  String type;
  Map<String, dynamic> contactData;
  ContactEventsStart({
    @required this.contactData,
    @required this.type,
  });
}
