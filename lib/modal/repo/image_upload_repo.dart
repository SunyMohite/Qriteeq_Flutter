import 'dart:io';

import 'package:humanscoring/modal/apiModel/res_model/image_upload_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/modal/services/base_service.dart';

class UploadImageRepo extends BaseService {
  Future uploadProfileRepo({required File image}) async {
    final response = await ApiService().uploadImage(image);
    // log("UploadProfileResModel res... :${response}");
    ImageUploadResModel imageUploadResModel =
        ImageUploadResModel.fromJson(response);
    return imageUploadResModel;
  }
}
