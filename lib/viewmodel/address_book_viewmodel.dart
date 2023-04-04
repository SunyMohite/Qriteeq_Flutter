import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_favorite_res_model.dart';
import 'package:humanscoring/modal/repo/address_book_repo.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/commonWidget/snackbar.dart';
import '../modal/apiModel/res_model/all_user_response_model.dart';
import '../modal/apiModel/res_model/get_contact_users_res_model.dart';
import '../modal/apis/api_response.dart';
import '../utils/const_utils.dart';

class AddressBookViewModel extends GetxController {
  ApiResponse addressBookApiResponse = ApiResponse.initial('Initial');
  ApiResponse favoriteApiResponse = ApiResponse.initial('Initial');

  ApiResponse allUserApiResponse = ApiResponse.initial('Initial');
  ApiResponse allContactApiResponse = ApiResponse.initial('Initial');
  ApiResponse existingUserApiResponse = ApiResponse.initial('Initial');
  List<AllUserData> _apiContactList = [];
  List<Contact> mobileFilterList = [];
  String _selectedString = "";
  String? _setUserAvatar = PreferenceManagerUtils.getUserAvatar();

  String? get setUserAvatar => _setUserAvatar;

  set setUserAvatar(String? value) {
    _setUserAvatar = value ?? PreferenceManagerUtils.getUserAvatar();
    update();
  }

  String get selectedString => _selectedString;

  set selectedString(String value) {
    _selectedString = value;
    update();
  }

  set initSelectedString(String value) {
    _selectedString = value;
  }

  void addSearchMobileResult(Contact contact) {
    mobileFilterList.add(contact);
    update();
  }

  bool _isSearch = false;

  bool get isSearch => _isSearch;

  void setIsSearch(bool value) {
    _isSearch = value;
    update();
  }

  List<AllUserData> get apiContactList => _apiContactList;

  set apiContactList(List<AllUserData> value) {
    _apiContactList = value;
    update();
  }

  bool _isContactLoading = true;

  bool get isContactLoading => _isContactLoading;

  set isContactLoading(bool value) {
    _isContactLoading = value;
    update();
  }

  List<Contact> contactList = [];

  List<Contact> pageNationContactList = [];
  bool isContactFirstLoading = true, _isContactMoreLoading = false;
  get isContactMoreLoading => _isContactMoreLoading;

  Future<void> pagenationGetContactList({
    bool? initLoad = true,
  }) async {
    if (pageNationContactList.isNotEmpty) {
      _isContactMoreLoading = true;
    }
    if (initLoad == true) {
      update();
    }

    _isContactLoading = true;
    contactList = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
        androidLocalizedLabels: false);
    pageNationContactList.addAll(contactList);
    _isContactMoreLoading = false;
    isContactFirstLoading = false;
    _isContactLoading = false;
    await PreferenceManagerUtils.setContactNumber(contactList);
    update();
  }

  Future<void> getContactAddToAPIList() async {
    try {
      var status = await Permission.contacts.request();
      logs("status.isGranted ${status.isGranted}");

      if (status.isPermanentlyDenied) {
      } else if (status.isGranted) {
        List<String> listContact = [];
        contactList = await ContactsService.getContacts(
            withThumbnails: false,
            photoHighResolution: false,
            iOSLocalizedLabels: false,
            androidLocalizedLabels: false);
        for (var e in contactList) {
          if (e.phones != null) {
            if (e.phones!.isNotEmpty) {
              listContact
                  .add(e.phones!.last.value!.toString().replaceAll(" ", ""));
            }
          }
        }
        AddressBookRepo().addAllContactRepo(listContact);
        _isContactLoading = false;
        await PreferenceManagerUtils.setContactNumber(contactList);
      }
    } on Exception catch (e) {
      // TODO
      showSnackBar(message: "Need contact permission for better experience");
    }
  }

  Future<void> getFavQriteeQUserList() async {
    getFavoriteViewModel();
  }

  ///===================getFavoriteViewModel=======================

  Future<void> getFavoriteViewModel() async {
    if (allUserApiResponse.status != Status.COMPLETE) {
      favoriteApiResponse = ApiResponse.loading('Loading');
    }
    try {
      GetFavoriteResModel response =
          await AddressBookRepo().getFavoriteBookRepo();

      favoriteApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('GetFavoriteResModel.......$e');
      favoriteApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///===================AllUserResponseModel=======================

  List<String> listContact = [];
  List<GetContactUsersResults>? getContactUsersResults = [];
  int contactUsersResultTotalData = 0;
  int contactUsersPage = 1;
  bool _isContactUsersMoreLoading = false;

  bool get isContactUsersMoreLoading => _isContactUsersMoreLoading;
  bool isContactUsersScrollLoading = false;
  Future<void> getExistingContactList({
    bool? initLoad = true,
  }) async {
    if (getContactUsersResults!.length >= contactUsersResultTotalData &&
        getContactUsersResults!.isNotEmpty) {
      return;
    }

    if (existingUserApiResponse.status != Status.COMPLETE) {
      existingUserApiResponse = ApiResponse.loading('Loading');
    } else {
      _isContactUsersMoreLoading = true;
    }
    if (initLoad == true) {
      update();
    }
    try {
      var status = await Permission.contacts.request();
      if (status.isGranted) {
        logs("status.contactList======== ${contactList.length}");

        if (contactList.isEmpty) {
          logs("status.isGranted======== ${status.isGranted}");

          contactList = await ContactsService.getContacts(
              withThumbnails: false,
              photoHighResolution: false,
              iOSLocalizedLabels: false,
              androidLocalizedLabels: false);
          for (var e in contactList) {
            if (e.phones != null) {
              if (e.phones!.isNotEmpty) {
                listContact
                    .add(e.phones!.last.value!.toString().replaceAll(" ", ""));
              }
            }
          }
        } else {
          listContact.clear();
          for (var e in contactList) {
            if (e.phones != null) {
              if (e.phones!.isNotEmpty) {
                listContact
                    .add(e.phones!.last.value!.toString().replaceAll(" ", ""));
              }
            }
          }
        }
        String? url = "user/getContactUsers?page=$contactUsersPage";
        logs("listContact ${listContact.length}");
        try {
          GetContactUsersResModel response =
              await AddressBookRepo().getAllContactRepo(listContact, url);
          existingUserApiResponse = ApiResponse.complete(response);
          contactUsersResultTotalData = response.data!.totalResults!;
          contactUsersPage += 1;
          getContactUsersResults!.addAll(response.data!.results!);
          isContactUsersScrollLoading = false;
          _isContactUsersMoreLoading = false;
        } catch (e) {
          getContactUsersResults!.clear();
          isContactUsersScrollLoading = false;
          _isContactUsersMoreLoading = false;
          log('existingUserApiResponse.......$e');
          existingUserApiResponse = ApiResponse.error('error');
        }
      } else {
        isContactUsersScrollLoading = false;
        logs("Need contact permission for better experience");
      }
    } on Exception catch (e) {
      // TODO
      isContactUsersScrollLoading = false;
      _isContactUsersMoreLoading = false;
      logs("Need contact permission for better experience");
    }

    update();
  }

  bool _isContactPermissionStatus = false;

  bool get isContactPermissionStatus => _isContactPermissionStatus;

  set isContactPermissionStatus(bool value) {
    _isContactPermissionStatus = value;
    update();
  }
}
