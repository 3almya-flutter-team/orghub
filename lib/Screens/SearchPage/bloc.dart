import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/SearchPage/events.dart';
import 'package:orghub/Screens/SearchPage/model.dart';
import 'package:orghub/Screens/SearchPage/states.dart';

class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  SearchBloc() : super(SearchStates());

  ServerGate serverGate = ServerGate();

  @override
  Stream<SearchStates> mapEventToState(SearchEvents event) async* {
    if (event is OnSearchEventsStart) {
      yield OnSearchStatesStart();
      CustomResponse response = await searchTool(filterData: event.filterData);
      if (response.success) {
        SearchResultsModel searchResultsModel =
            SearchResultsModel.fromJson(response.response.data);
        yield OnSearchStatesSuccess(
          searchResults: searchResultsModel.data,
        );
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield OnSearchStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield OnSearchStatesFailed(
            errType: 1,
              statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield OnSearchStatesFailed(
            errType: 2,
              statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> searchTool(
      {@required Map<String, dynamic> filterData}) async {
    serverGate.addInterceptors();
    print("filter data -=-=--=-=-=> ${filterData.toString()}");
    CustomResponse response = await serverGate.getFromServer(
      url: "search",
      headers: {
        "Accept": "application/json",
      },
      params: filterData,
    );
    return response;
  }
}
