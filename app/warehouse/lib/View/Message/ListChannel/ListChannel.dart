import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/chatDatabase.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/Message/Channel/Channel.dart';
import 'package:warehouse/View/Message/CreateChannel/CreateChannel.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ListChannel extends StatefulWidget {
  const ListChannel({Key key}) : super(key: key);

  @override
  _ListChannelState createState() => _ListChannelState();
}

class _ListChannelState extends State<ListChannel> {
  String search = '';
  Stream listConversationStream;
  String myID = '';

  getUser() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    myID = Jwt.parseJwt(pre.getString('token'))['id'];
    return await UserService().getUser(pre.getString('token'));
  }

  getMyself(List<User> users) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    myID = Jwt.parseJwt(pre.getString('token'))['id'];
    User myself = users.firstWhere((User element) => element.id == myID);
    return myself;
  }

  @override
  void initState() {
    listConversationStream = ChatDatabase().getChannel();
    super.initState();
  }

  Widget listConversation(List<User> users) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: listConversationStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var conversation = snapshot.data.docs[index];
              String targetID =
                  (conversation["channelID"] as String).split("_")[0];
              User target =
                  users.firstWhere((element) => element.id == targetID);
              return GestureDetector(
                onTap: () async {
                  User myself = await getMyself(users);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Channel(
                          roomID: getRoomId(myself, target),
                          target: target,
                          myself: myself,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  width: size.width,
                  margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              getdownloadUriFromDB(target.image),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${target.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${conversation['message']}',
                              style: conversation['unread']
                                  ? conversation['sendBy'] != myID
                                      ? TextStyle(
                                          color:
                                              Color.fromARGB(255, 70, 53, 53),
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)
                                      : TextStyle(
                                          color: Colors.grey[500],
                                        )
                                  : TextStyle(
                                      color: Colors.grey[500],
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: my_org,
        title: Text('Message'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateChannel(),
              ));
        },
        backgroundColor: my_org,
        child: Icon(Icons.create),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return listConversation(snapshot.data);
                  } else {
                    return MyLoading();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
