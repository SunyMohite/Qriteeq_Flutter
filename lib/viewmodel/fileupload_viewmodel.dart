import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/commonWidget/snackbar.dart';
import '../modal/apiModel/res_model/image_upload_res_model.dart';
import '../modal/apis/api_response.dart';
import '../modal/repo/image_upload_repo.dart';

class FileUploadViewModel extends GetxController {
  ApiResponse uploadProfileApiResponse = ApiResponse.initial('Initial');

  Future<String?> uploadProfileImage({File? image}) async {
    await uploadProfile(query: image!);

    if (uploadProfileApiResponse.status == Status.COMPLETE) {
      ImageUploadResModel uploadProfileResModel = uploadProfileApiResponse.data;

      if (uploadProfileResModel.error == true) {
        showSnackBar(
            message: "${uploadProfileResModel.message}",
            snackColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        /// routing

        return uploadProfileResModel.data;
      }
    } else {
      showSnackBar(
          message: "Something went to wrong...",
          snackColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
    }
    return null;
  }

  /// UPLOAD File...
  Future<void> uploadProfile({required File query}) async {
    uploadProfileApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ImageUploadResModel response =
          await UploadImageRepo().uploadProfileRepo(image: query);
      uploadProfileApiResponse = ApiResponse.complete(response);
      // log("uploadProfileApiResponse RES:$response");
    } catch (e) {
      log('uploadProfileApiResponse.....$e');
      uploadProfileApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
