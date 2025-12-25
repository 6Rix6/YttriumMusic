import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innertube_dart/innertube_dart.dart' as yt;

class MoreButtonWidget extends StatelessWidget {
  final yt.ButtonRenderer moreButton;
  const MoreButtonWidget({super.key, required this.moreButton});

  @override
  Widget build(BuildContext context) {
    final endpoint = moreButton.navigationEndpoint;
    if (endpoint?.browseEndpoint != null) {
      return IconButton(
        icon: const Icon(CupertinoIcons.chevron_right),
        onPressed: () {},
      );
    }
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Theme.of(context).hintColor),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      ),
      child: Text(moreButton.text!.runs!.first.text),
    );
  }
}
