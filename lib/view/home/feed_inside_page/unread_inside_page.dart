import 'package:flutter/material.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/res_model/all_feeds_respo_model.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/variable_utils.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class UnreadInsidePage extends StatefulWidget {
  final String? userType;
  final Unread? unreadFeed;
  final String? avatar;

  const UnreadInsidePage(
      {Key? key, this.userType, this.unreadFeed, this.avatar})
      : super(key: key);

  @override
  State<UnreadInsidePage> createState() => _InsidePageState();
}

class _InsidePageState extends State<UnreadInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userName, byId, toId;
  String? url, queryKey, queryValue;
  BlockReqModel blockReqModel = BlockReqModel();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  bool? isBlock, isFlagProfile;

  @override
  void initState() {
    userName = widget.unreadFeed!.user!.userIdentity;
    isBlock = widget.unreadFeed!.status!.block ?? false;
    isFlagProfile = widget.unreadFeed!.status!.flag ?? false;
    toId = widget.unreadFeed!.iId?.sId;
    byId = PreferenceManagerUtils.getLoginId();
    if (toId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = toId!;
    } else if (widget.unreadFeed!.user!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.unreadFeed!.user!.phone!;
    } else if (widget.unreadFeed!.user!.email!.isNotEmpty) {
      queryKey = VariableUtils.email;
      queryValue = widget.unreadFeed!.user!.email!;
    } else if (widget.unreadFeed!.user!.profileUrl!.isNotEmpty) {
      queryKey = VariableUtils.profileUrl;
      queryValue = widget.unreadFeed!.user!.profileUrl!;
    }
    _tabController = TabController(length: 2, vsync: this);
    url = widget.unreadFeed!.iId!.phone
        .toString()
        .replaceAll("+", "%2B")
        .replaceAll(" ", "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                ///FEED USER common HEADER VIEW
                FeedUserProfileHeaderWidget(
                  userOnlineStatus: widget.unreadFeed!.user!.online,
                  userActive: widget.unreadFeed!.user!.active,
                  toUserId: toId,
                  userProfile: widget.avatar,
                  favorite: widget.unreadFeed!.status!.favorite,
                  userName: userName,
                  isBlock: isBlock,
                  isFlagProfile: isFlagProfile,
                  tabController: _tabController,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UserAllFeedBackScreen(
                        userFeedBackId: widget.unreadFeed!.connected == true
                            ? widget.unreadFeed!.iId!.sId
                            : url,
                        isExistsUser: widget.unreadFeed!.connected,
                        queryKey: queryKey,
                        queryValue: queryValue,
                      ),
                      YourPosted(
                        feedBackUserId: widget.unreadFeed!.connected == true
                            ? widget.unreadFeed!.iId!.sId
                            : url,
                        queryKey: queryKey,
                        queryValue: queryValue,
                      )
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),

            AddPostButtonWidget(
              sId: widget.unreadFeed!.iId!.sId!,
              userName: userName!,
              mobileNumber: widget.unreadFeed!.iId!.phone == null
                  ? ''
                  : widget.unreadFeed!.iId!.phone!,
              isConnect: widget.unreadFeed!.connected!,
            ),
          ],
        ),
      ),
    );
  }
}
