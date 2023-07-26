import 'package:kiwi/kiwi.dart';
import 'package:orghub/ComonServices/AllClassificationsService/bloc.dart';
import 'package:orghub/ComonServices/AllCurrenciesService/bloc.dart';
import 'package:orghub/ComonServices/AllMarksService/bloc.dart';
import 'package:orghub/ComonServices/AllSpecificationsService/bloc.dart';
import 'package:orghub/ComonServices/AllSubCategories/bloc.dart';
import 'package:orghub/ComonServices/AllTagsService/bloc.dart';
import 'package:orghub/ComonServices/CityService/bloc.dart';
import 'package:orghub/ComonServices/CountryService/bloc.dart';
import 'package:orghub/ComonServices/GetAllRecursionCats/bloc.dart';
import 'package:orghub/ComonServices/GetCurrentLocation/bloc.dart';
import 'package:orghub/ComonServices/GetUserType/bloc.dart';
import 'package:orghub/Screens/AllComments/bloc.dart';
import 'package:orghub/Screens/AllMostRequired/AllBuyingAdverts/bloc.dart';
import 'package:orghub/Screens/AllMostSalling/MostSellingAdverts/bloc.dart';
import 'package:orghub/Screens/AppInfo/About/bloc.dart';
import 'package:orghub/Screens/AppInfo/Policy/bloc.dart';
import 'package:orghub/Screens/Auth/CheckCode/bloc.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_bloc.dart';
import 'package:orghub/Screens/Auth/ForgetPassword/bloc.dart';
import 'package:orghub/Screens/Auth/LogoutService/bloc.dart';
import 'package:orghub/Screens/Auth/ResetPassword/bloc.dart';
import 'package:orghub/Screens/Categories/GetAdsInCategory/bloc.dart';
import 'package:orghub/Screens/Chat/ChatBloc/bloc.dart';
import 'package:orghub/Screens/Chat/DownloadFileBloc/bloc.dart';
import 'package:orghub/Screens/Chat/SendMessageBloc/bloc.dart';
import 'package:orghub/Screens/Complaints&Suggestions/bloc.dart';
import 'package:orghub/Screens/Conversations/Delete/bloc.dart';
import 'package:orghub/Screens/Conversations/bloc.dart';
import 'package:orghub/Screens/Favourite/RemoveFromFav/bloc.dart';
import 'package:orghub/Screens/Favourite/bloc.dart';
import 'package:orghub/Screens/Home/AllCategories/bloc.dart';
import 'package:orghub/Screens/Home/AllSliders/bloc.dart';
import 'package:orghub/Screens/Home/MostBuyingAdverts/bloc.dart';
import 'package:orghub/Screens/Home/MostSellingAdverts/bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/GetAddress/address_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/LocationService/location_service_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/MarkerBloc/marker_bloc.dart';
import 'package:orghub/Screens/MapPage/Bloc/map_bloc.dart';
import 'package:orghub/Screens/MyComments/bloc.dart';
import 'package:orghub/Screens/MyProducts/bloc.dart';
import 'package:orghub/Screens/Notifications/DeleteNotification/bloc.dart';
import 'package:orghub/Screens/Notifications/bloc.dart';
import 'package:orghub/Screens/OfferDetail/AcceptOffer/bloc.dart';
import 'package:orghub/Screens/OfferDetail/DeleteOffer/bloc.dart';
import 'package:orghub/Screens/OfferDetail/bloc.dart';
import 'package:orghub/Screens/OffersHistory/bloc.dart';
import 'package:orghub/Screens/OrderDetail/ClientCancelOrder/bloc.dart';

