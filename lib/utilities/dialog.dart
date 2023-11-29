import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String message, required int duration})
{
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: duration), backgroundColor: Colors.lightGreen,)
  );
}

Future<bool?> showWarningDialog({required BuildContext context, required String msg}) async
{
  AlertDialog dialog = AlertDialog(
    icon: Icon(Icons.warning, color: Colors.red),
    content: Text(msg),
    actions: [
      ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(true);
          },
          child: Text("Đồng ý")),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
          child: Text("Hủy")),
    ],
  );

  bool? confirm = await showDialog(context: context,
      builder: (context) => dialog,
      barrierDismissible: false
  );

  return confirm;
}