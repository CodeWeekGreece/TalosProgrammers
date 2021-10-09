import 'package:book_in_shop/intro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart' as intro;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String strType = "Restaurant";
  var types = ["Restaurant", "Cafe", "Health", "Shop"];
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();
  final controller5 = TextEditingController();
  final controller6 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  List data = [];
  var uid = "";
  var sid = "";
  bool isLogged = false;

  Future<void> _isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
  }

  Future<bool> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final islogged = prefs.getBool("loggedIn");
    if (islogged == null) {
      return false;
    }
    return islogged;
  }

  Future<void> _boolLog() async {
    final prefs = await SharedPreferences.getInstance();
    bool checkLog = await _checkIfLoggedIn();
    setState(() {
      isLogged = checkLog;
    });
  }

  Future<List> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getStringList("userData");
    if (userData == null) {
      return [];
    }
    return userData;
  }

  Future<void> _userData() async {
    final prefs = await SharedPreferences.getInstance();
    List userData = await _getUser();
    setState(() {
      data = userData;
    });
    getID();
    getStoreID();
  }

  void getID() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'));
    parseQuery.whereContains('username', data[0]);
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var object in apiResponse.results as List<ParseObject>) {
        setState(() {
          uid = object.objectId.toString();
        });
      }
    }
  }

  void getStoreID() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Stores'));
    parseQuery.whereContains('storeName', uid);
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var object in apiResponse.results as List<ParseObject>) {
        // print(object.objectId.toString());
        setState(() {
          sid = object.objectId.toString();
        });
      }
    }
  }

  void initState() {
    super.initState();
    _userData();
    _boolLog();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                      width: 85,
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                  ]),
                  Text(
                    "Book In",
                    style: GoogleFonts.overlock(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 48,
                            color: Color(0xff2B305E))),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  Text(
                    "Register your Store",
                    style: GoogleFonts.overlock(
                        textStyle: TextStyle(fontSize: 40)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "NOW",
                      style: GoogleFonts.overlock(
                          textStyle: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Store Name',
                            ),
                            validator: (text) {
                              if (text == "") {
                                return "Please enter a valid name";
                              } else
                                return null;
                            },
                            controller: controller1,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _formKey1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Store Address',
                            ),
                            validator: (text) {
                              if (text == "") {
                                return "Please enter a valid address";
                              } else
                                return null;
                            },
                            controller: controller2,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _formKey2,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Store Biography',
                            ),
                            validator: (text) {
                              if (text == "") {
                                return "Please enter a valid biography";
                              } else
                                return null;
                            },
                            controller: controller3,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _formKey3,
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Store Tables',
                            ),
                            validator: (text) {
                              if (text == "") {
                                return "Please enter a valid amount of tables available";
                              } else
                                return null;
                            },
                            controller: controller4,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _formKey4,
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Store Customers Amount',
                            ),
                            validator: (text) {
                              if (text == "") {
                                return "Please enter a valid amount of customers";
                              } else
                                return null;
                            },
                            controller: controller5,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: _formKey5,
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Store Visit Duration (in minutes)',
                            ),
                            validator: (text) {
                              if (text == "") {
                                return "Please enter a valid amount of time";
                              } else
                                return null;
                            },
                            controller: controller6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownButton(
                    value: strType,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: types.map((String types) {
                      return DropdownMenuItem(value: types, child: Text(types));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        strType = value.toString();
                      });
                    },
                  ),
                  CupertinoButton(
                      child: Text("Register Store"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_formKey1.currentState!.validate()) {
                            if (_formKey2.currentState!.validate()) {
                              if (_formKey3.currentState!.validate()) {
                                if (_formKey4.currentState!.validate()) {
                                  if (_formKey5.currentState!.validate()) {
                                    showAlert();
                                  }
                                }
                              }
                            }
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerStore() async {
    if (isLogged) {
      print(uid);
      final QueryBuilder<ParseObject> parseQuery =
          QueryBuilder<ParseObject>(ParseObject('Stores'));
      parseQuery.whereContains('ownerId', uid);
      final ParseResponse apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        for (var object in apiResponse.results as List<ParseObject>) {
          print(object.objectId.toString());
          setState(() {
            sid = object.objectId.toString();
          });
        }
      }

      var store = ParseObject('Stores')
        ..objectId = sid
        ..set('storeName', controller1.text)
        ..set('address', controller2.text)
        ..set('bio', controller3.text)
        ..set('type', strType)
        ..set('ownerId', uid)
        ..set('duration', int.parse(controller6.text))
        ..set('tables', int.parse(controller4.text))
        ..set('customers', int.parse(controller5.text));
      await store.save();
    } else {
      var store = ParseObject('Stores')
        ..set('storeName', controller1.text)
        ..set('address', controller2.text)
        ..set('bio', controller3.text)
        ..set('type', strType)
        ..set('ownerId', uid)
        ..set('duration', int.parse(controller6.text))
        ..set('tables', int.parse(controller4.text))
        ..set('customers', int.parse(controller5.text));
      await store.save();
    }
  }

  void showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
                "Are you sure you want to register a shop with those credentials? You will be able to change them later on"),
            actions: [
              CupertinoDialogAction(
                  child: Text("Yes"),
                  onPressed: () async {
                    _isLogged();
                    registerStore();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IntrodutionScreen()));
                  }),
              CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
