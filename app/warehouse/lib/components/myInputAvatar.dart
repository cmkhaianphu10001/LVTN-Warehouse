import 'dart:io';

import 'package:flutter/material.dart';

import '../colors.dart';

class MyInputAvatar extends StatelessWidget {
  const MyInputAvatar({
    Key key,
    File imagePicked,
    this.getImageFromGallery,
    this.width,
    this.height,
  })  : _imagePicked = imagePicked,
        super(key: key);
  final double width, height;
  final File _imagePicked;
  final Function getImageFromGallery;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: width != null ? width : size.height * 0.2,
      height: height != null ? height : size.height * 0.2,
      // padding: EdgeInsets.all(size.height * 0.02),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: my_org,
        ),
        // color: Colors.yellow,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
                // color: Colors.green,
                width: width != null ? width : size.height * 0.2,
                height: height != null ? height : size.height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: my_org,
                  ),
                  // color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: _imagePicked != null
                      ? FileImage(_imagePicked)
                      : AssetImage(
                          'assets/images/default-person.png',
                        ),
                )),
          ),
          Positioned(
            left: -5,
            top: -5,
            child: IconButton(
              // color: Colors.white,
              splashColor: my_org,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.grey,
              ),
              onPressed: getImageFromGallery,
            ),
          )
        ],
      ),
    );
  }
}
