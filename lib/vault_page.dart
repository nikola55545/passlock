// vault_page.dart
import 'package:flutter/cupertino.dart';

class VaultTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Vault'),
      ),
      child: Center(
        child: Text('Vault Tab Content'),
      ),
    );
  }
}
