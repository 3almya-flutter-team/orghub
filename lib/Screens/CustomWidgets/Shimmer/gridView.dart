import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Widget gridViewShimmer(BuildContext context){
  return   GridView.builder(
    itemCount: 24,
    // physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate:
    new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: .77),
    itemBuilder: (BuildContext context, int index) {
      return Container(
//        width: 140,
//        height: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Shimmer.fromColors(
            baseColor: Colors.black12.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
//              width: 140,
//              height: 200,
              margin: EdgeInsets.all(7),
            )),
      );
    },
  );
}