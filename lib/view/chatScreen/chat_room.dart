import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/modal/apiModel/req_model/chat_req_model.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/no_leading_space_formatter.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/chatScreen/show_upload_image.dart';
import 'package:humanscoring/viewmodel/chat_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../service/chat_video_player_service.dart';
import '../../../service/download_file.dart';
import '../../../utils/const_utils.dart';
import '../../../utils/enum_utils.dart';

CollectionReference firebaseMessagesCollection =
    kFirebaseFirestore.collection('messages');

CollectionReference firebaseMessagesMediaSendingCollection =
    kFirebaseFirestore.collection('messagesMediaSending');

CollectionReference chatConversationsCollection =
    kFirebaseFirestore.collection('conversations');

class ChatRoom extends StatefulWidget {
  final ConversationsModel conversationsModel;

  const ChatRoom({Key? key, required this.conversationsModel})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController chatController = TextEditingController();
  ScrollController scrollController = ScrollController();

  FocusNode focusNode = FocusNode();
  String? docId;
  List images = [
    Image.asset(
      purpleCamera,
      fit: BoxFit.contain,
    ),
    Image.asset(
      gallaryImg,
      fit: BoxFit.contain,
    ),
    Image.asset(
      viedocallImg,
      fit: BoxFit.contain,
    ),
    Image.asset(
      pdfImg,
      fit: BoxFit.contain,
    )
  ];

