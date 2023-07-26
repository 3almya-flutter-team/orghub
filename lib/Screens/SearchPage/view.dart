import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:orghub/Helpers/app_theme.dart';
import 'package:orghub/Screens/BottomNavigation/view.dart';
import 'package:orghub/Screens/CustomWidgets/ProductCards/ProductCard.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddRate/bloc.dart';
import 'package:orghub/Screens/ProductDetails/view.dart';
import 'package:orghub/Screens/SearchPage/bloc.dart';
import 'package:orghub/Screens/SearchPage/events.dart';
import 'package:orghub/Screens/SearchPage/states.dart';
import 'package:orghub/Utils/CommonAppWidgets/error_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/filter_dialog_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/no_internet_widget.dart';
import 'package:orghub/Utils/CommonAppWidgets/search_bar_widget.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class SearchScreen extends StatefulWidget {
  // final List<SearchItem> searchResults;
  final String type; // filter or search
  final Map<String, dynamic> filterData;
  SearchScreen({Key key, this.type, this.filterData}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AfterLayoutMixin {
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

  SearchBloc searchBloc = kiwi.KiwiContainer().resolve<SearchBloc>();

  @override
  void initState() {
    _controller = TextEditingController()..addListener(_search);
    _focusNode = FocusNode();

    super.initState();
  }

  void _search() {
    if (_controller.text.isNotEmpty) {
      searchBloc.add(
        OnSearchEventsStart(
          filterData: {
            "keyword": _controller.text,
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    searchBloc.close();
    super.dispose();
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  Widget noItems() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Image.asset("assets/icons/init_search.png"),
    );
  }

  void showFilterDialog({@required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialogWidget(
          term: _controller.text,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  // color: AppTheme.primaryColor,
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(BottomNavigationView());
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: _buildSearchBox(),
                      ),
                      InkWell(
                        onTap: () {
                          showFilterDialog(context: context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.filter_list,
                            size: 30,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                BlocBuilder(
                  bloc: searchBloc,
                  builder: (context, state) {
                    if (state is OnSearchStatesStart) {
                      return SpinKitFadingCircle(
                        size: 30,
                        color: AppTheme.primaryColor,
                      );
                    } else if (state is OnSearchStatesSuccess) {
                      return state.searchResults.isEmpty
                          ? noItems()
                          : ListView.builder(
                              itemCount: state.searchResults.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return productCard(
                                    context: context,
                                    onTap: () {
                                      Get.to(
                                        MultiBlocProvider(
                                            providers: [
                                              BlocProvider<RateAdvertBloc>(
                                                create:
                                                    (BuildContext context) =>
                                                        RateAdvertBloc(),
                                              ),
                                              BlocProvider<AddAdvertToFavBloc>(
                                                create:
                                                    (BuildContext context) =>
                                                        AddAdvertToFavBloc(),
                                              ),
                                            ],
                                            child: ProductDetailsView(
                                              advertId:
                                                  state.searchResults[index].id,
                                              adType: state
                                                  .searchResults[index].adType,
                                              myAdvert: false,
                                            )),
                                      );
                                    },
                                    isMine: false,
                                    name: state.searchResults[index].name,
                                    organizationName: state.searchResults[index].organizationName,
                                    img: state.searchResults[index].image,
                                    address:
                                        state.searchResults[index].address ??
                                            "",
                                    brandName: state.searchResults[index]
                                            .adOwner.name ??
                                        "",
                                    price:
                                        state.searchResults[index].price ?? "",
                                    currency:
                                        state.searchResults[index].currency.name ?? "",
                                    description:
                                        state.searchResults[index].desc ?? "",
                                    onToggleTapped: () {},
                                    isFav:
                                        state.searchResults[index].isFavourite);
                              },
                            );
                    } else if (state is OnSearchStatesFailed) {
                      if (state.errType == 0) {
                        return noInternetWidget(context);
                      } else {
                        return errorWidget(context, state.msg,state.statusCode);
                      }
                    } else {
                      return noItems();
                    }
                  },
                ),
                // noItems(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.type == "filter") {
      showFilterDialog(context: context);
    } else if (widget.type == "afterFilter") {
      searchBloc.add(OnSearchEventsStart(filterData: widget.filterData));
    }
  }
}
