
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../common/circular_progress_indicator.dart';
import '../../../modal/apiModel/res_model/my_feed_back_response_model.dart';
import '../../../modal/apis/api_response.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../../generalScreen/no_searchfound_screen.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class DeeplinkUserProfileScreen extends StatefulWidget {
  final String? userId;

  const DeeplinkUserProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<DeeplinkUserProfileScreen> createState() =>
      _DeeplinkUserProfileScreenState();
}

class _DeeplinkUserProfileScreenState extends State<DeeplinkUserProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  String? queryKey, queryValue;
  FeedBackViewModel feedBackViewModel = Get.find();
  @override
  void initState() {
    logs('==========USERID............${widget.userId}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      feedBackViewModel.apiInit();
      feedBackViewModel.getMyFeedDeepLink(
          initLoad: false,
          userId: widget.userId!,
          queryKey: VariableUtils.userId,
          queryValue: widget.userId!,
          isExistsUser: true);
    });

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: GetBuilder<FeedBackViewModel>(
          builder: (feedBackViewModel) {
            if (feedBackViewModel.getFeedBackDeepLinkApiResponse.status ==
                Status.LOADING) {
              return const Center(child: CircularIndicator());
            }
            if (feedBackViewModel.getFeedBackDeepLinkApiResponse.status ==
                Status.ERROR) {
              return NoFeedBackFound(
                titleMsg: VariableUtils.beFirstFeedback,
              );
            }
            if (feedBackViewModel.getFeedBackDeepLinkApiResponse.data == null) {
              logs(
                  "feedBackViewModel.getFeedBackApiResponse ${feedBackViewModel.getFeedBackApiResponse}");
              return const Center(child: CircularIndicator());
            }
            MyFeedBackData myFeedBackData =
                feedBackViewModel.getFeedBackDeepLinkApiResponse.data.data;

            if (myFeedBackData.userObj!.id!.isNotEmpty) {
              queryKey = VariableUtils.userId;
              queryValue = myFeedBackData.userObj!.id!;
            } else if (myFeedBackData.userObj!.phone!.isNotEmpty) {
              queryKey = VariableUtils.phone;
              queryValue = myFeedBackData.userObj!.phone!;
            } else if (myFeedBackData.userObj!.email!.isNotEmpty) {
              queryKey = VariableUtils.email;
              queryValue = myFeedBackData.userObj!.email;
            } else if (myFeedBackData.userObj!.profileUrl!.isNotEmpty) {
              queryKey = VariableUtils.profileUrl;
              queryValue = myFeedBackData.userObj!.profileUrl!;
            }
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ///FEED USER common HEADER VIEW and tab view
                            FeedUserProfileHeaderWidget(
                              userOnlineStatus: myFeedBackData.userObj!.online,
                              userActive: myFeedBackData.userObj!.active,
                              toUserId: myFeedBackData.userObj!.id,
                              userProfile: myFeedBackData.userObj!.avatar,
                              favorite: myFeedBackData.userStatus!.favorite,
                              userName: myFeedBackData.userObj!.userIdentity,
                              isBlock: myFeedBackData.userStatus!.block,
                              isFlagProfile: myFeedBackData.userStatus!.block,
                              tabController: _tabController,
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  UserAllFeedBackScreen(
                                    userFeedBackId: '',
                                    queryKey: queryKey,
                                    queryValue: queryValue,
                                    isExistsUser: true,
                                  ),
                                  YourPosted(
                                    feedBackUserId: '',
                                    isExistsUser: true,
                                    queryKey: queryKey,
                                    queryValue: queryValue,
                                  )
                                ],
                                controller: _tabController,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  AddPostButtonWidget(
                    sId: widget.userId!,
                    userName: myFeedBackData.userObj!.userIdentity!,
                    mobileNumber: myFeedBackData.userObj!.phone??'',
                    isConnect: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
