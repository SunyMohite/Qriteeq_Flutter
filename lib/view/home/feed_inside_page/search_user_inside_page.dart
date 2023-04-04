import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/res_model/get_search_res_model.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class SearchUserInsidePage extends StatefulWidget {
  final String? userType;
  final SearchResults? searchResults;
  final String? avatar;

  const SearchUserInsidePage(
      {Key? key, this.userType, this.searchResults, this.avatar})
      : super(key: key);

  @override
  State<SearchUserInsidePage> createState() => _InsidePageState();
}

class _InsidePageState extends State<SearchUserInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userName, queryKey, queryValue;

  FocusNode focusNode = FocusNode();
  BlockReqModel blockReqModel = BlockReqModel();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  bool? isBlock, isFlagProfile;
  FeedBackViewModel feedBackController = Get.find();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    userName = widget.searchResults!.sId == PreferenceManagerUtils.getLoginId()
        ? VariableUtils.you
        : widget.searchResults!.userIdentity;
    isBlock = widget.searchResults!.defaultStatus!.block ?? false;
    isFlagProfile = widget.searchResults!.defaultStatus!.flag ?? false;
    if (widget.searchResults!.sId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = widget.searchResults!.sId!;
    } else if (widget.searchResults!.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.searchResults!.phone!;
    } else if (widget.searchResults!.email!.isNotEmpty) {
      queryKey = VariableUtils.email;
      queryValue = widget.searchResults!.email!;
    } else if (widget.searchResults!.profileUrl!.isNotEmpty) {
      queryKey = VariableUtils.profileUrl;
      queryValue = widget.searchResults!.profileUrl!;
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
                ///FEED USER common HEADER VIEW
                FeedUserProfileHeaderWidget(
                  userOnlineStatus: widget.searchResults!.online,
                  userActive: widget.searchResults!.active,
                  toUserId: widget.searchResults!.sId,
                  userProfile: widget.avatar,
                  favorite: widget.searchResults!.defaultStatus!.favorite!,
                  userName: userName,
                  isBlock: isBlock,
                  isFlagProfile: isFlagProfile,
                  tabController: _tabController,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UserAllFeedBackScreen(
                        userFeedBackId: widget.searchResults!.sId!,
                        isExistsUser: true,
                        queryKey: queryKey,
                        queryValue: queryValue,
                      ),
                      YourPosted(
                        feedBackUserId: widget.searchResults!.sId!,
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
              sId: widget.searchResults!.sId!,
              userName: widget.searchResults!.userIdentity!,
              mobileNumber: widget.searchResults!.phone == null
                  ? ''
                  : widget.searchResults!.phone!,
              isConnect: true,
            ),
          ],
        ),
      ),
    );
  }
}
