import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/appBar.dart';
import 'package:orghub/Helpers/app_theme.dart';
// import 'package:orghub/Helpers/colors.dart';
import 'package:orghub/Screens/MyComments/card.dart';
import 'package:orghub/Screens/MyProductDetails/widgets/card.dart';

class MyProductDetailsView extends StatefulWidget {
  @override
  _MyProductDetailsViewState createState() => _MyProductDetailsViewState();
}

class _MyProductDetailsViewState extends State<MyProductDetailsView> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: AppTheme.backGroundColor,
      appBar: appBar(
        context: context,
        leading: true,
        title: translator.currentLanguage == "en"
            ? "Product details"
            : "تفاصيل المنتج",
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Swiper(
                  itemBuilder: (context, int index) {
                    return Image(
                      image: NetworkImage(AppTheme.defaultImage),
                      fit: BoxFit.cover,
                    );
                  },
                  itemCount: 4,
                  pagination: new SwiperPagination(),
                  autoplay: true,
                  outer: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 260),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        myProductDetailsCard(
                            context: context,
                            onDeleteTapped: () {},
                            onEditTapped: () {},
                            type: "جديد",
                            description: "هذا النص مثال",
                            date: "11/11/2020",
                            rate: 4,
                            productName: "موبايل هواوي",
                            productId: "456",
                            brand: "هواوي",
                            category: "جوالات",
                            quantity: "2",
                            specifications: "specifications",
                            subCategory: "هواوي",
                            price: "123",
                            viewers: "123"),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                color: AppTheme.decorationColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      translator.currentLanguage == "en"
                                          ? "Comments & evaluations"
                                          : "التعليقات والتقيمات",
                                      style: TextStyle(
                                          color: AppTheme.accentColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    scrollDirection: Axis.vertical,
                                    primary: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return myCommentsCard(
                                          context: context,
                                          name: "Khaled Elsherbiny",
                                          date: "11/22/3333",
                                          stars: double.parse(
                                            "4",
                                          ),
                                          comment: "perfect product",
                                          img: AppTheme.defaultImage);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
