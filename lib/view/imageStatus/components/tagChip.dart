import 'package:flutter/material.dart';


class TagChip extends StatelessWidget {

  final GestureTapCallback onTap;
  final Color backgroundColor;
  final Color rippleColor;
  final String text;

  TagChip({
    this.text,
    this.backgroundColor = const Color(0xffF5F5F5),
    this.rippleColor,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Material(
          color: this.rippleColor,
          child: InkWell(
            onTap: this.onTap,
            child: Container(
              decoration: ShapeDecoration(
                color: this.backgroundColor,

                shape: ChipTheme.of(context).shape,
              ),
              height: 32,
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20
              ),
              child: Center(
                widthFactor: 1,
                child: Text(this.text),
              ),
            ),
          ),
        ),
      ),
    );
  }

}