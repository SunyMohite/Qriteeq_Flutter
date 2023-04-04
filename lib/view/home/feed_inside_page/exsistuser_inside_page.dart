import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/res_model/get_contact_users_res_model.dart';
import '../../../utils/const_utils.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class ExistsUserInsidePage extends StatefulWidget {
  final String? userType;
  final GetContactUsersResults? allUserData;
  final String? avatar;

  const ExistsUserInsidePage(
      {Key? key, this.userType, this.allUserData, this.avatar})
      : super(key: key);

  @override
  State<ExistsUserInsidePage> createState() => _ExistsUserInsidePageState();
}

class _ExistsUserInsidePageState extends State<ExistsUserInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  bool? isBlock, isFlagProfile;
  String? byId, toId, queryKey, queryValue;
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    isBlock = widget.allUserData!.active == null
        ? false
        : widget.allUserData!.defaultStatus!.block;
    isFlagProfile = widget.allUserData!.active == null
        ? false
        : widget.allUserData!.defaultStatus!.flag;
    toId = widget.allUserData!.id;
    if (toId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = toId!;
    } else if (widget.allUserData!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.allUserData!.phone!;
    }
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
                SizeConfig.sH1,
                Expanded(
                  child: GetBuilder<FeedBackViewModel>(
                      builder: (feedBackController) {
                    return Column(
                      children: [
                        ///FEED USER common HEADER VIEW
                        FeedUserProfileHeaderWidget(
                          userOnlineStatus: widget.allUserData!.online,
                          userActive: widget.allUserData!.active,
                          toUserId: toId,
                          userProfile: widget.allUserData!.avatar,
                          favorite: widget.allUserData!.defaultStatus != null
                              ? widget.allUserData!.defaultStatus!.favorite!
                              : false,
                          userName: widget.allUserData!.userIdentity,
                          isBlock: isBlock,
                          isFlagProfile: isFlagProfile,
                          tabController: _tabController,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              UserAllFeedBackScreen(
                                userFeedBackId: widget.allUserData!.id!,
                                isExistsUser: true,
                                queryKey: queryKey,
                                queryValue: queryValue,
                              ),
                              YourPosted(
                                feedBackUserId: widget.allUserData!.id!,
                                queryKey: queryKey,
                                queryValue: queryValue,
                              )
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                ///FEED USER common HEADER VIEW
              ],
            ),
            PreferenceManagerUtils.getLoginId() == toId
                ? const SizedBox()
                : AddPostButtonWidget(
                    sId: widget.allUserData!.id!,
                    userName: widget.allUserData!.username!,
                    mobileNumber: widget.allUserData!.phone == null
                        ? ''
                        : widget.allUserData!.phone!,
                    isConnect: true,
                  ),
          ],
        ),
      ),
    );
  }
}
