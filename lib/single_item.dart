import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CredentialDetailsPage extends StatelessWidget {
  final String username;
  final String password;
  final String website;
  final String note;

  CredentialDetailsPage({
    required this.username,
    required this.password,
    required this.website,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff10111A),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xff10111A),
        middle: Text('Credential Details'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildDetailRow('Username:', username),
              const SizedBox(height: 10),
              _buildDetailRow('Password:', password),
              const SizedBox(height: 10),
              _buildDetailRow('Website:', website),
              const SizedBox(height: 10),
              _buildDetailRow(
                  'Note:', note.isNotEmpty ? note : 'No note provided'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: CupertinoColors.black,
          ),
        ),
      ],
    );
  }
}
