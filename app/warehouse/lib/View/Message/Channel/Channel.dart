import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/chatDatabase.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';

class Channel extends StatefulWidget {
  const Channel({
    Key key,
    @required this.myself,
    @required this.target,
    @required this.roomID,
  }) : super(key: key);
  final User myself;
  final User target;
  final String roomID;

  @override
  _ChannelState createState() => _ChannelState(
        myself: myself,
        target: target,
        roomID: roomID,
      );
}

class _ChannelState extends State<Channel> {
  final User myself;
  final User target;
  final String roomID;

  _ChannelState({
    @required this.roomID,
    @required this.myself,
    @required this.target,
  });
  ScrollController _scrollController = ScrollController();
  TextEditingController inputMessage = TextEditingController();
  Stream messageStream;

  sendMessage() {
    if (inputMessage.text.isNotEmpty) {
      Map<String, dynamic> data = {
        "channelID": roomID,
        "ownName": myself.name,
        "message": inputMessage.text,
        "sendBy": myself.id,
        "timeSend": DateTime.now().millisecondsSinceEpoch,
      };
      ChatDatabase().sendMessage(roomID, data);
      inputMessage.text = '';
    }
  }

  setReaded() {
    ChatDatabase().readedSet(roomID, myself.id);
  }

  @override
  void initState() {
    messageStream = ChatDatabase().getMessage(roomID);
    setReaded();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${target != null ? target.name : "Message"}'),
        centerTitle: true,
        backgroundColor: my_org,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: listMessage(),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: inputMessage,
              decoration: InputDecoration(
                labelText: 'message',
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                contentPadding: EdgeInsets.all(10),
                suffixIcon: IconButton(
                  onPressed: () async {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                  ),
                ),
                hintText: '...',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            reverse: true,
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              messageStream.listen((event) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(0,
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.easeInOut);
                }
              });

              return snapshot.data.docs[index]['sendBy'] == myself.id
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${snapshot.data.docs[index]['ownName']}"),
                        ChatBubble(
                          clipper: ChatBubbleClipper1(
                            type:
                                snapshot.data.docs[index]['sendBy'] == myself.id
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                          ),
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(bottom: 20),
                          backGroundColor: my_org,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              "${snapshot.data.docs[index]['message']}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${snapshot.data.docs[index]['ownName']}"),
                        ChatBubble(
                          clipper: ChatBubbleClipper1(
                            type:
                                snapshot.data.docs[index]['sendBy'] == myself.id
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                          ),
                          backGroundColor: Color(0xffE7E7ED),
                          margin: EdgeInsets.only(bottom: 20),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              "${snapshot.data.docs[index]['message']}",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          );
        } else {
          return MyLoading();
        }
      },
    );
  }
}
