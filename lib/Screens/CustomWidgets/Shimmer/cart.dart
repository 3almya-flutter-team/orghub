import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
Widget shimmerVerticalListView({BuildContext context,double height}){
  return    ListView.builder(
      itemCount: 20,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {

        return  Shimmer.fromColors(
          baseColor: Colors.black12.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.red,
              ),
              width: MediaQuery.of(context).size.width,
              height: height,
              margin: EdgeInsets.all(7),
            ),
          ),
        );
      }
  );
}





