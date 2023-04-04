
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/custom_button.dart';
import 'package:humanscoring/common/commonWidget/custom_header.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apiModel/res_model/campaign_model_resp.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/no_leading_space_formatter.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/typedef_utils.dart' as type;
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../common/circular_progress_indicator.dart';
import '../../../viewmodel/create_campaign_view_model.dart';

class CreateCampaignScreen extends StatefulWidget {
  final bool? active;

  const CreateCampaignScreen({Key? key, this.active}) : super(key: key);

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final formKey = GlobalKey<FormState>();
  final viewModel = Get.find<CreateCampaignRequestViewModel>();

  DateTime? startPickedDate, endPickedDate;
  String? startDate, endDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startController = TextEditingController();
    endController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorUtils.whiteE5,
        body: GetBuilder<CreateCampaignRequestViewModel>(
          builder: (createCampaignRequestViewModel) {
            return Stack(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const CustomHeaderWidget(
                        headerTitle: VariableUtils.createCampaign,
                      ),
                      CommonTextField(
                        width: 3.w,
                        readOnly: false,
                        obscured: false,
                        input: r"[a-zA-Z0-9 ]",
                        controller: nameController,
                        validate: validateName,
                        keyboard: TextInputType.name,
                        typeText: VariableUtils.campaignTitle,
                        hintText: 'Title',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              width: 3.w,
                              obscured: false,
                              readOnly: true,
                              input: "",
                              controller: startController,
                              keyboard: TextInputType.datetime,
                              typeText: VariableUtils.startingDate,
                              icon: Icons.calendar_today_outlined,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                startPickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(3000),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: ColorUtils.blue74,
                                            onPrimary: ColorUtils.white,
                                            onSurface: ColorUtils.black,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    });
                                if (startPickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(startPickedDate!);

                                  String date = DateFormat('dd-MM-yyyy')
                                      .format(startPickedDate!);
                                  setState(() {
                                    startController.text = date;
                                    startDate = formattedDate;
                                  });
                                }
                              },
                              hintText: 'DD/MM/YYYY',
                            ),
                          ),
                          Expanded(
                            child: CommonTextField(
                              width: 3.w,
                              obscured: false,
                              input: "",
                              readOnly: true,
                              controller: endController,
                              keyboard: TextInputType.datetime,
                              typeText: VariableUtils.endingDate,
                              icon: Icons.calendar_today_outlined,
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                if (startDate!.isNotEmpty) {
                                  String dateTime = startDate!;
                                  DateFormat inputFormat =
                                      DateFormat('yyyy-MM-dd');
                                  DateTime input = inputFormat.parse(dateTime);
                                  endPickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        input.add(const Duration(days: 1)),
                                    firstDate:
                                        input.add(const Duration(days: 1)),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: ColorUtils.blue74,
                                            onPrimary: ColorUtils.white,
                                            onSurface: ColorUtils.black,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                                // foregroundColor: ColorUtils.blue74,
                                                ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (endPickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(endPickedDate!);

                                    String date = DateFormat('dd-MM-yyyy')
                                        .format(endPickedDate!);
                                    setState(() {
                                      endController.text = date;
                                      endDate = formattedDate;
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content:
                                          Text('You need to select Start Date'),
                                    ),
                                  );
                                }
                              },
                              hintText: 'DD/MM/YYYY',
                            ),
                          ),
                        ],
                      ),
                      CommonTextField(
                        width: 3.w,
                        readOnly: false,
                        obscured: false,
                        input: r"[a-zA-Z0-9. ]",
                        maxlines: 4,
                        hintText: 'Write..',
                        controller: descriptionController,
                        keyboard: TextInputType.name,
                        typeText: VariableUtils.descriptionIfAny,
                      ),
                      SizeConfig.sH3,
                      const Spacer(),
                      CustomButtons(
                        onTap: () async {
                          if (nameController.text.isBlank! ||
                              startController.text.isBlank! ||
                              endController.text.isBlank!) {
                            showSnackBar(message: 'Input field is required');
                          } else {
                            logs(
                                "Start data controller ${startController.text} End date ${endController.text}");
                            logs("Start data $startDate End date $endDate");
                            await createCampaignRequestViewModel
                                .createCampaignRequestViewModel(requestBody: {
                              "title": nameController.text,
                              "description": descriptionController.text,
                              "startDate": startDate,
                              "endDate": endDate
                            });
                            if (createCampaignRequestViewModel
                                    .createCampaignRequestApiResponse.status ==
                                Status.COMPLETE) {
                              CampaignModelResponse response =
                                  createCampaignRequestViewModel
                                      .createCampaignRequestApiResponse.data;
                              if (response.status == 400) {
                                showSnackBar(message: response.message);
                              } else {
                                viewModel.getCampaignList.clear();
                                viewModel.getCampaignPage = 1;
                                viewModel.isGetCampaignFirstLoading = true;
                                viewModel.getCampaignViewModel(
                                    active: widget.active);
                                Get.back();

                                showSnackBar(message: response.message);
                              }
                            }
                          }
                        },
                        buttonName: VariableUtils.generateLinkShare,
                      ),
                      SizeConfig.sH3,
                    ],
                  ),
                ),
                if (createCampaignRequestViewModel
                        .createCampaignRequestApiResponse.status ==
                    Status.LOADING)
                  const CircularIndicator()
              ],
            );
          },
        ),
      ),
    );
  }

  validateName(value) {
    if (value.isEmpty) {
      return "Field is required";
    }
    if (!RegExp(r"[a-zA-Z0-9. ]").hasMatch(value)) {
      return "Enter valid title";
    }
    return null;
  }

  validateStartDate(value) {
    if (value.isEmpty) {
      return "Date is required";
    }
    return null;
  }

  validateEndDate(value) {
    if (value.isEmpty) {
      return "Date is required";
    }
    if (endPickedDate!.isBefore(startPickedDate!)) {
      return "End date must be after startDate";
    }
    return null;
  }

  validatedescription(value) {
    if (value.isEmpty) {
      return "Description is required";
    }
    return null;
  }
}

