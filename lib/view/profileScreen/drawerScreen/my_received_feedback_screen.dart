import 'package:flutter/material.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';

import '../../../common/commonWidget/custom_header.dart';
import '../../home/user_all_feedback.dart';

class MyReceivedFeedBackScreen extends StatefulWidget {
  const MyReceivedFeedBackScreen({Key? key}) : super(key: key);

  @override
  State<MyReceivedFeedBackScreen> createState() =>
      _MyReceivedFeedBackScreenState();
}

class _MyReceivedFeedBackScreenState extends State<MyReceivedFeedBackScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.feedBacksForYou,
            ),
            Expanded(
              child: UserAllFeedBackScreen(
                isExistsUser: true,
                userFeedBackId: PreferenceManagerUtils.getLoginId(),
                queryKey: VariableUtils.userId,
                queryValue: PreferenceManagerUtils.getLoginId(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
