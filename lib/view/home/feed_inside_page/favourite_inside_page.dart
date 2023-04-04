import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/req_model/feed_like_request_model.dart';
import '../../../modal/apiModel/res_model/get_favorite_res_model.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../../viewmodel/dashboard_viewmodel.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class FavouriteInsidePage extends StatefulWidget {
  final FavResults? favResults;

  const FavouriteInsidePage({Key? key, this.favResults}) : super(key: key);

  @override
  State<FavouriteInsidePage> createState() => _FavouriteInsidePageState();
}

class _FavouriteInsidePageState extends State<FavouriteInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userName, toId, byId, queryKey, queryValue;

  bool? isBlock, isFlagProfile;

  FeedLikeRequestModel feedLikeRequestModel = FeedLikeRequestModel();
  BlockReqModel blockReqModel = BlockReqModel();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();

  @override
  void initState() {
    userName = widget.favResults!.to!.userIdentity;

    isBlock = widget.favResults!.block ?? false;
    isFlagProfile = widget.favResults!.flag ?? false;

    toId = widget.favResults!.to!.id;
    byId = PreferenceManagerUtils.getLoginId();
    if (toId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = toId!;
    } else if (widget.favResults!.to!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.favResults!.to!.phone!;
    } else if (widget.favResults!.to!.email!.isNotEmpty) {
      queryKey = VariableUtils.email;
      queryValue = widget.favResults!.to!.email!;
    } else if (widget.favResults!.to!.profileUrl!.isNotEmpty) {
      queryKey = VariableUtils.profileUrl;
      queryValue = widget.favResults!.to!.profileUrl!;
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
                  SizeConfig.sH1,

                  ///FEED USER common HEADER VIEW
                  FeedUserProfileHeaderWidget(
                    userOnlineStatus: widget.favResults!.to!.online,
                    userActive: widget.favResults!.to!.active,
                    toUserId: toId,
                    userProfile: widget.favResults!.to!.avatar,
                    favorite: widget.favResults!.favorite!,
                    userName: userName,
                    isBlock: isBlock,
                    isFlagProfile: isFlagProfile,
                    tabController: _tabController,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        UserAllFeedBackScreen(
                          isExistsUser: true,
                          userFeedBackId: widget.favResults!.to!.id!,
                          queryKey: queryKey,
                          queryValue: queryValue,
                        ),
                        YourPosted(
                          feedBackUserId: widget.favResults!.to!.id!,
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
            AddPostButtonWidget(
              sId: widget.favResults!.to!.id!,
              userName: widget.favResults!.to!.userIdentity!,
              mobileNumber: widget.favResults!.to!.phone == null
                  ? ''
                  : widget.favResults!.to!.phone!,
              isConnect: true,
            ),
          ],
        ),
      ),
    );
  }
}
