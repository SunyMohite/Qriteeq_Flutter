class PaymentInitReqModel {
  num? amount;
  String? currency;
  String? cardNum;
  int? cardExpMonth;
  int? cardExpYear;
  String? cardCvc;

  PaymentInitReqModel(
      {this.amount,
      this.currency,
      this.cardNum,
      this.cardExpMonth,
      this.cardExpYear,
      this.cardCvc});

  PaymentInitReqModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
    cardNum = json['cardNum'];
    cardExpMonth = json['cardExpMonth'];
    cardExpYear = json['cardExpYear'];
    cardCvc = json['cardCvc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    data['cardNum'] = cardNum;
    data['cardExpMonth'] = cardExpMonth;
    data['cardExpYear'] = cardExpYear;
    data['cardCvc'] = cardCvc;
    return data;
  }
}
