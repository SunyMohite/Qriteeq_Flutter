class FeedLikeRequestModel {
  String? by;
  String? toLike;
  bool? favorite;

  FeedLikeRequestModel({this.by, this.toLike, this.favorite});

  FeedLikeRequestModel.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    toLike = json['to'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['to'] = toLike;
    data['favorite'] = favorite;
    return data;
  }

  Map<String, dynamic> toJsonNonExistsUser() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['favorite'] = favorite;
    return data;
  }
}
