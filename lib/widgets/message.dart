import 'package:driver/utils/colors.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Message extends StatelessWidget {
  final bool isMe;
  final bool isNear;
  final String senderId;
  final String senderName;
  final String messageText;
  final String destination;
  final LatLng location;
  final DateTime timestamp;

  const Message({
    Key key,
    this.isMe,
    this.isNear,
    this.senderId,
    this.senderName,
    this.messageText,
    this.destination,
    this.location,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isNear,
      child: Container(
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Material(
              color: isMe ? MyColors.primary : invertInvertColorsMild(context),
              borderRadius: BorderRadius.circular(8.0),
              elevation: 1.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$senderName says:',
                      style: isMe
                          ? MessageSenderStyles.black
                          : isThemeCurrentlyDark(context)
                              ? MessageSenderStyles.white
                              : MessageSenderStyles.black,
                    ),
                    Text(
                      messageText,
                      style: isMe
                          ? MessageTextStyles.black
                          : isThemeCurrentlyDark(context)
                              ? MessageTextStyles.white
                              : MessageTextStyles.black,
                    ),
                  ],
                ),
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
