import 'package:humanscoring/modal/apiModel/res_model/payment_coin_res_model.dart';
class DashBoardResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  DashBoardResModel({this.status, this.error, this.message, this.data});

  DashBoardResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? user;
  String? sender;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? coinsCredited;
  PaymentTransaction? transaction;

  Data(
      {this.sId,
      this.user,
      this.sender,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.createdAt,
      this.updatedAt,
      this.coinsCredited,
      this.transaction,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    sender = json['sender'];
    score = json['score'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    coinsCredited = json['coinsCredited'];
    iV = json['__v'];
    transaction = json['transaction'] != null
        ? PaymentTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['sender'] = sender;
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['coinsCredited'] = coinsCredited;
    data['__v'] = iV;
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}
