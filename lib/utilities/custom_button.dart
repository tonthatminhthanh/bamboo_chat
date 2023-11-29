import 'package:flutter/material.dart';

ElevatedButton createElevatedRouteButton({required BuildContext context,
  required Color color,
  required String text,
  double width = 100,
  double height = 40,
  required WidgetBuilder builder})
{
  return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(width as double, height as double)),
        backgroundColor: MaterialStateProperty.all<Color>(color)
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: builder));
      }, child: Text(text, style: TextStyle(color: Colors.white,fontSize: 16),));
}