import 'package:flutter/material.dart';
import 'package:humanscoring/utils/variable_utils.dart';

import '../../utils/font_style_utils.dart';

Widget feedBackReceivedText() {
  return Text(
    VariableUtils.feedbackReceived,
    style: FontTextStyle.roboto10W5grey,
    textAlign: TextAlign.center,
  );
}

Widget feedBackPostedText() {
  return Text(
    VariableUtils.feedbackPosted,
    style: FontTextStyle.roboto10W5grey,
    textAlign: TextAlign.center,
  );
}

Widget trustScoreText() {
  return Text(
    VariableUtils.trustScore,
    style: FontTextStyle.roboto10W5grey,
    textAlign: TextAlign.center,
  );
}
