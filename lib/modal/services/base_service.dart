abstract class BaseService<T> {
  ///PRODUCTION URL...
  // final String baseUrl = 'https://api.qriteeq.com/v2/';

  ///DEV URL...
  final String baseUrl = 'https://dev.qriteeq.com/v1/';

  ///AUTH API URL...
  final String registerURL = 'auth/register';
  final String verifyOtp = 'auth/verify-otp';
  final String userName = 'user?id=';
  final String userAll = 'user/all';
  final String contactUsersAll = 'user/contactUsers';
  final String getContactUsers = 'user/getContactUsers';
  final String userApi = 'user';
  final String dashBoard = 'feedback/';
  final String getAllAddressBook = 'connection?type=contact&limit=5&page=1';
  final String getUserName = 'static?page=avatar';
  final String connection = 'connection';
  final String deleteConnection = 'connection?id=';
  final String deleteInteraction = 'feedback/interaction?id=';
  final String allFeed = 'feedback/allfeed';
  final String deleteFeed = 'feedback?id=';
  final String getFeedback = 'feedback?userId=';
  final String feedbackLike = 'feedback/interaction';
  final String search = 'search?title=';
  final String paymentCoin = 'payment/coin?feedbackId=';
  final String userWallet = 'user/wallet';
  final String leaderBoard = 'feedback/leaderboard';
  final String notification = 'notification';
  final String getUserTransactions = 'user/getUserTransactions';
  final String notificationRead = 'notification/read';
  final String activeFeedBack = 'feedback/activity?type=feedback';
  final String subScribeList = 'connection?type=subscribe';
  final String activityInteraction = 'feedback/activity?type=interaction';
  final String readStatus = 'feedback/status?';
  final String appVersion = 'app';
  final String referralBalance = 'user/referralBalance/';
  final String getFeedbackById = 'feedback/';
  final String getAmount = 'user/getAmount?coins=';
  final String featureRequest = 'featureRequest';
  final String getReports = 'user/getReports';
  final String campaign = 'campaign';
  final String dispute = 'feedback/dispute';
  final String userNameAvailability =
      'user/checkUserNameAvailability?username=';
  final String getUserProfile = "user/getUserProfile";
}
