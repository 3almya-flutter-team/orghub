import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Widget shimmerHorizontalListView(BuildContext context){
  return    SizedBox(
    height: 140,
    child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              width: 140,
              height: 200,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Shimmer.fromColors(
                  baseColor: Colors.black12.withOpacity(0.1),
                  highlightColor: Colors.black.withOpacity(0.2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    width: 140,
                    height: 200,
                    margin: EdgeInsets.all(7),
                  )),
            ),
          );
        }),
  );
}