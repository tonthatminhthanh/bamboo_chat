import 'dart:async';

import 'package:flutter/cupertino.dart';

void scrollDown(ScrollController controller) {
  if(controller.hasClients)
    {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
    }
  else
    {
      Timer(Duration(milliseconds: 400), () => scrollDown(controller));
    }
}