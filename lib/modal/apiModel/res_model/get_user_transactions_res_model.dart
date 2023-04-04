class GetUserTransactionsResModel {
  int? status;
  bool? error;
  String? message;
  List<TransactionsData>? data;

  GetUserTransactionsResModel(
      {this.status, this.error, this.message, this.data});

  GetUserTransactionsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TransactionsData>[];
      json['data'].forEach((v) {
        data!.add(TransactionsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionsData {
  num? amount;
  bool? status;
  String? user;
  String? mode;
  String? paymentType;
  String? reason;
  String? currency;
  String? id;
  String? rewardType;
  String? rewardId;
  String? message;

  TransactionsData(
      {this.amount,
      this.status,
      this.user,
      this.mode,
      this.paymentType,
      this.reason,
      this.currency,
      this.id,
      this.rewardType,
      this.rewardId,
      this.message});

  TransactionsData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    status = json['status'];
    user = json['user'];
    mode = json['mode'];
    paymentType = json['paymentType'];
    reason = json['reason'];
    currency = json['currency'];
    id = json['id'];
    rewardType = json['rewardType'];
    rewardId = json['rewardId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['status'] = status;
    data['user'] = user;
    data['mode'] = mode;
    data['paymentType'] = paymentType;
    data['reason'] = reason;
    data['currency'] = currency;
    data['id'] = id;
    data['rewardType'] = rewardType;
    data['rewardId'] = rewardId;
    data['message'] = message;
    return data;
  }
}
