import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingView extends StatelessWidget {
  const ShimmerLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = Random().nextBool();

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(10),
          color: Colors.white,
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFEDEDED),
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  title: Row(children: const [ShimmerContainer()]),
                  subtitle: Row(
                    children: const [
                      ShimmerContainer(width: 50, height: 10),
                      SizedBox(width: 8),
                      ShimmerContainer(width: 20, height: 10),
                      SizedBox(width: 10),
                      ShimmerContainer(height: 10, width: 120),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5,
                  ),
                  child: isImage
                      ? const ShimmerContainer(height: 180)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (int i = 0; i < (Random().nextInt(10) + 3); i++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: const [
                                  ShimmerContainer(height: 8),
                                  SizedBox(height: 5),
                                ],
                              ),
                            Row(
                              children: const [
                                ShimmerContainer(height: 8, width: 180)
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final EdgeInsets? margin;

  const ShimmerContainer({
    Key? key,
    this.width = 30,
    this.height = 12,
    this.color = Colors.white,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
