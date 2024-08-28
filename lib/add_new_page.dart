// add_new_page.dart
import 'package:flutter/cupertino.dart';

class AddNewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add New'),
      ),
      child: Center(
        child: Text('Add New Tab Content'),
      ),
    );
  }
}
