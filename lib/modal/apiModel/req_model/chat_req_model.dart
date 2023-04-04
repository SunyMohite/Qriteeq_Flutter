
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<MessageModelClass> messageModelClassFromJson(String str) =>
    List<MessageModelClass>.from(
        json.decode(str).map((x) => MessageModelClass.fromJson(x)));

String messageModelClassToJson(List<MessageModelClass> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageModelClass {
  MessageModelClass({
    this.message,
    this.messageType,
    this.time,
    this.senderId,
    this.senderImg,
  });

  String? message;
  String? messageType;
  String? time;
  String? senderId;
  String? senderImg;

  factory MessageModelClass.fromJson(Map<String, dynamic> json) =>
      MessageModelClass(
        message: json["message"],
        messageType: json["messageType"],
        time: json["time"],
        senderId: json["senderId"],
        senderImg: json["senderImg"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "messageType": messageType,
        "time": time,
        "senderId": senderId,
        "senderImg": senderImg,
      };
}

class ConversationsModel {
  String? conversationId;
  DateTime? created;
  String? lastmessage;
  String? reciever;
  String? recieverAvatar;
  String? recieverusername;
  String? sendarAvatar;
  String? sender;
  String? senderusername;
  String? uniquekey;

  ConversationsModel.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    created = (json['created'] as Timestamp).toDate();
    lastmessage = json['lastmessage'];
    reciever = json['reciever'];
    recieverAvatar = json['recieverAvatar'];
    recieverusername = json['recieverusername'] ?? '';
    sendarAvatar = json['sendarAvatar'];
    sender = json['sender'];
    senderusername = json['senderusername'];
    uniquekey = json['uniquekey'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversationId'] = conversationId;
    data['created'] = created;
    data['lastmessage'] = lastmessage;
    data['reciever'] = reciever;
    data['recieverAvatar'] = recieverAvatar;
    data['recieverusername'] = recieverusername;
    data['sendarAvatar'] = sendarAvatar;
    data['sender'] = sender;
    data['senderusername'] = senderusername;
    data['uniquekey'] = uniquekey;

    return data;
  }
}

class MessagesModel {
  String? conid;
  String? lastmessage;
  String? messageId;
  DateTime? created;
  DateTime? update;
  List<MessageList>? messageList;

  MessagesModel(
      {this.created,
      this.messageList,
      this.lastmessage,
      this.update,
      this.conid,
      this.messageId});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    conid = json['conid'];
    lastmessage = json['lastmessage'];
    messageId = json['messageId'];
    if (json['message'] != null) {
      messageList = (json['message'] as List)
          .map((e) => MessageList.fromJson(e))
          .toList();
    }
    created = (json['created'] as Timestamp).toDate();
    update = (json['update'] as Timestamp).toDate();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conid'] = conid;
    data['lastmessage'] = lastmessage;
    data['messageId'] = messageId;
    data['created'] = created;
    data['update'] = update;
    if (messageList != null) {
      data['message'] = messageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageList {
  DateTime? created;
  String? message;
  String? reciever;
  String? sendarAvatar;
  String? sender;
  String? fileName;
  String? fileExt;
  String? filePath;
  bool? text;

  MessageList(
      {this.created,
      this.message,
      this.reciever,
      this.sendarAvatar,
      this.sender,
      this.text,
      this.fileName,
      this.fileExt,
      this.filePath});

  MessageList.fromJson(Map<String, dynamic> json) {
    created = (json['created'] as Timestamp).toDate();

    message = json['message'];
    reciever = json['reciever'];
    sendarAvatar = json['sendarAvatar'];
    sender = json['sender'];
    fileName = json['fileName'];
    sender = json['sender'];
    sender = json['sender'];
    fileExt = json['fileExt'];
    filePath = json['filePath'];
    text = json['text'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    data['message'] = message;
    data['reciever'] = reciever;
    data['sendarAvatar'] = sendarAvatar;
    data['sender'] = sender;
    data['fileName'] = fileName;
    data['fileExt'] = fileExt;
    data['filePath'] = filePath;
    data['text'] = text;

    return data;
  }
}
