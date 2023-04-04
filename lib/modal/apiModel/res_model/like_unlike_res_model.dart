import 'package:humanscoring/modal/apiModel/res_model/payment_coin_res_model.dart';

class FeedBackLikeUnLikeResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  FeedBackLikeUnLikeResModel(
      {this.status, this.error, this.message, this.data});

  FeedBackLikeUnLikeResModel.fromJson(Map<String, dynamic> json) {
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
  String? feedback;
  String? ftype;
  String? createdAt;
  String? updatedAt;
  int? coinsCredited;
  PaymentTransaction? transaction;

  Data({
    this.sId,
    this.user,
    this.feedback,
    this.ftype,
    this.createdAt,
    this.updatedAt,
    this.coinsCredited,
    this.transaction,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    feedback = json['feedback'];
    ftype = json['ftype'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    coinsCredited = json['coinsCredited'];
    transaction = json['transaction'] != null
        ? PaymentTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['coinsCredited'] = coinsCredited;
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class CommentFlagViewModelRes {
  String? status;
  String? user;
  String? feedback;
  String? ftype;
  String? reason;
  String? flagged;
  String? id;

  CommentFlagViewModelRes(
      {this.status,
      this.user,
      this.feedback,
      this.ftype,
      this.reason,
      this.flagged,
      this.id});

  CommentFlagViewModelRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    user = json['user'];
    feedback = json['feedback'];
    ftype = json['ftype'];
    reason = json['reason'];
    flagged = json['flagged'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;

    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['reason'] = reason;
    data['flagged'] = flagged;
    data['id'] = id;
    return data;
  }
}
