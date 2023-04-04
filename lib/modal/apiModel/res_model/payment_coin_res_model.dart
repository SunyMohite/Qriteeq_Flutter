class PaymentCoinResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  PaymentCoinResModel({this.status, this.error, this.message, this.data});

  PaymentCoinResModel.fromJson(Map<String, dynamic> json) {
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
  int? wallet;
  bool? open;
  int? payment;
  String? currency;
  String? showText;
  PaymentTransaction? transaction;

  Data({this.wallet, this.open, this.payment, this.currency, this.transaction});

  Data.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'];
    open = json['open'];
    payment = json['payment'];
    showText = json['showText'];
    currency = json['currency'];
    transaction = json['transaction'] != null
        ? PaymentTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet'] = wallet;
    data['open'] = open;
    data['payment'] = payment;
    data['currency'] = currency;
    data['showText'] = showText;
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class PaymentTransaction {
  num? amount;
  bool? status;
  String? user;
  String? mode;
  String? paymentType;
  String? reason;
  String? currency;
  String? message;
  String? id;

  PaymentTransaction(
      {this.amount,
      this.status,
      this.user,
      this.mode,
      this.paymentType,
      this.reason,
      this.currency,
      this.message,
      this.id});

  PaymentTransaction.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    status = json['status'];
    user = json['user'];
    mode = json['mode'];
    paymentType = json['paymentType'];
    reason = json['reason'];
    currency = json['currency'];
    message = json['message'];
    id = json['id'];
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
    data['message'] = message;
    data['id'] = id;
    return data;
  }
}
