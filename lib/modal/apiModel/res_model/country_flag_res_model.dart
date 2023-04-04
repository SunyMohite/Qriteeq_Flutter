import 'dart:convert';

List<CountryFlagResModel> countryFlagResModelFromJson(String str) =>
    List<CountryFlagResModel>.from(
        json.decode(str).map((x) => CountryFlagResModel.fromJson(x)));

String countryFlagResModelToJson(List<CountryFlagResModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryFlagResModel {
  CountryFlagResModel({
    this.name,
    this.code,
    this.emoji,
    this.unicode,
    this.image,
  });

  String? name;
  String? code;
  String? emoji;
  String? unicode;
  String? image;

  factory CountryFlagResModel.fromJson(Map<String, dynamic> json) =>
      CountryFlagResModel(
        name: json["name"],
        code: json["code"],
        emoji: json["emoji"],
        unicode: json["unicode"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "emoji": emoji,
        "unicode": unicode,
        "image": image,
      };
}
