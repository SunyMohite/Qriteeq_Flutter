import 'package:humanscoring/modal/apiModel/res_model/payment_coin_res_model.dart';

class GetScoreRatingResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetScoreRatingResModel({this.status, this.error, this.message, this.data});

  GetScoreRatingResModel.fromJson(Map<String, dynamic> json) {
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
  Score? score;
  int? feedbacksPostedCount;
  int? feedbacksReceivedCount;
  int? feedbacksPostedPercentage;
  int? feedbacksReceivedPercentage;
  int? amount;
  PaymentTransaction? transaction;

  Data(
      {this.score,
      this.feedbacksPostedCount,
      this.feedbacksReceivedCount,
      this.feedbacksPostedPercentage,
      this.amount,
      this.feedbacksReceivedPercentage,
      this.transaction});

  Data.fromJson(Map<String, dynamic> json) {
    score = json['score'] != null ? Score.fromJson(json['score']) : null;
    feedbacksPostedCount = json['feedbacksPostedCount'];
    feedbacksReceivedCount = json['feedbacksReceivedCount'];
    feedbacksPostedPercentage = json['feedbacksPostedPercentage'];
    feedbacksReceivedPercentage = json['feedbacksReceivedPercentage'];
    amount = json['amount'];
    transaction = json['transaction'] != null
        ? PaymentTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (score != null) {
      data['score'] = score!.toJson();
    }
    data['feedbacksPostedCount'] = feedbacksPostedCount;
    data['feedbacksReceivedCount'] = feedbacksReceivedCount;
    data['feedbacksPostedPercentage'] = feedbacksPostedPercentage;
    data['feedbacksReceivedPercentage'] = feedbacksReceivedPercentage;
    data['amount'] = amount;
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class Score {
  String? sId;
  int? great;
  int? amazing;
  int? fine;
  int? bad;
  int? poor;

  Score({this.sId, this.great, this.amazing, this.fine, this.bad, this.poor});

  Score.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    great = json['great'];
    amazing = json['amazing'];
    fine = json['fine'];
    bad = json['bad'];
    poor = json['poor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['great'] = great;
    data['amazing'] = amazing;
    data['fine'] = fine;
    data['bad'] = bad;
    data['poor'] = poor;
    return data;
  }
}
