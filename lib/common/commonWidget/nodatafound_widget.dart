import 'package:flutter/material.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String message;
  const NoDataFoundWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
