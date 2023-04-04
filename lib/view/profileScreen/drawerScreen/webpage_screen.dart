import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/circular_progress_indicator.dart';
import '../../../common/commonWidget/custom_header.dart';
import '../../../utils/color_utils.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, this.titleBarText, this.webUrl})
      : super(key: key);
  final String? titleBarText, webUrl;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: ColorUtils.whiteE5,
        child: Column(
          children: [
            CustomHeaderWidget(
              headerTitle: widget.titleBarText!,
            ),
            Expanded(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Stack(
                  children: <Widget>[
                    WebView(
                      key: _key,
                      initialUrl: widget.webUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (finish) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                    isLoading
                        ? const Center(
                            child: CircularIndicator(),
                          )
                        : Stack(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
