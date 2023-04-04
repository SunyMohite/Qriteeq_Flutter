import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/res_model/all_feeds_respo_model.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../viewmodel/dashboard_viewmodel.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class AllInsidePage extends StatefulWidget {
  final String? userType;
  final All? allData;
  final String? avatar;

  const AllInsidePage({Key? key, this.userType, this.allData, this.avatar})
      : super(key: key);

  @override
  State<AllInsidePage> createState() => _InsidePageState();
}

class _InsidePageState extends State<AllInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userName, sId, url, byId, toId;
  BlockReqModel blockReqModel = BlockReqModel();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  bool? isBlock, isFlagProfile;
  String? queryKey, queryValue;

  @override
  void initState() {
    userName = widget.allData!.user!.userIdentity;
    sId = widget.allData!.user!.sId;
    url = widget.allData!.iId!.phone
        .toString()
        .replaceAll("+", "%2B")
        .replaceAll(" ", "");

    isBlock = widget.allData!.status!.block ?? false;
    isFlagProfile = widget.allData!.status!.flag ?? false;
    toId = widget.allData!.iId?.sId;
    byId = PreferenceManagerUtils.getLoginId();
    if (toId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = toId!;
    } else if (widget.allData!.user!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.allData!.user!.phone!;
    } else if (widget.allData!.user!.email!.isNotEmpty) {
      queryKey = VariableUtils.email;
      queryValue = widget.allData!.user!.email!;
    } else if (widget.allData!.user!.profileUrl!.isNotEmpty) {
      queryKey = VariableUtils.profileUrl;
      queryValue = widget.allData!.user!.profileUrl!;
    }

    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GetBuilder<DashBoardViewModel>(builder: (dashController) {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ///FEED USER common HEADER VIEW and tab view
                        FeedUserProfileHeaderWidget(
                          userOnlineStatus: widget.allData!.user!.online,
                          userActive: widget.allData!.user!.active,
                          toUserId: toId,
                          userProfile: widget.avatar,
                          favorite: widget.allData!.status!.favorite,
                          userName: userName,
                          isBlock: isBlock,
                          isFlagProfile: isFlagProfile,
                          tabController: _tabController,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              UserAllFeedBackScreen(
                                userFeedBackId:
                                    widget.allData!.connected == true
                                        ? widget.allData!.iId!.sId
                                        : url,
                                queryKey: queryKey,
                                queryValue: queryValue,
                                isExistsUser: widget.allData!.connected,
                              ),
                              YourPosted(
                                feedBackUserId:
                                    widget.allData!.connected == true
                                        ? widget.allData!.iId!.sId
                                        : url,
                                isExistsUser: widget.allData!.connected,
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
              );
            }),
            AddPostButtonWidget(
              sId: sId!,
              userName: userName!,
              mobileNumber: widget.allData!.iId!.phone == null
                  ? ''
                  : widget.allData!.iId!.phone!,
              isConnect: widget.allData!.connected!,
            ),
          ],
        ),
      ),
    );
  }
}
