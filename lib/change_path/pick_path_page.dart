import 'package:filidown/change_path/pick_path.dart';
import 'package:flutter/material.dart';

class PickPathPage extends StatelessWidget {
  const PickPathPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        PickPath()
      ],
    );
  }
}