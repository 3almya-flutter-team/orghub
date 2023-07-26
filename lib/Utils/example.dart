// BlocBuilder(
//                       bloc: getAllSlidersBloc,
//                       builder: (context, state) {
//                         if (state is GetAllSlidersStateStart) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: SpinKitThreeBounce(
//                               color: AppTheme.primaryColor,
//                               size: 30,
//                             ),
//                           );
//                         } else if (state is GetAllSlidersStateSucess) {
//                           return Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.height / 4,
//                             child: Swiper(
//                               itemBuilder: (BuildContext context, int index) {
//                                 return new Image.network(
//                                   state.allSliders[index].image ??
//                                       "http://via.placeholder.com/350x150",
//                                   fit: BoxFit.fill,
//                                 );
//                               },
//                               itemCount: state.allSliders.length,
//                               pagination: new SwiperPagination(),
//                               control: new SwiperControl(),
//                             ),
//                           );
//                         } else if (state is GetAllSlidersStateFaild) {
//                           if (state.errType == 0) {
//                             FlashHelper.errorBar(context,
//                                 message: translator.currentLanguage == 'en' ? "Please check your network connection.": "برجاء التاكد من الاتصال بالانترنت ");
//                             return Text("Net work error");
//                           } else {
//                             // FlashHelper.errorBar(context,
//                             //     message: state.msg ?? "");
//                             return Container();
//                           }
//                         } else {
//                           // FlashHelper.errorBar(context,
//                           //     message: state.msg ?? "");
//                           return Container();
//                         }
//                       }),