  File? file;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final doc = await firebaseMessagesMediaSendingCollection
        .where('conid', isEqualTo: widget.conversationsModel.conversationId)
        .get();
    if (doc.docs.isEmpty) {
      final data = await firebaseMessagesMediaSendingCollection.doc().get();
      docId = data.id;
    } else {
      docId = doc.docs.first.id;
    }
    setState(() {});
  }

  ChatViewModel con = Get.find();

  Stream<MessagesModel> getMessage() {
    return firebaseMessagesMediaSendingCollection.doc(docId).snapshots().map(
        (event) =>
            MessagesModel.fromJson(event.data() as Map<String, dynamic>));
  }

  bool isFileDownload = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 18.w,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        'assets/image/appbarbg.png',
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Material(
                          color: ColorUtils.transparent,
                          borderRadius: BorderRadius.circular(150),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(150),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconsWidgets.backArrow,
                            ),
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizeConfig.sW3,
                        Row(
                          children: [
                            SizedBox(
                              height: 12.w,
                              width: 12.w,
                              child: InkWell(
                                onTap: () {},
                                child: OctoImageWidget(
                                  profileLink:
                                      widget.conversationsModel.recieverAvatar,
                                  radius: 5.w,
                                ),
                              ),
                            ),
                            SizeConfig.sW2,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${widget.conversationsModel.recieverusername}",
                                  style: FontTextStyle.poppinsWhite11semiB
                                      .copyWith(fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              chatField(),
                              _localFileImage(),
                              SizeConfig.sH1
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ///BOTTOM VIEW FOR CHAT TEXT FIELD AND ATTACHED DATA...
                Container(
                  // height: 23.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.7), blurRadius: 9)
                    ],
                    color: ColorUtils.white,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.5),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              attachBottomSheet(),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorUtils.grayBorder),
                                  color: ColorUtils.whiteF7,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.3),
                                child: IconsWidgets.uploadProof,
                              )),
                        ),
                        SizeConfig.sW2,
                        Expanded(
                          child: Container(
                            decoration: DecorationUtils.borderAndRadius(),
                            child: TextField(
                              focusNode: focusNode,
                              controller: chatController,
                              maxLines: 5,
                              minLines: 1,
                              textCapitalization: TextCapitalization.sentences,
                              inputFormatters: [NoLeadingSpaceFormatter()],
                              decoration: InputDecoration(
                                  border: DecorationUtils.textFieldDecoration,
                                  fillColor: ColorUtils.whiteF7,
                                  filled: true,
                                  hintText: VariableUtils.writeMessageHint,
                                  hintMaxLines: 1,
                                  hintStyle: FontTextStyle.poppins14regular
                                      .copyWith(
                                          color: ColorUtils.grayTextHint,
                                          fontSize: 14),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.w)),
                            ),
                          ),
                        ),
                        SizeConfig.sW2,
                        InkWell(
                          onTap: () async {
                            if (chatController.text.isEmpty) {
                              return;
                            } else {
                              var textMessage = chatController.text;
                              chatController.clear();
                              final DateTime now = DateTime.now();

                              MessageList model = MessageList();

                              model.created = now;
                              model.text = true;
                              model.filePath = '';
                              model.fileExt = '';
                              model.fileName = '';
                              model.message = textMessage;
                              model.reciever =
                                  widget.conversationsModel.reciever;
                              model.sender =
                                  PreferenceManagerUtils.getLoginId();
                              model.sendarAvatar =
                                  PreferenceManagerUtils.getUserAvatar();

                              await firebaseMessagesMediaSendingCollection
                                  .doc(docId)
                                  .set({
                                "conid":
                                    widget.conversationsModel.conversationId,
                                "lastmessage": textMessage,
                                "messageId": docId,
                                "created": now,
                                "update": now,
                                "message": FieldValue.arrayUnion(
                                  [
                                    model.toJson(),
                                  ],
                                )
                              }, SetOptions(merge: true));
                              await chatConversationsCollection
                                  .doc(widget.conversationsModel.conversationId)
                                  .update({
                                "lastmessage": textMessage,
                              });
                            }

                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                          },
                          child: CircleAvatar(
                            radius: 20.5,
                            child: IconsWidgets.send,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isFileDownload == true
                ? const CircularIndicator()
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  StreamBuilder<MessagesModel> chatField() {
    return StreamBuilder<MessagesModel>(
      stream: getMessage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
          );
        }
        if (snapshot.hasError) {
          return const SizedBox();
        }

        final message = snapshot.data!.messageList;
        return message!.isEmpty
            ? const SizedBox()
            : ListView.builder(
                controller: scrollController,
                itemCount: message.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = message[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                    child: Row(
                      mainAxisAlignment:
                          data.sender == PreferenceManagerUtils.getLoginId()
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        data.sender == PreferenceManagerUtils.getLoginId()
                            ? const SizedBox()
                            : OctoImageWidget(
                                profileLink:
                                    widget.conversationsModel.recieverAvatar,
                              ),
                        SizeConfig.sW2,
                        data.text == true
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                constraints: BoxConstraints(
                                    maxWidth: data.sender ==
                                            PreferenceManagerUtils.getLoginId()
                                        ? 80.w
                                        : 70.w),
                                decoration: BoxDecoration(
                                  color: data.sender ==
                                          PreferenceManagerUtils.getLoginId()
                                      ? ColorUtils.black61
                                      : ColorUtils.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.message!,
                                      style: FontTextStyle.poppinsWhite11normal
                                          .copyWith(
                                        fontWeight: FontWeightClass.regular,
                                        color: data.sender ==
                                                PreferenceManagerUtils
                                                    .getLoginId()
                                            ? ColorUtils.white
                                            : ColorUtils.black1A,
                                      ),
                                    ),
                                    SizeConfig.sH05,
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          DateFormat.jm().format(data.created!),
                                          style: FontTextStyle
                                              .poppinsWhite11normal
                                              .copyWith(
                                            fontSize: 8.sp,
                                            color: data.sender ==
                                                    PreferenceManagerUtils
                                                        .getLoginId()
                                                ? ColorUtils.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizeConfig.sW1,
                                        IconsWidgets.correct,
                                      ],
                                    ),
                                  ],
                                ),
                              )

                            ///FOR DOCUMENT....
                            : data.fileExt == FileExt.doc.name
                                ? data.sender ==
                                        PreferenceManagerUtils.getLoginId()
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await firebaseDownloadFile(
                                                    data.filePath!,
                                                    DateTime.now()
                                                        .microsecondsSinceEpoch);
                                              },
                                              child: Container(
                                                width: Get.width / 1.5,
                                                height: 15.w,
                                                alignment:
                                                    Alignment.centerRight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: ColorUtils.grey
                                                      .withOpacity(0.2),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        height: 6.w,
                                                        width: 6.w,
                                                        child: const Icon(Icons
                                                            .file_copy_sharp)),
                                                    SizedBox(
                                                      width: 1.w,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        data.fileName!,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    const Icon(Icons.download),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              DateFormat.jm()
                                                  .format(data.created!),
                                              style: FontTextStyle
                                                  .poppinsWhite11normal
                                                  .copyWith(
                                                fontSize: 8.sp,
                                                color: data.sender ==
                                                        PreferenceManagerUtils
                                                            .getLoginId()
                                                    ? ColorUtils.black
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            right: 20.w, left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, right: 4),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200),
                                                    child: OctoImage(
                                                      height: 8.w,
                                                      width: 8.w,
                                                      image:
                                                          const CachedNetworkImageProvider(
                                                        '',
                                                      ),
                                                      placeholderBuilder:
                                                          OctoPlaceholder
                                                              .blurHash(
                                                        'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                      ),
                                                      errorBuilder: (context,
                                                              obj, stack) =>
                                                          Image.asset(
                                                              'assets/image/profile_dummy.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      firebaseDownloadFile(
                                                          data.filePath!,
                                                          DateTime.now()
                                                              .microsecondsSinceEpoch);
                                                    },
                                                    child: Container(
                                                      // width: Get.width,
                                                      height: 15.w,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: ColorUtils.grey,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                    height: 6.w,
                                                                    width: 6.w,
                                                                    child: const Icon(
                                                                        Icons
                                                                            .file_copy_sharp)),
                                                                SizedBox(
                                                                  width: 1.w,
                                                                ),
                                                                Expanded(
                                                                  child: Text(data
                                                                      .fileName!),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Icon(
                                                              Icons.download),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              DateFormat.jm()
                                                  .format(data.created!),
                                              style: FontTextStyle
                                                  .poppinsWhite11normal
                                                  .copyWith(
                                                fontSize: 8.sp,
                                                color: data.sender ==
                                                        PreferenceManagerUtils
                                                            .getLoginId()
                                                    ? ColorUtils.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )

                                ///FOR VIDEO....

                                : data.fileExt == FileExt.video.name
                                    ? data.sender ==
                                            PreferenceManagerUtils.getLoginId()
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 0,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child:
                                                                ChatVideoPlayerService(
                                                              url: data
                                                                  .filePath!,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 0),
                                                      child: Text(
                                                        DateFormat.jm().format(
                                                            data.created!),
                                                        style: FontTextStyle
                                                            .poppinsWhite11normal
                                                            .copyWith(
                                                          fontSize: 8.sp,
                                                          color: data.sender ==
                                                                  PreferenceManagerUtils
                                                                      .getLoginId()
                                                              ? ColorUtils.black
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200),
                                                  child: OctoImage(
                                                    height: 8.w,
                                                    width: 8.w,
                                                    image:
                                                        const CachedNetworkImageProvider(
                                                      ' widget.receiverImg!',
                                                    ),
                                                    placeholderBuilder:
                                                        OctoPlaceholder
                                                            .blurHash(
                                                      'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                    ),
                                                    errorBuilder: (context, obj,
                                                            stack) =>
                                                        Image.asset(
                                                            'assets/image/profile_dummy.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5,
                                                              left: 5),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child:
                                                            ChatVideoPlayerService(
                                                          url: data.filePath!,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        DateFormat.jm().format(
                                                            data.created!),
                                                        style: FontTextStyle
                                                            .poppinsWhite11normal
                                                            .copyWith(
                                                          fontSize: 8.sp,
                                                          color: data.sender ==
                                                                  PreferenceManagerUtils
                                                                      .getLoginId()
                                                              ? ColorUtils.black
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                    :

                                    /// MEDIA PHOTO,CAMERA,
                                    data.sender ==
                                            PreferenceManagerUtils.getLoginId()
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 0,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child:
                                                                ShowUploadImage(
                                                              image:
                                                                  data.filePath,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 0),
                                                      child: Text(
                                                        DateFormat.jm().format(
                                                            data.created!),
                                                        style: FontTextStyle
                                                            .poppinsWhite11normal
                                                            .copyWith(
                                                          fontSize: 8.sp,
                                                          color: data.sender ==
                                                                  PreferenceManagerUtils
                                                                      .getLoginId()
                                                              ? ColorUtils.black
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }

  Container attachBottomSheet() {
    return Container(
      height: 20.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: Get.height * 0.04,
            crossAxisSpacing: Get.height * 0.04,
            mainAxisSpacing: Get.height * 0.04,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                Get.back();
                switch (index) {
                  case 0:
                    {
                      imageFromCamera();
                    }
                    break;
                  case 1:
                    {
                      uploadMultiImage(type: FileType.image);
                    }
                    break;

                  case 2:
                    {
                      uploadMultiImage(type: FileType.video);
                    }
                    break;
                  case 3:
                    {
                      uploadMultiImage(
                          type: FileType.custom,
                          extensionsList: ['pdf', 'doc']);
                    }
                    break;
                  default:
                    {
                      if (kDebugMode) {
                        print("null");
                      }
                    }
                    break;
                }
              },
              child: images[index],
            );
          },
        ),
      ),
    );
  }

  ///IMAGE FROM CAMERA......
  Future<XFile?> imageFromCamera() async {
    try {
      final pickImage = ImagePicker();
      final result = await pickImage.pickImage(source: ImageSource.camera);
      if (result != null) {
        final file = File(result.path);
        Get.back();
        con.setLocalFile = getExt(file.path.split(".").last);
        con.update();

        await uploadImgFirebaseStorage(
            file: file,
            ext: getExt(file.path.split(".").last),
            fileName: ConstUtils.kGetFileName(file.path));
      }
    } on Exception catch (e) {
      log('error $e');
    }
    return null;
  }

  /// ======================UPLOAD MULTI IMAGE===========================
  Future uploadMultiImage(
      {FileType? type, List<String>? extensionsList}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
          type: type!,
          allowCompression: true,
          allowedExtensions: extensionsList);
      if (result != null) {
        final file = File(result.files.first.path!);
        con.setLocalFile = getExt(file.path.split(".").last);
        con.update();
        await uploadImgFirebaseStorage(
            file: file,
            ext: getExt(file.path.split(".").last),
            fileName: ConstUtils.kGetFileName(file.path));
      }
    } on Exception catch (e) {
      log('error $e');
    }
  }

  String getExt(String extensions) {
    extensions = extensions.toUpperCase();
    if (VariableUtils.imageFormatList.contains("." + extensions)) {
      return FileExt.image.name;
    } else if (VariableUtils.videoFormatList.contains("." + extensions)) {
      return FileExt.video.name;
    } else if (VariableUtils.documentFormatList.contains("." + extensions)) {
      return FileExt.doc.name;
    } else {
      return '';
    }
  }

  /// ======================UPLOAD FIREBASE STORAGE===========================
  uploadImgFirebaseStorage({File? file, String? ext, String? fileName}) async {
    try {
      var snapshot = await storage.FirebaseStorage.instance
          .ref()
          .child('ChatImage/${DateTime.now().microsecondsSinceEpoch}')
          .putFile(file!);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      DocumentSnapshot doc =
          await firebaseMessagesMediaSendingCollection.doc(docId).get();
      List body = [];
      if (doc.exists) {
        body = doc.get('message');
      }
      final DateTime now = DateTime.now();
      MessageList model = MessageList();

      model.created = now;
      model.text = false;
      model.filePath = downloadUrl;
      model.fileExt = ext;
      model.fileName = fileName;
      model.message = chatController.text;
      model.reciever = widget.conversationsModel.reciever;
      model.sender = PreferenceManagerUtils.getLoginId();
      model.sendarAvatar = PreferenceManagerUtils.getUserAvatar();
      body.add(model.toJson());

      await firebaseMessagesMediaSendingCollection.doc(docId).set({
        "conid": widget.conversationsModel.conversationId,
        "lastmessage": chatController.text,
        "messageId": docId,
        "created": now,
        "update": now,
        "message": body,
      }, SetOptions(merge: true)).then((value) {
        con.setLocalFile = '';
        con.update();
      });
      await chatConversationsCollection
          .doc(widget.conversationsModel.conversationId)
          .update({
        "lastmessage": chatController.text,
      });
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } catch (e) {
      if (kDebugMode) {
        log('$e');
      }
    }
  }

  /// ======================LOCAL FILE IMAGE===========================
  Widget _localFileImage() {
    return GetBuilder<ChatViewModel>(
      builder: (controller) {
        return controller.localFile == ''
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: controller.localFile == FileExt.image.name
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Shimmer.fromColors(
                              child: Container(
                                height: 150,
                                width: 150,
                                color: Colors.grey[400],
                              ),
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade200),
                        )
                      : controller.localFile == FileExt.doc.name
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade200,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.w, right: 10),
                                  child: Container(
                                    // width: Get.width,
                                    height: 15.w,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: ColorUtils.grey,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                ),
              );
      },
    );
  }
}