import 'package:orghub/Screens/OrderDetail/DeleteOrder/bloc.dart';
import 'package:orghub/Screens/OrderDetail/OrderIsReady/bloc.dart';
import 'package:orghub/Screens/OrderDetail/OwnerRefuseOrder/bloc.dart';
import 'package:orghub/Screens/OrderDetail/Preparing/bloc.dart';
import 'package:orghub/Screens/OrderDetail/bloc.dart';
import 'package:orghub/Screens/OrdersHistory/BuyingOrders/bloc.dart';
import 'package:orghub/Screens/OrdersHistory/SellingOrders/bloc.dart';
import 'package:orghub/Screens/OrdersOnMyAds/BuyingOrders/bloc.dart';
import 'package:orghub/Screens/OrdersOnMyAds/SellingOrders/bloc.dart';
import 'package:orghub/Screens/OtherProfileComments/bloc.dart';
import 'package:orghub/Screens/OtherServices/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AdOffers/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AdReviews/bloc.dart';
import 'package:orghub/Screens/ProductDetails/AddFavorite/bloc.dart';
import 'package:orghub/Screens/ProductDetails/DeleteAdvert/bloc.dart';
import 'package:orghub/Screens/ProductDetails/RelatedAds/bloc.dart';
import 'package:orghub/Screens/ProductDetails/Report/ReasonsBloc/bloc.dart';
import 'package:orghub/Screens/ProductDetails/Report/bloc.dart';
import 'package:orghub/Screens/ProductDetails/SendOffer/bloc.dart';
import 'package:orghub/Screens/ProductDetails/bloc.dart';
import 'package:orghub/Screens/Profile/AddRate/bloc.dart';
import 'package:orghub/Screens/Profile/OtherComments/bloc.dart';
import 'package:orghub/Screens/Profile/OtherProducts/bloc.dart';
import 'package:orghub/Screens/Profile/bloc.dart';
import 'package:orghub/Screens/SearchPage/bloc.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/bloc.dart';
import 'package:orghub/Screens/UpdatePassword/bloc.dart';
import 'package:orghub/Screens/UpdateProduct/DeleteImage/bloc.dart';
import 'package:orghub/Screens/UpdateUserProfile/bloc.dart';

