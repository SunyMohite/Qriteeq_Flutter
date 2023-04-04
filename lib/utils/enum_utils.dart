/// API CALLING METHOD
enum APIType { aPost, aGet, aDelete, aPut }

/// API HEADER TYPE
enum APIHeaderType {
  fileUploadWithToken,
  fileUploadWithoutToken,
  jsonBodyWithToken,
  jsonBodyWithoutToken,
  onlyToken
}

enum FileExt { image, video, doc }

enum ValidationType { password, email, pNumber, name, username }

enum UserNameCheck {initial, checking, error, success }

enum AppState {
  free,
  picked,
  cropped,
}

enum ProfileStatus {
  shareProfile,
  viewfullprofile,
  flagProfile,
  generateReport,
  block,
  unBlock,
}

enum ProfileScreenOption {
  shareViaQr,
  checkDPRating,
  chatwithModerator,
  userActivity,
  leaderBoard,
  userReport,
  featureRequest,
  faqS,
  logOut,
  deleteAccount,
}

enum LeaderBoardTab { nearBy, myCountry, global }
