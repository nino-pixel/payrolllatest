class EditProfileDialog extends StatelessWidget {
  final Userrofile profile;
  const EditProfileDialog({
   Key? key,
   required this.profile,
 }) : super(key: key);
  @override
 Widget build(BuildContext context) {
   return AlertDialog(
     title: const Text('Edit Profile'),
     content: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         // TODO: Add form fields
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
