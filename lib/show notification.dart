import 'package:quick_notify/quick_notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Notify {
  var title, content;

  Future<bool> hasPermission() async {
    var hasPermission = await QuickNotify.hasPermission();
    print('hasPermission $hasPermission');
    return hasPermission;
  }

  void requestPermission(title, content) async {
    var requestPermission = await QuickNotify.requestPermission();
    notify(title, content);
    print('requestPermission $requestPermission');
  }

  notify(title, content) async {
    await hasPermission() == true
        ? QuickNotify.notify(
            title: title,
            content: content,
          )
        : requestPermission(title, content);
  }
}
