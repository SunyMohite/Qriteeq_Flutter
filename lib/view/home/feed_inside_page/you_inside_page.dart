import 'package:flutter/material.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/res_model/all_feeds_respo_model.dart';
import '../../../utils/variable_utils.dart';
import '../user_all_feedback.dart';
import '../widget/common_feeduser_header_widget.dart';

class YouInsidePage extends StatefulWidget {
  final String? userType;
  final FeedYou? youFeedData;
  final String? avatar;

  const YouInsidePage({Key? key, this.userType, this.youFeedData, this.avatar})
      : super(key: key);

  @override
  State<YouInsidePage> createState() => _InsidePageState();
}

class _InsidePageState extends State<YouInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userName, sId, queryKey, queryValue;
  @override
  void initState() {
    userName = widget.youFeedData!.userIdentity;
    sId = widget.youFeedData!.sId;
    if (sId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = sId!;
    } else if (widget.youFeedData!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.youFeedData!.phone!;
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
                  userOnlineStatus: widget.youFeedData!.online,
                  userActive: widget.youFeedData!.active,
                  toUserId: widget.youFeedData!.sId,
                  userProfile: widget.avatar,
                  favorite: false,
                  tabController: _tabController,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UserAllFeedBackScreen(
                        isExistsUser: true,
                        userFeedBackId: widget.youFeedData!.sId,
                        queryKey: queryKey,
                        queryValue: queryValue,
                      ),
                      YourPosted(
                        feedBackUserId: widget.youFeedData!.sId,
                        fromScreen: 'YouInside',
                        queryKey: queryKey,
                        queryValue: queryValue,
                      )
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
