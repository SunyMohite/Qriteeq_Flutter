
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';

import '../../common/circular_progress_indicator.dart';
import '../../modal/apiModel/req_model/payment_init_req_model.dart';
import '../../modal/apiModel/res_model/payment_init_res_model.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/payment_view_model.dart';
import 'card_payment_form.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  var amount;
  var displayAmount;
  String? showText;

  ConfirmPaymentScreen({key, this.amount, this.displayAmount, this.showText})
      : super(key: key);

  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();
  Stripe? stripe;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stripe = Stripe(
      'pk_test_51LJF9qATNb5V4ndv7TyPrTfsH6UUmepUUmc0oJXZJBgGiLvnOMC7tEQifTpSakvlbBYeilcx4l1NKZGdo5E8Wze9004pwnDq6D', //Your Publishable Key
    );
  }

  void setLoading(bool state) {
    if (mounted) {
      setState(() {
        isLoading = state;
      });
    }
  }

  PaymentViewModel paymentViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GetBuilder<PaymentViewModel>(builder: (paymentViewModel) {
          return Stack(
            children: [
              Column(
                children: [
                  SafeArea(
                    child: Container(
                      height: 8.h,
                      width: double.infinity,
                      color: ColorUtils.blue1,
                      padding: EdgeInsets.only(top: 0.h, left: 3.w),
                      child: Row(
                        children: [
                          Material(
                            color: ColorUtils.transparent,
                            borderRadius: BorderRadius.circular(150),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(150),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconsWidgets.backArrow,
                              ),
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ),
                          SizeConfig.sW2,
                          Text(
                            VariableUtils.payment,
                            style: FontTextStyle.poppinsWhite11semiB.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizeConfig.sH2,
                  Text(
                    "Payment Information",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  SizeConfig.sH1,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "${widget.showText}",
                      style: TextStyle(
                          fontSize: 11.sp, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizeConfig.sH2,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: ListView(
                        children: [
                          CardPaymentForm(
                            cardNumberDecoration: InputDecoration(
                              labelText: 'Card Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                              labelStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              isDense: true,
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 40, maxHeight: 20),
                              prefixIcon: Image.asset(
                                'assets/icon/credit_card.webp',
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            cardExpiryDecoration: InputDecoration(
                              labelText: 'Expiry Date',
                              hintText: 'MM/YY',
                              labelStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              isDense: true,
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 40, maxHeight: 20),
                              prefixIcon: Image.asset(
                                'assets/icon/calender.webp',
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            cardCvcDecoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: 'XXXX',
                              labelStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              isDense: true,
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 40, maxHeight: 20),
                              prefixIcon: Image.asset(
                                'assets/icon/cvv.webp',
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            formKey: formKey,
                            card: card,
                            displayAnimatedCard: true,
                          ),
                          SizeConfig.sH2,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Material(
                              color: ColorUtils.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                splashColor: ColorUtils.grey,
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    setLoading(true);

                                    await makePayment();

                                    setLoading(false);
                                  }
                                },
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    decoration: DecorationUtils
                                        .allBorderAndColorDecorationBox(
                                      colors: ColorUtils.blue14,
                                      radius: 5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        '\$ ${widget.displayAmount} Confirm Payment',
                                        style: FontTextStyle.poppinsWhite10bold,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              paymentViewModel.paymentInitApiResponse.status ==
                          Status.LOADING ||
                      paymentViewModel.postPaymentApiResponse.status ==
                          Status.LOADING
                  ? const CircularIndicator(
                      isExpand: true,
                    )
                  : const SizedBox()
            ],
          );
        }),
      ),
    );
  }

  Future<void> makePayment() async {
    final StripeCard stripeCard = card;

    if (!stripeCard.validateDate()) {
      paymentStatusDialog(
          context: context, title: "Error", msg: "Date not valid.");
      return;
    }
    if (!stripeCard.validateNumber()) {
      paymentStatusDialog(
          context: context, title: "Error", msg: "Number not valid.");
      return;
    }
    PaymentInitReqModel paymentInitReqModel = PaymentInitReqModel();

    // PaymentRequestModel paymentRequestModel = PaymentRequestModel();
    paymentInitReqModel.amount = widget.amount;
    paymentInitReqModel.currency = 'usd';
    paymentInitReqModel.cardNum = stripeCard.number!;
    paymentInitReqModel.cardExpMonth = stripeCard.expMonth;
    paymentInitReqModel.cardExpYear = stripeCard.expYear;
    paymentInitReqModel.cardCvc = stripeCard.cvc;

    await paymentViewModel.paymentInitViewModel(paymentInitReqModel);
    if (paymentViewModel.paymentInitApiResponse.status == Status.COMPLETE) {
      // pi_3LhTJnATNb5V4ndv02uf3fkD
      PaymentInitResModel response =
          paymentViewModel.paymentInitApiResponse.data;
      if (response.status == 200) {
        await PreferenceManagerUtils.setCustomerId(response.data!.customer!.id);
        await paymentViewModel.postPaymentViewModel(
            intentId: response.data!.paymentIntent!.id,
            methodId: response.data!.userPaymentMethod!.data!.first.id);

        Get.back();
      }
    } else {
      return;
    }

    // return jsonDecode(paymentViewModel.washeePaymentApiResponse.data);
  }

// final StripeCard stripeCard = card;

}

paymentStatusDialog(
    {required BuildContext context,
    required String title,
    required String msg}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      content: Text(
        msg,
        style: const TextStyle(fontSize: 14),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Container(
            width: 60,
            height: 30,
            color: Theme.of(context).primaryColor,
            child: const Center(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
