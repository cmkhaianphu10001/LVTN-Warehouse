import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/chatDatabase.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/Message/Channel/Channel.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/searchBar.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class CreateChannel extends StatefulWidget {
  const CreateChannel({Key key}) : super(key: key);

  @override
  _CreateChannelState createState() => _CreateChannelState();
}

class _CreateChannelState extends State<CreateChannel> {
  String search = '';

  getUser() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await UserService().getUser(pre.getString('token'));
  }

  getMyself(List<User> users) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String myID = Jwt.parseJwt(pre.getString('token'))['id'];
    User myself = users.firstWhere((User element) => element.id == myID);
    return myself;
  }

  createChannel({
    @required String roomID,
    @required String user1ID,
    @required String user2ID,
  }) {
    Map<String, dynamic> data = {
      'channelID': roomID,
      'users': {
        'user1': user1ID,
        'user2': user2ID,
      }
    };
    ChatDatabase().createChannel(roomID, data);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Channel'),
        backgroundColor: my_org,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            SearchBar(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  List<User> users = (snapshot.data as List<User>)
                      .where((User e) => e.role != 'manager')
                      .toList()
                      .where((User element) => element.name
                          .toLowerCase()
                          .contains(search.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: users.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: size.width,
                        margin:
                            EdgeInsets.only(bottom: 10, left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () async {
                            User myself = await getMyself(snapshot.data);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Channel(
                                    roomID: getRoomId(myself, users[index]),
                                    target: users[index],
                                    myself: myself,
                                  ),
                                ));
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      getdownloadUriFromDB(users[index].image),
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
                                      '${users[index].name}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${users[index].email}',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
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
            )
          ],
        ),
      ),
    );
  }
}
