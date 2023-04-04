class VariableUtils {
  ///APPLICATION ID GET FROM APPSTORE CONNECT ACCOUNT....
  static List<String> feedBackStatusList = ['flagged', 'pending'];

  static List<Map<String, String>> typeReview = [
    {'key': 'Opinion', 'value': 'opinion'},
    {'key': 'True Story', 'value': 'trueStory'},
    {'key': 'Gossip', 'value': 'gossip'},
    {'key': 'Campaign', 'value': 'campaign'},
    {'key': 'General Feedback', 'value': 'generalFeedback'},
  ];
  static List<Map<String, String>> relationShip = [
    {
      'key': 'Friend',
      'value': 'friend',
    },
    {
      'key': 'Family',
      'value': 'family',
    },
    {
      'key': 'Acquaintance',
      'value': 'acquaintance',
    },
    {
      'key': 'Met Once',
      'value': 'once',
    },
    {
      'key': 'Colleague',
      'value': 'colleague',
    },
    {
      'key': 'Talked on the phone',
      'value': 'phone',
    },
    {
      'key': 'Never met',
      'value': 'never',
    },
  ];

  static List<String> title = [
    'YES',
    'NO',
  ];

  ///------------NO LOCALIZATION......
  static const userId = 'userId';
  static const phone = 'phone';
  static const email = 'email';
  static const profileUrl = 'profileUrl';

  ///------------NO LOCALIZATION......

  static List reporting = [
    VariableUtils.doNotLikeThis,
    VariableUtils.objectionable,
    VariableUtils.violence,
    VariableUtils.reportProfile,
  ];
  static List<String> imageFormatList = [
    '.JPG',
    '.PNG',
    '.GIF',
    '.WEBP',
    '.TIFF',
    '.PSD',
    '.RAW',
    '.BMP',
    '.HEIF',
    '.INDD',
    '.JPEG',
    '.SGI',
    '.TGA',
    '.OPENEXR',
  ];
  static List<String> audioFormatList = [
    '.3GP',
    '.MP4',
    '.MPA',
    '.ACC',
    '.TS',
    '.AMR',
    '.FLAC',
    '.MP3',
    '.OGG',
    '.MKV',
    '.WAV',
    '.MID',
    '.XMF',
    '.MXMF',
    '.RTTTL',
    '.RTX',
    '.OTA',
    '.IMY',
    '.AIFF',
    '.CAF'
  ];

  static List<String> documentFormatList = [
    '.PDF',
    '.DOC',
    '.DOCX',
    '.XLS',
    '.XLSX',
    '.PPT'
  ];
  static List<String> videoFormatList = [
    '.3GP',
    '.3G2',
    '.M4V',
    '.MKV',
    '.AVI',
    '.WEBM',
    '.MOV',
    '.MP4',
    'MTS/M2TS',
    '.MXF',
  ];

  ///FEEDPOST SCREEN

  static String fileNotExists = 'File not exists';
  static String fileDownloading = 'File downloading...';
  static String enableStoragePermission = 'Enable storage permission';
  static String fileDownloadFailed = 'File download failed';
  static String thankYou = 'Thank You!';
  static String galleryVideo = 'Gallery Video';
  static String galleryPhoto = 'Gallery Photo';
  static String cameraVideo = 'Camera Video';
  static String cameraPhoto = 'Camera Photo';
  static String writeYourFeedback = "Write Your Feedback";
  static String post = "Post";
  static String appStoreID = "1640951432";
  static String uriPrefix = 'https://firebase.qriteeq.com/';

  static String defaultUserPic =
      "https://ustart.s3.ap-south-1.amazonaws.com/1657173897927userIcon.png";
  static String countryCode = "IN";
  static String userAllFeedBackScreen = "ALL FEEDBACK";
  static String youPosted = "POSTED BY YOU";

  static String myDownloads = "MY DOWNLOADS";
  static String downloadsForMe = "DOWNLOADS FOR ME";
  static String beFirstFeedback = "Be the first to give a feedback";
  static String countryCodeNumber = "+91";
  static String submit = 'Submit';

  ///LOGIN SCREEN
  static const getStart = "Get Start with";
  static const oR = "OR";

  // static const iAcceptThe = "I accept the ";
  static const iAcceptThe =
      "I confirm that I am above 13 years of age and agree to all ";

  static const termsOfServices = "Terms of Services";

  static const fileDownloadSuccess = 'File Download Successfully';

  static const signInWithPhoneNumber = " Sign-in with Phone Number";
  static const signInWithEmail = "Sign-in with Email";
  static const loginViaEmail = "loginViaEmail";
  static const loginViaPHNumber = "loginViaPHNumber";
  static const getOtp = "Get OTP";
  static const invalidOtp = "Invalid Otp";
  static const enterOtp = "Enter OTP";
  static const otpEnterMsg = "Please enter the OTP received on your ";
  static const continueOtp = "Continue";
  static const note = "Note: ";
  static const otpWillBeSentToWhatsApp =
      "If you do not receive SMS, kindly check your WhatsApp for OTP";
  static const otpWillBeSentToEmail = "An email with OTP has been sent to ";
  static const resentOtp = "Resend OTP";

  static const appName = "QriteeQ";
  static const reviewContacts = "Review Contacts";
  static const videoSizeValidationMsg =
      'Video size too big.Please select video less than 150 MB';
  static const allFeeds = "All Feeds";
  static const linkYourAccount = "Link your account";

  static const invite = "INVITE";
  static const reportComment = "Report comment";
  static const anonymous = "Anonymous";
  static const you = "You";

  /// All Feeds Screen

  static const hintSearch = "Search by Name, Email-Id and Mobile number...";

  static const mobileNumberRequired = "Mobile Number Required";
  static const emailFormat = "Email bad Format";
  static const enterEmail = "Enter Email";
  static const pin = "Pin";
  static const unPin = "Unpin";
  static const favorite = "Favorite";
  static const unFavorite = "Unfavorite";
  static const flagProfile = "Flag Profile";
  static const unFlagProfile = "UnFlag Profile";
  static const delete = "Delete";

  ///USERNAME SCREEN
  static const userName = "User name";
  static const fullNameRequired = "Enter full name*";
  static const userNameRequired = "Enter User name*";
  static const userFullNameRequired = "User Full Name Required";
  static const selectYourCountry = "Select your country";
  static const countryFlag =
      'https://cdn.jsdelivr.net/npm/country-flag-emoji-json@2.0.0/dist/images/IN.svg';

  ///YOUR FEED SCREEN
  static const notYou = "notYou";
  static const world = "World";

  ///ONEFEED SCREEN

  static const generateReport = "Generate Report";
  static const payment = "Payment";
  static const block = "Block";
  static const unBlock = "Unblock";
  static const copyProfileLink = "Copy profile link";
  static const copyCampaignLink = "Copy campaign link";
  static const earnMsg =
      "Oops! Looks like you do not have enough coins to perform this action.\n\nYou can earn coins by:\n - Referring the app to friends and family\n - Posting feedbacks for other app users";
  static const moderateList = "Moderater Chat";

  ///USERPROFILE SCREEN
  static const unlockFeedback = "Unlock Feedback!";
  static const makePayment = "Make Payment";
  static const unlockFeedBackDescription =
      "Quickly head over to the payments section to unlock the feedback and read it.";

  ///FEEDBACK SCREEN
  static String isMediaPost = "";
  static const feedback = "Feedback details";
  static const unlock = 'Unlock';
  static const buyUnlockFeedback = 'Buy coins to unlock feedback';
  static const buyUnlockReport = 'Buy coins to unlock report';
  static const earnedCoins = 'Earned Coins';
  static const blockByYouUser = 'You’re not allowed to perform this action';
  static const thisFeedBackIsLocked = "This feedback is locked. Unlock to view";

  static const clickOnTheContactNameToGiveFeedback =
      "Click on the contact name to give feedback";
  static const findContact = 'Find contact';
  static const searchContactNumber = 'Search contact number';
  static const agree = "Agree";

  static const letsQriteeQYourFriend = "Let’s QriteeQ your friend";
  static const changeProfilePicture = "Change profile picture";
  static const disAgree = "Disagree";
  static const flag = "Flag!!";
  static const flaggedStatus = "flagged";
  static const pendingStatus = "pending";
  static const approvedStatus = "approved";
  static const rejectStatus = "rejected";
  static const youAreNotGenerateAnyReport =
      'You are not generate any report yet!';

  static const writeMessageHint = "Write your message";
  static const typeOfReview = "Type of Review";
  static const goToHome = "Go To Home";

  static const feedbackSuccessText =
      "Thank you for your feedback.\nPlease let us know the following to review your\n feedback better.";
  static const howWellknow = "How well you know him/her?";
  static const postAsAnonymous = "Post as anonymous";
  static const scoreYouGive = "How would you rate their personality:";
  static const areYouFeedBack = "Are you sure you want to flag this feedback?";
  static const reasonReporting = "Reason for reporting";
  static const doNotLikeThis = "I don’t like this.";
  static const objectionable = "This content is vulgar & objectionable.";
  static const violence = "It may cause violence, or hatred..";
  static const reportProfile = "The profile is pretending to be someone else.";
  static const cancel = "Cancel";
  static const comment = "Comment";
  static const report = "Report";
  static const overallView = "Overall view";
  static const scoreRatingOverview = "Score Rating Overview";
  static const allFeedbacks = "All Feedbacks";

  ///FLAG REPORT SCREEN
  static const reportReceived = "Report Received";
  static const reportMessage =
      "Thank you for making QriteeQ App a safer community for everyone.";
  static const reviewMessage =
      "Your report is under review. Our moderator will take a look and take appropriate action as quickly as possible.";
  static const inReview = "In Review";
  static const decisionMade = "Decision made";
  static const done = "Done";
  static const decisionMessage =
      "You will be notified about the action by the moderator soon. Keep checking your ‘All Feeds’ section.";

  ///ADRESS BOOK SCREEN
  static const viewAll = "View all";
  static const contactsOnApp = "Contacts on App";
  static const reviewOtherContacts = "Review other contacts";
  static const betterContactExperience =
      "Give contact permission for better experience";
  static const betterLocationExperience =
      "Give location permission for better experience";

  ///PROFILE SCREEN
  static const profile = "Profile";
  static const shareViaQr = "Share Via QR / Campaign";
  static const userActivity = "User Activity";
  static const leaderboard = "Leaderboard";
  static const userReport = "User report";
  static const fAQs = "FAQs";
  static const featureRequest = "Feature Request";
  static const termsAndConditions = "Terms & Conditions";
  static const privacyPolicy = "Privacy Policy";
  static const logOut = "Log Out";
  static const checkDPRating = "Check DP Rating";
  static const chatwithModerator = "Chat with Moderator";
  static const qriteeq = "hs";
  static const nearby = "Nearby";
  static const myCountry = 'My Country';
  static const global = 'Global';
  static const tryReviewingOthers =
      "You can not review yourself! Try Reviewing others.";

  ///PROFILE SCREEN
  static String feedbackReceived = 'Feedback\nReceived';
  static String rateDP = 'Rate DP';
  // static String feedbackReceived = 'Feedback\nReceived';
  static String feedbackPosted = 'Feedback\nPosted';
  static String trustScore = 'Trust\nScore';
  static String subscribedFavourited = 'Subscribed/\nFavourited';
  static String coinsWarn = "Coins Earn:";

  static String deleteAccount = 'Delete Account';
  static String version = 'Version';

  // static const qriteeq = "qriteeq";
  static const youPostedFeedback = "You posted a feedback";
  static const receivedNewFeedback = "Received a new feedback ";

  ///PRIVACY POLICY AND TERMS & CONDITION
  static const humanScoringTermsConditions = "Human Scoring Terms & Conditions";
  static const lastUpdated = "Last updated: 4 May 2022";
  static const auctorConsectetur = "1. Auctor consectetur.";
  static const auctorConsecteturMessage1 =
      "Egestas at blandit fusce sit quam fringilla lacus, tellus. In etiam hendrerit quam libero purus purus. Tristique a integer blandit proin gravida lacus. Ipsum sit consequat at vel dictumst vulputate et, magna. Quam ultrices fusce turpis metus senectus elit, sagittis. Lacus turpis ultricies tincidunt cras. Eget nec neque felis in pulvinar porttitor. Lorem enim vitae mauris, sed lectus massa. Id ipsum purus diam blandit amet in eu. Etiam cursus quis ornare sem sagittis. Proin lacus malesuada mauris, porttitor arcu morbi. ";
  static const auctorConsecteturMessage2 =
      "Velit, mauris morbi at duis consectetur pellentesque. In odio volutpat sit pellentesque id nisl feugiat condimentum. Convallis diam gravida id metus. Placerat velit laoreet amet, quis dolor nulla neque consectetur lacus. Ipsum sagittis tellus, ornare viverra non sit nec. Odio ac, eget velit risus scelerisque a leo et. A dui facilisi in urna mus. Accumsan pellentesque blandit accumsan laoreet vel. Erat arcu nunc commodo diam ultrices justo lobortis. Turpis dui mi curabitur lobortis urna.";
  static const egestasGravida = "2. Egestas gravida.";
  static const egestasGravidaMessage =
      "Eget in sed volutpat tellus morbi turpis tincidunt molestie. At condimentum mauris ac egestas egestas purus. Rutrum leo nulla nisi aliquam sit sed. Nisl, amet, mauris malesuada rhoncus. Pulvinar turpis egestas dignissim at et nulla. Nisl viverra orci viverra amet a. At non mattis tincidunt ullamcorper nunc sed. Ipsum malesuada lorem sagittis eget maecenas egestas in quis. Vulputate nullam fusce ornare amet. Tempor nulla blandit dui ut nibh bibendum dolor. Volutpat convallis sit viverra velit mauris facilisi non. Purus.";
  static const quisqueSollicitudin = "3. Quisque sollicitudin.";
  static const quisqueSollicitudinMessage =
      "Mattis lacus, placerat urna in id. Libero dolor non praesent sed enim sem malesuada suscipit. Gravida bibendum morbi commodo consectetur aliquet aliquam semper velit non. Proin erat bibendum sit nisl sagittis. Fames dolor sed sit tincidunt blandit eu nunc tortor. Nibh ultrices dis urna hendrerit in tempor. Felis pharetra eu, cras vitae tortor vestibulum, vel purus, sit. ";
  static const quisqueSollicitudinMessage2 =
      "Lacus amet commodo habitasse gravida etiam a egestas quam est. Habitasse ut sit tortor vel nisl cras ut pellentesque nec. Nunc, elementum, eu dolor proin nulla turpis sollicitudin bibendum sit. Quam ante id scelerisque ut cursus lectus. Accumsan, enim in sed et, feugiat vestibulum. Arcu ultricies ut id odio. Volutpat tincidunt eget amet non ullamcorper mauris justo. Semper consequat aenean suspendisse ut ut tristique in tellus in. Nulla imperdiet arcu imperdiet pharetra diam leo etiam. Eleifend adipiscing.";
  static const portaVestibulum = "4. Porta vestibulum a et.";
  static const portaVestibulumMessage =
      "Aenean consequat, risus vel felis, rutrum neque, suspendisse fringilla. Blandit felis mauris neque egestas at volutpat in pretium. Porta ultricies id duis pharetra turpis purus id. Fames elementum morbi volutpat fermentum. Et, ipsum, in scelerisque ultricies rhoncus, faucibus. Imperdiet erat massa a non. Tincidunt amet adipiscing sed mi. Tellus, imperdiet tristique consequat sit fermentum id tortor, bibendum aliquet. Consectetur urna vitae risus amet, pulvinar et ut orci. At amet sed est dolor augue pretium.";

  ///FREQUENTLY ASK QUESTION
  static const frequentlyAskQuestion = "Frequently Asked Questions";
  static const questionNum1 = "Viverra quam pulvinar sed non at?";
  static const questionNum2 = "Dolor condimentum ut etiam eget?";
  static const questionNum3 = "Purus in ut mi fermentum. Senectus duis elit?";
  static const questionNum4 = "Bibendum ultricies amet in hac?";
  static const questionNum5 = "Urna in amet fusce condimentum. Fames?";
  static const questionNum6 = "Tristique ipsum urna pharetra in. Augue?";
  static const questionNum7 = "Donec tristique purus posuere diam?";
  static const questionNum8 = "Tristique ut ut felis laoreet mattis purus?";
  static const questionNum9 = "Tristique ut ut felis laoreet mattis purus?";

  ///USER ACTIVITY
  static const postedFeedbacks = "POSTED FEEDBACKS";
  static const yourInteractions = "YOUR INTERACTIONS";
  static const all = "All";
  static const comments = "Comments";

  ///NOTIFICATION SCREEN
  static const notification = "Notification";
  static const generatedReport = "Generated Report";

  static const myTransactions = "My Transactions";

  ///ReferAndEarn
  static const referEndEarn = "Refer & Earn";
  static const referralCode = "Your referral code";
  static const referAFriend = "Refer a friend ";
  static const referAFriendMessage =
      "Refer and earn coins to unlock feedbacks and generate reports when the referee posts a feedback upon successful joining.";
  static const creditReview = "1 Credit = 1 Feedback View ";
  static const creditReviewMessage =
      "Coins can also be earned upon posting feedbacks for any user of the QriteeQ app.";
  static const creditReport = "10 Credits = 1 Report";
  static const creditReportMessage =
      "The coins can only be earned via the above methods and cannot be purchased in any way.";

  ///QR Code Screen
  static const qrCode = "QR Code";
  static const share = "SHARE";

  /// Campaign Screen
  static const createCampaign = 'Create a Campaign';
  static const viewCampaigns = 'View my Campaigns';
  static const campaigns = 'Campaign';
  static const ongoing = 'ongoing';
  static const completed = 'completed';
  static const campaignTitle = 'Campaign Title';
  static const descriptionIfAny = 'Description if any';
  static const startingDate = 'Starting Date';
  static const endingDate = 'Ending Date';
  static const generateLinkShare = 'Generate a Link & Share';
  static const oopsNoCampaignMadeYet = 'Oops No Campaign made yet!';
  static const makeCampaignKnowWhatTheySay =
      'Make a campaign & know what they say!!!';

  ///Edit Profile Screen Screen
  static const editProfile = "Edit profile";
  static const changeAvatarAndUserName = "Change Your Avatar & User Name";
  static const save = "Save";
  static const proceed = "Proceed";
  static const skip = "Skip";
  static const search = "Search";

  ///FeedBack For You Screen
  static const feedBacksForYou = "Feedbacks for You";

  ///Posted FeedBack Screen
  static const postedFeedback = "Posted Feedbacks";
  static const receivedFeedback = "Received Feedbacks";

  ///SubScribe FeedBack Screen
  static const subscribedList = "Subscribed/Favourite";
  static const unsubscribe = "Unsubscribe";
  static const subscribe = "Subscribe";
  static const subscribed = "Subscribed";
  static const favourite = "Favourite";
  static const favourited = "Favourited";
  static const sendFeedBackMsg = "Feedback Sent";
  static const commentSent = 'Comment Sent';
  static const featureReqContent =
      'Do you have any ideas to improve anything , please share them with us.';
}
