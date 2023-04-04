import 'package:flutter/material.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/res_model/all_feeds_respo_model.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/variable_utils.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class PinInsidePage extends StatefulWidget {
  final String? userType;
  final All? pinData;
  final String? avatar;

  const PinInsidePage({Key? key, this.userType, this.pinData, this.avatar})
      : super(key: key);

  @override
  State<PinInsidePage> createState() => _InsidePageState();
}

class _InsidePageState extends State<PinInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userName, url, byId, toId, queryKey, queryValue;

  BlockReqModel blockReqModel = BlockReqModel();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  bool? isBlock, isFlagProfile;

  @override
  void initState() {
    url = widget.pinData!.user!.phone!
        .toString()
        .replaceAll("+", "%2B")
        .replaceAll(" ", "");
    userName = widget.pinData!.user!.userIdentity ?? '';
    toId = widget.pinData!.user!.sId;

    isBlock = widget.pinData!.status!.block ?? false;
    isFlagProfile = widget.pinData!.status!.flag ?? false;

    byId = PreferenceManagerUtils.getLoginId();
    if (toId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = toId!;
    } else if (widget.pinData!.user!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.pinData!.user!.phone!;
    } else if (widget.pinData!.user!.email!.isNotEmpty) {
      queryKey = VariableUtils.email;
      queryValue = widget.pinData!.user!.email!;
    } else if (widget.pinData!.user!.profileUrl!.isNotEmpty) {
      queryKey = VariableUtils.profileUrl;
      queryValue = widget.pinData!.user!.profileUrl!;
    }
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  FocusNode focusNode = FocusNode();

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
                  userOnlineStatus: widget.pinData!.user!.online,
                  userActive: widget.pinData!.user!.active,
                  toUserId: toId,
                  userProfile: widget.avatar,
                  favorite: widget.pinData!.status!.favorite!,
                  userName: userName,
                  isBlock: isBlock,
                  isFlagProfile: isFlagProfile,
                  tabController: _tabController,
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      UserAllFeedBackScreen(
                        userFeedBackId: widget.pinData!.connected == true
                            ? widget.pinData!.user!.sId
                            : url,
                        isExistsUser: widget.pinData!.connected,
                        queryKey: queryKey,
                        queryValue: queryValue,
                      ),
                      YourPosted(
                        feedBackUserId: widget.pinData!.connected == true
                            ? widget.pinData!.user!.sId
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
              sId: toId!,
              userName: userName!,
              mobileNumber: widget.pinData!.user!.phone == null
                  ? ''
                  : widget.pinData!.user!.phone!,
              isConnect: widget.pinData!.connected!,
            ),
          ],
        ),
      ),
    );
  }
}
