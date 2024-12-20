import 'package:flutter/material.dart';
import '../../../data/models/user_profile.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;

  const EditProfileDialog({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  @override
  Widget build(BuildContext context) {
    // Implement your build method here
  }
} 