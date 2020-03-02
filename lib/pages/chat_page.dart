import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/services/censor.dart';
import 'package:driver/services/firebase_analytics.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/translations.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:driver/widgets/message.dart';
import 'package:driver/widgets/message_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChatPage extends StatefulWidget {
  final SharedPreferences helper;
  final LatLng location;
  final String language;

  MyChatPage({
    Key key,
    @required this.helper,
    @required this.location,
    @required this.language,
  }) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  bool noHotspotMessages = true;
  bool isScrollDownVisible = true;
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final messageExpireInterval =
      Duration(hours: 1); // timeout to delete old messages

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 300),
    );
  }

  Message _messageChecker(
      DocumentSnapshot doc, List<DocumentSnapshot> docs, String identity) {
    final messageTimestamp = doc.data['timestamp'].toDate();
    final timeDiff = DateTime.now().difference(messageTimestamp);
    final messageLocation = LatLng(doc.data['location']['geopoint'].latitude,
        doc.data['location']['geopoint'].longitude);

    if (timeDiff > messageExpireInterval) {
      // if expired, delete the message
      final documentId = doc.documentID;
      Firestore.instance
          .collection('global_chat')
          .document(documentId)
          .delete();
      if (docs.length <= 1) {
        return Message(
          isMe: identity == doc.data['senderId'],
          isNear: false,
          senderId: null,
          senderName: null,
          messageText: null,
          destination: null,
          location: messageLocation,
          timestamp: messageTimestamp,
        );
      }
    }
  }

  Future<void> _sendMessage(TextEditingController messageController) async {
    String name = widget.helper.getString('userName');
    String identity = widget.helper.getString('uuid');
    String messageText = messageController.text;

    messageController.clear();

    if (name == null) {
      int random = Random().nextInt(1000); // 0 to 999
      name = 'Driver ' + random.toString() + '🛺';
      widget.helper.setString('userName', name);
    }

    if (messageText.length > 0) {
      GeoFirePoint geoPoint = Geoflutterfire().point(
          latitude: widget.location.latitude,
          longitude: widget.location.longitude);
      messageText = censor(messageText);

      await Firestore.instance.collection('global_chat').add({
        'senderId': identity,
        'senderName': name,
        'messageText': messageText,
        'destination': null,
        'location': geoPoint.data,
        'timestamp': DateTime.now(),
      });
      _scrollDown();
      logAnalyticsEvent('message_sent_driver');
    }
  }

  @override
  Widget build(BuildContext context) {
    String identity = widget.helper.getString('uuid');

    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                left: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    tooltip: 'Go back',
                    iconSize: 20.0,
                    color: invertColorsStrong(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    chat(widget.language),
                    style: isThemeCurrentlyDark(context)
                        ? TitleStyles.white
                        : TitleStyles.black,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('global_chat')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return messagePlaceholder(context, 'Loading messages...');

                    List<DocumentSnapshot> docs = snapshot.data.documents;

                    if (docs.isEmpty)
                      return messagePlaceholder(context,
                          'You can chat with all Fliver users\nto discuss traffic related issues');

                    List<Widget> messages = docs
                        .map((doc) => _messageChecker(doc, docs, identity))
                        .toList();

                    return Stack(
                      children: <Widget>[
                        ListView(
                          controller: _scrollController,
                          children: <Widget>[
                            ...messages,
                          ],
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 7.5,
                          child: Visibility(
                            visible: isScrollDownVisible,
                            child: FloatingActionButton(
                              mini: true,
                              child: Icon(Icons.keyboard_arrow_down),
                              foregroundColor: invertInvertColorsTheme(context),
                              backgroundColor: invertColorsTheme(context),
                              onPressed: () {
                                _scrollDown();
                                setState(() {
                                  isScrollDownVisible = false;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Message in global chat',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: invertColorsStrong(context),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: invertColorsTheme(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  FloatingActionButton(
                    heroTag: 'chat',
                    foregroundColor: invertInvertColorsTheme(context),
                    backgroundColor: invertColorsTheme(context),
                    child: Icon(Icons.send),
                    elevation: 5.0,
                    tooltip: 'Send',
                    onPressed: () {
                      _sendMessage(_messageController);
                      setState(() {
                        isScrollDownVisible = false;
                      });
                    },
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
