import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';

class DisplayImageWidget extends StatelessWidget {
  final String imageUrl;
  DisplayImageWidget({Key key,@required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey[400],
            valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}
