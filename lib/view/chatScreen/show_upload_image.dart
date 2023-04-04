import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:shimmer/shimmer.dart';

class ShowUploadImage extends StatelessWidget {
  final String? image;

  const ShowUploadImage({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image == null
        ? const SizedBox()
        : InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: OctoImage(
                  image: NetworkImage(image!),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[400],
                      child: const Center(
                        child: Icon(Icons.report_gmailerrorred_outlined),
                      ),
                    );
                  },
                  progressIndicatorBuilder: (context, event) {
                    return SizedBox(
                      height: 150,
                      width: 150,
                      child: Shimmer.fromColors(
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey[400],
                          ),
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200),
                    );
                  }),
            ),
          );
  }
}