// ignore: must_be_immutable
class CommonTextField extends StatelessWidget {
  CommonTextField(
      {Key? key,
      this.icon,
      this.typeText,
      this.controller,
      this.validate,
      this.keyboard,
      this.obscured,
      this.onTap,
      required this.input,
      this.hintText,
      this.maxlines,
      this.enabled,
      required this.readOnly,
      this.width})
      : super(key: key);
  final controller,
      maxlines,
      hintText,
      icon,
      typeText,
      validate,
      keyboard,
      obscured,
      input,
      readOnly,
      enabled;

  double? width;

  type.OnTap? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width ?? 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizeConfig.sH3,
          Text(
            typeText,
            style: TextStyle(
              color: const Color(0xff8C8B9C),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          TextFormField(
            readOnly: readOnly,
            enabled: enabled ?? true,
            maxLines: maxlines,
            controller: controller,
            keyboardType: keyboard,
            validator: (v) => validate(v),
            obscureText: obscured,
            obscuringCharacter: "*",
            textCapitalization: TextCapitalization.sentences,
            onTap: onTap,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(input)),
              NoLeadingSpaceFormatter(),
            ],
            cursorColor: const Color(0xFF515C6F),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  TextStyle(color: const Color(0xFFCBCBCB), fontSize: 10.sp),
              contentPadding: EdgeInsets.all(3.w),
              errorStyle: TextStyle(fontSize: 8.sp),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.4.h,
                ),
                child: SizedBox(
                  height: 2.h,
                  width: 2.w,
                  child: Icon(
                    icon,
                    color: const Color(0xFFCBCBCB),
                  ),
                ),
              ),
              focusedBorder: const OutlineInputBorder(),
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
