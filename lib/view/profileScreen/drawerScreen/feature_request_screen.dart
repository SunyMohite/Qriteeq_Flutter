import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:sizer/sizer.dart';

import '../../../common/circular_progress_indicator.dart';
import '../../../common/commonWidget/custom_button.dart';
import '../../../common/commonWidget/custom_header.dart';
import '../../../common/commonWidget/snackbar.dart';
import '../../../modal/apiModel/res_model/feature_request_res_model.dart';
import '../../../modal/apis/api_response.dart';
import '../../../viewmodel/feature_request_view_model.dart';

class FeatureRequestScreen extends StatefulWidget {
  const FeatureRequestScreen({Key? key}) : super(key: key);

  @override
  State<FeatureRequestScreen> createState() => _FeatureRequestScreenState();
}

class _FeatureRequestScreenState extends State<FeatureRequestScreen> {
  final formKey = GlobalKey<FormState>();
  FeatureRequestViewModel viewModel = Get.find();

  final featureController = TextEditingController();

  @override
  dispose() {
    featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    const CustomHeaderWidget(
                      headerTitle: VariableUtils.featureRequest,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        children: [
                          Text(
                            VariableUtils.featureReqContent,
                            style: TextStyle(
                                fontSize: 11.5.sp,
                                color: const Color(0xff020000),
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          TextFormField(
                            maxLines: 15,
                            textInputAction: TextInputAction.go,
                            textCapitalization: TextCapitalization.sentences,
                            controller: featureController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Input field is required';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.sp)),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              hintText: "Write your ideas....",
                              hintStyle: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.only(right: 4.w, left: 4.w, bottom: 3.h),
                      child: InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (featureController.text.isBlank!) {
                            showSnackBar(
                              message: 'Input field is required',
                              snackColor: ColorUtils.red,
                            );
                            return;
                          } else if (formKey.currentState!.validate()) {
                            await viewModel.featureRequestViewModel(
                                msg: featureController.text);

                            if (viewModel.featureRequestApiResponse.status ==
                                Status.COMPLETE) {
                              FeatureRequestResModel response =
                                  viewModel.featureRequestApiResponse.data;
                              if (response.status == 200) {
                                showSnackBar(
                                  message: response.message,
                                  snackColor: ColorUtils.greenE8,
                                );
                                featureController.clear();
                                setState(() {});
                              } else {
                                showSnackBar(
                                  message: response.message,
                                  snackColor: ColorUtils.red,
                                );
                              }
                            }
                          }
                        },
                        child: CustomButtons(
                          buttonName: VariableUtils.submit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<FeatureRequestViewModel>(
              builder: (controller) {
                if (controller.featureRequestApiResponse.status ==
                    Status.LOADING) {
                  return const CircularIndicator();
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
