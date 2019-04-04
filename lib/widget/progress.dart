import 'package:flutter/material.dart';

class ImageCardCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }

}

class FootProgress extends StatelessWidget {

  const FootProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
          height: 20.0,
          width: 20.0,
        ),
      ),
    );
  }

}

class CenterProgress extends StatelessWidget {

  const CenterProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
          height: 20.0,
          width: 20.0,
        ),
      ),
    );
  }

}