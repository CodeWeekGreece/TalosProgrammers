import 'dart:convert';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Back4app{
  static final String _baseUrl = "https://parseapi.back4app.com/classes/";

  static Future<void> initParse() async{
    final keyApplicationId = 'tYL0IJzIeBBuDDI16gusYnRsFjH2oyeHYuMfk1xE';
    final keyClientKey = 'x6iYGjmL71gaz5XzCT4HFE7zQVInEFBhKIuYrUoC';
    final keyParseServerUrl ='hhtps://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl, clientKey: keyClientKey, autoSendSessionId: true);
    var todoFlutter = ParseObject('TodoFlutter')
      ..set('message', 'Hey! First message from Flutter. Parse is now connected'); 
    await todoFlutter.save();



  }




}
