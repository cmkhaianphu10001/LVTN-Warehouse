import 'package:flutter/material.dart';

class ElementButton extends StatelessWidget {
  const ElementButton({
    Key key,
    @required this.focus,
    this.label = '',
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.id,
    this.icon,
    this.color,
  }) : super(key: key);
  final int id;
  final int focus;
  final String label;
  final Function onTap;
  final Function onTapDown;
  final Function onTapUp;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // color = myColor1;
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        GestureDetector(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTap: onTap,
          child: Container(
            height: size.width * 0.18,
            width: size.width * 0.18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[300],
                  focus == id ? color.withOpacity(0.05) : Colors.grey[300]
                ],
              ),
              borderRadius: BorderRadius.circular(size.width * 0.1),
            ),
            child: Icon(
              icon,
              size: size.width * 0.08,
              color: focus == id ? color : Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.005,
        ),
        Container(
          height: size.height * 0.045,
          child: Text(
            label,
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: focus == id ? color.withOpacity(0.6) : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
