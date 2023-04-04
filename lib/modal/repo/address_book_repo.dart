import 'package:humanscoring/modal/apiModel/res_model/get_address_book_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_favorite_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';

import '../apiModel/res_model/all_user_response_model.dart';
import '../apiModel/res_model/get_contact_users_res_model.dart';
import '../services/base_service.dart';

class AddressBookRepo extends BaseService {
  ///==========================AddressBook GetRepo====================

  Future<dynamic> getAddressBookRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getAllAddressBook,
    );
    GetAddressBookResModel getAddressBookResModel =
        GetAddressBookResModel.fromJson(response);
    return getAddressBookResModel;
  }
  ///==========================getAllUserRepo====================

  Future<AllUserResponseModel> getAllUserRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: userAll,
      // withToken: false,
    );

    AllUserResponseModel allUserResponseModel =
        AllUserResponseModel.fromJson(response);
    return allUserResponseModel;
  }
  ///==========================Add All ContactRepo====================

  Future<void> addAllContactRepo(List<String> contactList) async {
    await ApiService().getResponse(
        apiType: APIType.aPost,
        url: contactUsersAll,
        body: {"contacts": contactList}
        // withToken: false,
        );
  }
  ///=====================Favorite GetRepo=========================

  Future getFavoriteBookRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getAllAddressBook,
    );
    GetFavoriteResModel getFavoriteResModel =
        GetFavoriteResModel.fromJson(response);
    return getFavoriteResModel;
  }

  Future getAllContactRepo(List<String> contactList, String url) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: {"contacts": contactList}
        // withToken: false,
        );

    GetContactUsersResModel existingUserFromContactResModel =
        GetContactUsersResModel.fromJson(response);
    return existingUserFromContactResModel;
  }
}
