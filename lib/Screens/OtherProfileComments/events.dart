import 'package:flutter/foundation.dart';

class GetAllCompanyCommentsEvents {}

class GetAllCompanyCommentsEventsStart extends GetAllCompanyCommentsEvents {
  int companyId;
  GetAllCompanyCommentsEventsStart({
    @required this.companyId,
  });
}
