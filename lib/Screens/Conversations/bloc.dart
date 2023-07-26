import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:orghub/Helpers/prefs.dart';
import 'package:orghub/Helpers/server_gate.dart';
import 'package:orghub/Screens/Conversations/events.dart';
import 'package:orghub/Screens/Conversations/model.dart';
import 'package:orghub/Screens/Conversations/states.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class GetAllChatsBloc extends Bloc<GetAllChatsEvents, GetAllChatsStates> {
  GetAllChatsBloc() : super(GetAllChatsStates());

  ServerGate serverGate = ServerGate();
  List<Conversation> conversations = [];

  @override
  Stream<Transition<GetAllChatsEvents, GetAllChatsStates>> transformEvents(
    Stream<GetAllChatsEvents> events,
    Stream<Transition<GetAllChatsEvents, GetAllChatsStates>> Function(
      GetAllChatsEvents event,
    )
        transitionFn,
  ) {
    if (events is GetAllChatsSearchEventStart) {
      return events
          .debounceTime(const Duration(seconds: 3))
          .switchMap(transitionFn);
    } else {
      return events.switchMap(transitionFn);
    }
  }

  @override
  void onTransition(
      Transition<GetAllChatsEvents, GetAllChatsStates> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<GetAllChatsStates> mapEventToState(GetAllChatsEvents event) async* {
    if (event is GetAllChatsEventsStart) {
      yield GetAllChatsStatesStart();
      CustomResponse response =
          await fetchAllChats(term: event.term, pageNum: event.pageNum);
      if (response.success) {
        AllChatsModel allChatsModel =
            AllChatsModel.fromJson(response.response.data);
        conversations = allChatsModel.data;

        if (allChatsModel.meta.total == 0) {
          yield GetAllChatsStatesNoData();
        } else {
          yield GetAllChatsStatesCompleted(
            empty: false,
            conversations: conversations,
            hasReachedPageMax:
                allChatsModel.data.length < allChatsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: false,
          );
        }

        // yield GetAllChatsStatesSuccess(conversations: conversations);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllChatsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllChatsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllChatsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    } 
    if (event is GetAllChatsSearchEventStart) {
      print("=-=-=-=-= here ya prince =-=-=-=>>>>>");
      yield GetAllChatsStatesStart();
      CustomResponse response =
          await fetchAllChats(term: event.term, pageNum: event.pageNum);
      if (response.success) {
        AllChatsModel allChatsModel =
            AllChatsModel.fromJson(response.response.data);
        conversations = allChatsModel.data;

        if (allChatsModel.meta.total == 0) {
          yield GetAllChatsStatesNoData();
        } else {
          yield GetAllChatsStatesCompleted(
            empty: false,
            conversations: conversations,
            hasReachedPageMax:
                allChatsModel.data.length < allChatsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: false,
          );
        }

        // yield GetAllChatsStatesSuccess(conversations: conversations);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllChatsStatesFailed(
            errType: 0,
            statusCode: response.statusCode,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllChatsStatesFailed(
            errType: 1,
            statusCode: response.statusCode,
            msg: response.error['message'],
          );
        } else {
          yield GetAllChatsStatesFailed(
            errType: 2,
            statusCode: response.statusCode,
            msg: "Server error , please try again",
          );
        }
      }
    }
    else if (event is GetNextChatsEvent) {
      // yield GetAllChatsStatesStart();
      CustomResponse response =
          await fetchAllChats(term: event.term, pageNum: event.pageNum);
      if (response.success) {
        AllChatsModel allChatsModel =
            AllChatsModel.fromJson(response.response.data);
        conversations.addAll(allChatsModel.data);

        if (allChatsModel.meta.lastPage > 0 &&
            (allChatsModel.meta.currentPage >= allChatsModel.meta.lastPage)) {
          yield GetAllChatsStatesCompleted(
            empty: false,
            conversations: conversations,
            hasReachedPageMax:
                allChatsModel.data.length < allChatsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: true,
          );
        } else {
          yield GetAllChatsStatesCompleted(
            empty: false,
            conversations: conversations,
            hasReachedPageMax:
                allChatsModel.data.length < allChatsModel.meta.perPage
                    ? true
                    : false,
            hasReachedEndOfResults: false,
          );
        }
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());

        if (response.errType == 0) {
          yield GetAllChatsStatesFailed(
            errType: 0,
            msg: "Network error ",
          );
        } else if (response.errType == 1) {
          yield GetAllChatsStatesFailed(
            errType: 1,
            msg: response.error['message'],
          );
        } else {
          yield GetAllChatsStatesFailed(
            errType: 2,
            msg: "Server error , please try again",
          );
        }
      }
    }
  }

  Future<CustomResponse> fetchAllChats({String term, int pageNum}) async {
    serverGate.addInterceptors();

    CustomResponse response = await serverGate.getFromServer(
      url: term == null
          ? "client/chats?page=$pageNum"
          : "client/chats?page=$pageNum&filter=$term",
      headers: {
        "Accept": "application/json",
        "lang": translator.currentLanguage == 'en' ? "en" : "ar",
        "Authorization": "Bearer ${await Prefs.getStringF("authToken")}",
      },
    );
    return response;
  }
}
