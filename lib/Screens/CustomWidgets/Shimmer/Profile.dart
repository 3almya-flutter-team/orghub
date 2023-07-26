import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Widget profileShimmer(BuildContext context){
  return  ListView(
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        child: Shimmer.fromColors(
            baseColor: Colors.black12.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                color: Colors.red,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.hashCode / 3,
              margin: EdgeInsets.all(7),
            )),
      ),
      SizedBox(
        height: 15,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return  Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Shimmer.fromColors(
                      baseColor: Colors.black12.withOpacity(0.1),
                      highlightColor: Colors.black.withOpacity(0.2),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        margin: EdgeInsets.all(7),
                      )),
                ),
              );
            }),
      )
    ],
  );
}