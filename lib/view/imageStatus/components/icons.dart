import 'package:flutter/material.dart';


class ImageStatusButton extends StatelessWidget {

  final Function showStatus;

  ImageStatusButton({
    this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.info_outline),
        tooltip: '图片详情',
        onPressed: this.showStatus,
    );
  }

}