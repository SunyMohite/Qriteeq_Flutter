import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:humanscoring/utils/shared_preference_utils.dart';

import '../../utils/const_utils.dart';
import '../../utils/enum_utils.dart';
import '../apis/api_exception.dart';
import 'base_service.dart';

class ApiService extends BaseService {
  Map<String, String> header({APIHeaderType? status}) {
    String token = PreferenceManagerUtils.getLoginToken();
    if (status == APIHeaderType.fileUploadWithToken) {
      return {'Content-Type': "form-data", "Authorization": 'Bearer $token'};
    } else if (status == APIHeaderType.fileUploadWithoutToken) {
      return {
        'Content-Type': "form-data",
      };
    } else if (status == APIHeaderType.jsonBodyWithToken) {
      return {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $token'
      };
    } else if (status == APIHeaderType.onlyToken) {
      return {"Authorization": 'Bearer $token'};
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  final dio.Dio _dio = dio.Dio();

  Future<dynamic> uploadImage(File file) async {
    String fileName = file.path.split('/').last;
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    log("UPLOAD URL ${baseUrl + "upload"}");
    response = await _dio.post(baseUrl + "upload",
        data: formData,
        options: dio.Options(
          headers: header(status: APIHeaderType.fileUploadWithToken),
        ));
    response = returnResponse(response.statusCode!, jsonEncode(response.data));

    return response;
  }

  var response;
  Future<dynamic> getResponse(
      {required APIType? apiType,
      required String? url,
      bool withToken = true,
      Map<String, dynamic>? body,
      bool fileUpload = false}) async {
    String uri = baseUrl + url!;
    logs("LOGIN AUTH  ${PreferenceManagerUtils.getLoginToken()}");
    logs("REQUEST FOR API ${jsonEncode(body)}");

    try {
      ///=======GET METHOD============
      if (apiType == APIType.aGet) {
        var result = await http.get(
          Uri.parse(uri),
          headers: header(
            status: withToken
                ? APIHeaderType.jsonBodyWithToken
                : APIHeaderType.jsonBodyWithoutToken,
          ),
        );
        response = returnResponse(
          result.statusCode,
          result.body,
        );

        logs("URL $uri \n Result=======GET===========${result.body}");
      }

      ///=========POST METHOD=============
      else if (apiType == APIType.aPost) {
        var result = await http.post(
          Uri.parse(uri),
          body: jsonEncode(body),
          headers: header(
            status: withToken
                ? APIHeaderType.jsonBodyWithToken
                : APIHeaderType.jsonBodyWithoutToken,
          ),
        );
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        logs("URL $uri \n Result===== POST=============${result.body}");
      }

      ///=======PUT METHOD============
      else if (apiType == APIType.aPut) {
        var result = await http.put(
          Uri.parse(uri),
          body: jsonEncode(body),
          headers: header(
            status: withToken
                ? APIHeaderType.jsonBodyWithToken
                : APIHeaderType.jsonBodyWithoutToken,
          ),
        );
        response = returnResponse(
          result.statusCode,
          result.body,
        );

        logs("URL $uri \n Result======PUT============${result.body}");
      }

      ///========DELETE METHOD=========
      else if (apiType == APIType.aDelete) {
        var result = await http.delete(
          Uri.parse(uri),
          headers: header(
            status: withToken
                ? APIHeaderType.jsonBodyWithToken
                : APIHeaderType.jsonBodyWithoutToken,
          ),
        );
        response = returnResponse(
          result.statusCode,
          result.body,
        );
        logs("URL $uri \n Result=====DELETE=============${result.body}");
      }
      return response;
    } catch (e) {
      logs('Error=>.. $e');
    }
  }

  returnResponse(int status, String result) {
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 201:
        return jsonDecode(result);
      case 256:
        return jsonDecode(result);
      case 400:
        throw BadRequestException('Bad Request');
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }
}
