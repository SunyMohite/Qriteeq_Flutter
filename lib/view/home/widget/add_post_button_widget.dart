import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/commonWidget/snackbar.dart';
import '../../../common/commonWidget/unlock_feedback_bottomsheet_widget.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../feed_post_screen.dart';

class AddPostButtonWidget extends StatelessWidget {
  const AddPostButtonWidget(
      {Key? key,
      required this.sId,
      required this.userName,
      required this.mobileNumber,
      required this.isConnect})
      : super(key: key);
  final String sId, userName, mobileNumber;
  final bool isConnect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: GetBuilder<FeedBackViewModel>(
        builder: (feedBackController) {
          return FloatingActionButton(
            backgroundColor: ColorUtils.primaryColor,
            onPressed: () async {
              if (feedBackController.isUserBlock == true) {
                showSnackBar(
                    message: VariableUtils.blockByYouUser,
                    showDuration: const Duration(seconds: 3));
                return;
              } else if (mobileNumber.isNotEmpty) {
                await feedBackController
                    .getValidPhoneNumberApiResponseViewModel(
                        phoneNumber: mobileNumber
                            .replaceAll("+", "%2B")
                            .replaceAll(' ', '')
                            .replaceAll('-', '')
                            .replaceAll('(', '')
                            .replaceAll(')', ''));

                if (feedBackController
                        .getValidPhoneNumberApiResponse.data.error ==
                    true) {
                  showSnackBar(
                      message:
                          '${feedBackController.getValidPhoneNumberApiResponse.data.dataMessage}');
                  return;
                } else if (feedBackController.getFeedBackApiResponse.data ==
                    null) {
                  Get.bottomSheet(
                    addUserNameBottomSheet(
                      connect: isConnect,
                      id: sId,
                      mobile: mobileNumber,
                      userName: userName,
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  );
                } else {
                  Get.to(
                    FeedPostScreen(
                      connect: isConnect,
                      id: sId,
                      mobile: mobileNumber,
                      userName: userName,
                    ),
                  );
                }
              } else if (feedBackController.getFeedBackApiResponse.data ==
                  null) {
                Get.bottomSheet(
                  addUserNameBottomSheet(
                    connect: isConnect,
                    id: sId,
                    mobile: mobileNumber,
                    userName: userName,
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                );
              } else if (feedBackController.isUserBlock == false) {
                Get.to(FeedPostScreen(
                  connect: isConnect,
                  id: sId,
                  mobile: mobileNumber,
                  userName: userName,
                ));
              } else {
                showSnackBar(
                    message: 'Something went to wrong try after sometimes');
                return;
              }
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
