import 'package:flutter/material.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/colors.dart';

class UserCard extends StatelessWidget {
  final Function onTap;
  final User user;
  final int index;
  const UserCard({
    Key key,
    this.user,
    this.index,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: size.height * 0.1,
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 7), // changes position of shadow
            ),
          ],
          color: index % 2 == 0 ? Colors.white : Colors.white54,
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: size.height * 0.08,
              width: size.height * 0.08,
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                backgroundImage: user.image == ''
                    ? AssetImage('assets/images/default-person.png')
                    : NetworkImage(
                        domain + 'public/upload/images/' + user.image),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${user.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${user.email}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
