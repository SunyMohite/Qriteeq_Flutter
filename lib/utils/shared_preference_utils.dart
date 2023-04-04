import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';

import '../service/app_notification.dart';

class PreferenceManagerUtils {
  static GetStorage getStorage = GetStorage();

  static String loginToken = "loginToken";
  static String loginId = "loginId";
  static String isUserName = "UserName";
  static String isUserFullName = "UserFullName";
  static String userCountryCode = "UserCountryCode";
  static String userCountryCodeNumber = "UserCountryCodeNumber";
  static String userMobileNumber = "UserMobileNumber";
  static String userAvatar = "UserAvatar";
  static String qrCodeUrl = "qrCodeUrl";
  static String fcmToken = "fcmToken";
  static String deepLinkReferral = "deepLinkReferral";
  static String customerId = "customerId";
  static String contactNumber = "ContactNumber";
  static String referralCode = "referralCode";
  static String referralCodeDeepLink = "referralCodeDeepLink";
  static String qrCodeUrlDeepLink = "qrCodeUrlDeepLink";
  static String recentLocalSearchList = "recentLocalSearchList";
  static String isSuggest = "isSuggest";
  static String permissionDialog = 'permissionDialog';
  static String isLoginVia = 'isLoginVia';
  static String flagUrl = 'flagUrl';
  static String countryName = 'countryName';

  ///isLoginVia
  static Future setIsLoginVia(String? value) async {
    await getStorage.write(isLoginVia, value);
  }

  static String getIsLoginVia() {
    return getStorage.read(isLoginVia) ?? '';
  }

  ///isLoginVia
  static Future setUserMobileNumber(String? value) async {
    await getStorage.write(userMobileNumber, value);
  }

  static String getUserMobileNumber() {
    return getStorage.read(userMobileNumber) ?? '';
  }

  ///flagUrl
  static Future setFlagUrl(String? value) async {
    await getStorage.write(flagUrl, value);
  }

  static String getFlagUrl() {
    return getStorage.read(flagUrl) ?? '';
  }

  ///countryName
  static Future setCountryName(String? value) async {
    await getStorage.write(countryName, value);
  }

  static String getCountryName() {
    return getStorage.read(countryName) ?? '';
  }

  ///qrCode DeepLink
  static Future setRecentLocalSearchList(String? value) async {
    await getStorage.write(recentLocalSearchList, value);
  }

  static String getRecentLocalSearchList() {
    return getStorage.read(recentLocalSearchList) ?? '';
  }

  ///qrCode DeepLink
  static Future setQrCodeUrlDeepLink(String? value) async {
    await getStorage.write(qrCodeUrlDeepLink, value);
  }

  static String getQrCodeUrlDeepLink() {
    return getStorage.read(qrCodeUrlDeepLink) ?? '';
  }

  ///setReferralCodeDeepLink
  static Future setReferralCodeDeepLink(String? value) async {
    await getStorage.write(referralCodeDeepLink, value);
  }

  static String getReferralCodeDeepLink() {
    return getStorage.read(referralCodeDeepLink) ?? '';
  }

  ///Login User ReferralCode
  static Future setReferralCode(String? value) async {
    await getStorage.write(referralCode, value);
  }

  static String getReferralCode() {
    return getStorage.read(referralCode) ?? '';
  }

  ///CUSTOMER ID
  static Future setCustomerId(String? value) async {
    await getStorage.write(customerId, value);
  }

  static String getCustomerId() {
    return getStorage.read(customerId) ?? '';
  }

  ///CONTACT NUMBER
  static Future setContactNumber(List<Contact> value) async {
    // List<dynamic> oldSavedList = jsonDecode(value);
    List<Map> data = value.map((e) => e.toMap()).toList();

    await getStorage.write(contactNumber, jsonEncode(data));
  }

  static String getContactNumber() {
    return getStorage.read(contactNumber) ?? "[]";
  }

  ///qrCode
  static Future setQrCodeUrl(String? value) async {
    await getStorage.write(qrCodeUrl, value);
  }

  static String getQrCodeUrl() {
    return getStorage.read(qrCodeUrl) ?? '';
  }

  ///FcmToken
  static Future setFcmToken(String? value) async {
    await getStorage.write(fcmToken, value);
  }

  static String getFcmToken() {
    return getStorage.read(fcmToken) ?? '';
  }

  ///DeepLinkReferral Code
  static Future setDeepLinkReferral(String? value) async {
    await getStorage.write(deepLinkReferral, value);
  }

  static String getDeepLinkReferral() {
    return getStorage.read(deepLinkReferral) ?? '';
  }

  ///LoginToken
  static Future setLoginToken(String value) async {
    await getStorage.write(loginToken, value);
  }

  static String getLoginToken() {
    return getStorage.read(loginToken) ?? '';
  }

  ///LoginId
  static Future setLoginId(String value) async {
    await getStorage.write(loginId, value);
  }

  static String getLoginId() {
    return getStorage.read(loginId) ?? '';
  }

  ///AvatarUserName
  static Future setAvatarUserName(String value) async {
    await getStorage.write(isUserName, value);
  }

  static String getAvatarUserName() {
    return getStorage.read(isUserName) ?? '';
  }

  ///AvatarUserFullName
  static Future setAvatarUserFullName(String value) async {
    await getStorage.write(isUserFullName, value);
  }

  static String getAvatarUserFullName() {
    return getStorage.read(isUserFullName) ?? '';
  }

  ///User Country code
  static Future setUserCountryCode(String value) async {
    await getStorage.write(userCountryCode, value);
  }

  static String getUserCountryCode() {
    return getStorage.read(userCountryCode) ?? '';
  }

  ///User Country code Number
  static Future setUserCountryCodeNumber(String value) async {
    await getStorage.write(userCountryCodeNumber, value);
  }

  static String getUserCountryCodeNumber() {
    return getStorage.read(userCountryCodeNumber) ?? '';
  }

  ///AvatarUser
  static Future setUserAvatar(String value) async {
    await getStorage.write(userAvatar, value);
  }

  static String getUserAvatar() {
    return getStorage.read(userAvatar) ?? '';
  }

  ///IsSuggest
  static Future setIsSuggest(String value) async {
    await getStorage.write(isSuggest, value);
  }

  static String getIsSuggest() {
    return getStorage.read(isSuggest) ?? '';
  }

  ///onLocationPermission
  static Future setPermissionDialog(String value) async {
    await getStorage.write(permissionDialog, value);
  }

  static String getPermissionDialog() {
    return getStorage.read(permissionDialog) ?? '';
  }

  /// CLEAR LOCAL DATA
  static Future clearLocalData() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.deleteToken();
    await getStorage.erase();
    await NotificationMethods.getFcmToken();
    await setIsSuggest('isSuggest');
    await PreferenceManagerUtils.setPermissionDialog("yes");
  }
}
