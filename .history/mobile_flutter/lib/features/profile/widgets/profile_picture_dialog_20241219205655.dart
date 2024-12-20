import 'package:flutter/material.dart';


class ProfilePictureDialog extends StatelessWidget {
  final String employeeId;

  const ProfilePictureDialog({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Handle the picked image file
      print('Image picked: ${pickedFile.path}');
    }

    // Close the dialog after picking an image
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Profile Picture'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
