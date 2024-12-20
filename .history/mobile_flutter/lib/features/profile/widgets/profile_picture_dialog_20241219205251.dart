class ProfilePictureDialog extends StatelessWidget {
 final String employeeId;
  const ProfilePictureDialog({Key.key,
   required this.employeeId,
 });
  @override
 Widget build(BuildContext context) {
   return AlertDialog(
     title: const Text('Change Profile Picture'),
     content: Column(
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
     actions: [
       TextButton(
         onPressed: () => Navigator.of(context).pop(),
         child: const Text('Cancel'),
       ),
     ],
   );
 }
}