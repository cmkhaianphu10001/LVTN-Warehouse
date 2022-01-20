import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function onChanged;
  const SearchBar({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.05,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 5,
      ),
      width: size.width * 0.9,
      decoration: BoxDecoration(
          // border: Border.all(color: myPrimary),
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(-5, 2),
              color: Colors.grey,
              spreadRadius: 2,
            ),
          ]),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: 'Search...',
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
