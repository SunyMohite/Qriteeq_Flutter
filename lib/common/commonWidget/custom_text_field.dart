
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:sizer/sizer.dart';

import '../../utils/enum_utils.dart';
import '../../utils/validation_utils.dart';

typedef OnChange = Function(String str);

class CommonTextField extends StatefulWidget {
  final String? titleText;
  final String? initialValue;
  final bool? isValidate;
  final bool? readOnly;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final String? regularExpression;
  final int? inputLength;
  final String? hintText;
  final String? validationMessage;
  final int? maxLine;
  final Widget? sIcon;
  final Widget? pIcon;
  final bool? obscureValue;
  final bool? withOutIcon;
  final double? containerHeight;
  final Color? containerBgColor;
  final TextStyle? hintStyle;
  final TextEditingController? textEditController;
  final Function? onTap;
  final bool? isAddress;
  final bool? useRegularExpression;
  final ValidationType? validationtype;
  final OnChange? onChange;

  const CommonTextField({
    Key? key,
    this.onChange,
    this.titleText,
    this.isValidate,
    this.containerHeight,
    this.textInputType,
    this.withOutIcon,
    this.hintStyle,
    this.regularExpression = '',
    this.inputLength,
    this.readOnly = false,
    this.hintText,
    this.validationMessage,
    this.maxLine,
    this.sIcon,
    this.containerBgColor,
    // this.onChange,
    this.initialValue = '',
    this.obscureValue,
    this.pIcon,
    this.textEditController,
    this.textCapitalization,
    this.onTap,
    this.isAddress,
    this.useRegularExpression,
    this.validationtype,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  /// PLEASE IMPORT GETX PACKAGE
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      style: const TextStyle(color: Colors.white),
      onTap: () {
        if (widget.isAddress == true) {
          widget.onTap!();
        }
      },
      controller: widget.textEditController,
      cursorColor: Colors.grey,
      maxLines: widget.maxLine ?? 1,
      textInputAction: TextInputAction.done,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      inputFormatters: widget.regularExpression!.isEmpty
          ? [
              LengthLimitingTextInputFormatter(widget.inputLength),
            ]
          : [
              LengthLimitingTextInputFormatter(widget.inputLength),
              FilteringTextInputFormatter.allow(RegExp(
                  widget.regularExpression ??
                      RegularExpression.alphabetDigitsDashPattern))
            ],
      keyboardType: widget.textInputType,
      validator: (value) {
        return widget.isValidate == false
            ? null
            : value!.isEmpty
                ? widget.validationMessage
                : widget.validationtype == ValidationType.email
                    ? ValidationMethod.validateUserName(value)
                    : widget.validationtype == ValidationType.pNumber
                        ? ValidationMethod.validatePhoneNo(value)
                        : null;
      },
      decoration: InputDecoration(
        prefixIcon: widget.pIcon,
        suffixIcon: widget.sIcon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyNew),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.greyNew),
        ),
        hintStyle: widget.hintStyle ??
            TextStyle(fontSize: 10.sp, color: ColorUtils.greyNew),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      ),
    );
  }
}
