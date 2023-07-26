import 'package:flutter/material.dart';
import 'package:orghub/Helpers/app_theme.dart';

class SubCatWidget extends StatefulWidget {
  final String image;
  final String name;
  SubCatWidget({Key key, this.image, this.name}) : super(key: key);

  @override
  _SubCatWidgetState createState() => _SubCatWidgetState();
}

class _SubCatWidgetState extends State<SubCatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // width: 100,
      // padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppTheme.primaryColor,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            child: Image.network(
            widget.image ??  "https://images.unsplash.com/photo-1593642532973-d31b6557fa68?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1100&q=80",
              width: 40,
              fit: BoxFit.cover,
              height: 40,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
          widget.name ??  "اسم القسم الفرعى",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
