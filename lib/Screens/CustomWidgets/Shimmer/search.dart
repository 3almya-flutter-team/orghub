import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget gridViewSearchShimmer(BuildContext context) {
  return GridView.builder(
    itemCount: 24,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: .92),
    itemBuilder: (BuildContext context, int index) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.black12.withOpacity(0.1),
                highlightColor: Colors.black.withOpacity(0.2),
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red,width: 3),borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 110,
                          width: MediaQuery.of(context).size.width * .44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 4, bottom: 4),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: 12.0,
                              color: Colors.red,
                            ),
                          ),
                         
                          Container(
                            width: MediaQuery.of(context).size.width * .2,
                            height: 12.0,
                            color: Colors.red,
                          ),
                          SizedBox(height: 6,),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    },
  );
}