void initKiwi() {
  KiwiContainer container = KiwiContainer();

  // GET ALL COUNTRIES SERVICE
  container.registerFactory(
    (c) => GetAllCountries(),
  );
  container.registerFactory(
    (c) => AppInitBloc(),
  );
  container.registerFactory(
    (c) => ContactBloc(),
  );
  container.registerFactory(
    (c) => GetAboutDataBloc(),
  );
  container.registerFactory(
    (c) => GetPolicyDataBloc(),
  );
  container.registerFactory(
    (c) => GetReportReasonsBloc(),
  );
  container.registerFactory(
    (c) => SendReportBloc(),
  );
  container.registerFactory(
    (c) => ChatsDeleteBloc(),
  );
  container.registerFactory(
    (c) => GetCategoryAdsBloc(),
  );

  // GET ALL CITIES SERVICE
  container.registerFactory(
    (c) => GetAllCitiesBloc(),
  );

  // GET ALL TAGS SERVICE
  container.registerFactory(
    (c) => GetAllTagsBloc(),
  );

  // GET ALL MARKS SERVICE
  container.registerFactory(
    (c) => GetAllMarksBloc(),
  );

  // GET ALL Specifications SERVICE
  container.registerFactory(
    (c) => GetAllSpecificationsBloc(),
  );

  // GET ALL Classifications SERVICE
  container.registerFactory(
    (c) => GetAllClassificationsBloc(),
  );

  // GET ALL Currencies SERVICE
  container.registerFactory(
    (c) => GetAllCurrenciesBloc(),
  );

  container.registerFactory(
    (c) => GetAllSlidersBloc(),
  );
  container.registerFactory(
    (c) => GetAllCategoriesBloc(),
  );
  container.registerFactory(
    (c) => GetMostBuyingAdvertsBloc(),
  );
  container.registerFactory(
    (c) => GetMostSellingAdvertsBloc(),
  );
  container.registerFactory(
    (c) => GetAllSellingAdvertsBloc(),
  );
  container.registerFactory(
    (c) => GetAllBuyingAdvertsBloc(),
  );
  container.registerFactory(
    (c) => GetSingleAdvertDataBloc(),
  );
  container.registerFactory(
    (c) => GetSomeAdvertReviewsBloc(),
  );
  container.registerFactory(
    (c) => GetRelatedAdvertsBloc(),
  );
  container.registerFactory(
    (c) => GetProfileDataBloc(),
  );
  container.registerFactory(
    (c) => GetCompanyProfileDataBloc(),
  );
  container.registerFactory(
    (c) => GetAllChatsBloc(),
  );
  container.registerFactory(
    (c) => GetSingleChatBloc(),
  );
  container.registerFactory(
    (c) => SendMessageBloc(),
  );
  container.registerFactory(
    (c) => GetMyProductsBloc(),
  );
  container.registerFactory(
    (c) => AddAdvertToFavBloc(),
  );
  container.registerFactory(
    (c) => GetAllFavAdsBloc(),
  );
  container.registerFactory(
    (c) => SendOfferBloc(),
  );
  container.registerFactory(
    (c) => GetMyOrdersBloc(),
  );
  container.registerFactory(
    (c) => GetMySellingOrdersBloc(),
  );
  container.registerFactory(
    (c) => GetSingleBuyinOrder(),
  );
  container.registerFactory(
    (c) => RateUserBloc(),
  );
  container.registerFactory(
    (c) => ChangeOrderStatusBloc(),
  );
  container.registerFactory(
    (c) => GetCurrentLocationBloc(),
  );
  container.registerFactory(
    (c) => GetUserTypeBloc(),
  );
  container.registerFactory(
    (c) => DeleteAdvertBloc(),
  );
  container.registerFactory(
    (c) => GetUserProfileDataBloc(),
  );
  container.registerFactory(
    (c) => GetAllCommentsBloc(),
  );
  container.registerFactory(
    (c) => SearchBloc(),
  );
  container.registerFactory(
    (c) => DownloadFileBloc(),
  );
  container.registerFactory(
    (c) => GetUserCommentsBloc(),
  );
  container.registerFactory(
    (c) => GetUserProductsBloc(),
  );
  container.registerFactory(
    (c) => GetNotificationsBloc(),
  );
  container.registerFactory(
    (c) => SendCodeBloc(),
  );
  container.registerFactory(
    (c) => CheckCodeBloc(),
  );
  container.registerFactory(
    (c) => ResetPasswordeBloc(),
  );
  container.registerFactory(
    (c) => LogoutBloc(),
  );
  container.registerFactory(
    (c) => GetAddOffersBloc(),
  );
  container.registerFactory(
    (c) => GetMyOffersBloc(),
  );
  container.registerFactory(
    (c) => GetSingleOfferBloc(),
  );
  container.registerFactory(
    (c) => DeleteOfferBloc(),
  );
  container.registerFactory(
    (c) => AcceptOfferBloc(),
  );
  container.registerFactory(
    (c) => GetAllAdsCommentsBloc(),
  );
  container.registerFactory(
    (c) => SelectOtherServiceBloc(),
  );
  container.registerFactory(
    (c) => GetOrdersOnMyAdsBloc(),
  );
  container.registerFactory(
    (c) => GetOrdersOnMySellingOrdersBloc(),
  );
  container.registerFactory(
    (c) => ClientCancelOrderBloc(),
  );
  container.registerFactory(
    (c) => DeleteOrderBloc(),
  );
  container.registerFactory(
    (c) => OwnerRefuseOrderBloc(),
  );
  container.registerFactory(
    (c) => PreparingOrderBloc(),
  );
  container.registerFactory(
    (c) => NotificationsDeleteBloc(),
  );
  container.registerFactory(
    (c) => UpdatePasswordBloc(),
  );
  container.registerFactory(
    (c) => GetAllCompanyCommentsBloc(),
  );
  container.registerFactory(
    (c) => RemoveFromFavBloc(),
  );
  container.registerFactory(
    (c) => GetAllSubCategoriesBloc(),
  );
  container.registerFactory(
    (c) => GetAllRecursionCategoriesBloc(),
  );
  container.registerFactory(
    (c) => MapBloc(),
  );

  container.registerFactory(
    (c) => LocationServiceBloc(),
  );
  container.registerFactory(
    (c) => AddMarkerToMapBloc(),
  );
  container.registerFactory(
    (c) => GetAddressBloc(),
  );
  container.registerFactory(
    (c) => DeleteImageBloc(),
  );
  
}
