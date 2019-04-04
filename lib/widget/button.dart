import 'package:flutter/material.dart';



class TagChip extends StatelessWidget {

  final Widget label;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final Color backgroundColor;
  TagChip({
    @required this.label,
    this.onTap,
    this.onLongPress,
    this.backgroundColor
  }):assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      ),
      child: Material(
        color: this.backgroundColor,
        shape:  StadiumBorder(),
        child: InkWell(
          customBorder: StadiumBorder(),
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5,
            ),
            child: this.label,
          ),
          onTap: this.onTap,
          onLongPress: this.onLongPress,
        ),
      ),
    );
  }

}