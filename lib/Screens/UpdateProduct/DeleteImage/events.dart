import 'package:flutter/foundation.dart';

class DeleteImageEvents {}

class DeleteImageEventsStart extends DeleteImageEvents {
  int imageId;
  DeleteImageEventsStart({
    @required this.imageId,
  });
}
