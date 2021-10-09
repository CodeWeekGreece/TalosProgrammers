import 'package:book_in_shop/home.dart';
import 'package:book_in_shop/register.dart';
import 'package:book_in_shop/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'tYL0IJzIeBBuDDI16gusYnRsFjH2oyeHYuMfk1xE';
  const keyClientKey = 'x6iYGjmL71gaz5XzCT4HFE7zQVInEFBhKIuYrUoC';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();
  late String _username, _email, _password;
  bool isHidden = true;

  Future<void> _userData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('userData', [_username, _password,_email]);
  }

  Future<void> _isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Poppins",
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
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
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
            height: 150,
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 48,
                    color: Color(0xff2B305E),
                  )),
            ),
          ]),
          SizedBox(
            height: 25,
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(left: 38),
              child: Text("Let's get started",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff9195AB))),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: neu.Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: neu.NeumorphicStyle(
                  depth: neu.NeumorphicTheme.embossDepth(context),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Form(
                key: _form3Key,
                child: TextFormField(
                  validator: (text) {
                    if (text!.length < 8) {
                      //Checks Email format validity
                      return 'Username has to be at least 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your username...",
                    hintStyle: TextStyle(fontSize: 13),
                    errorStyle: TextStyle(fontSize: 10),
                    prefixIcon:
                        Icon(Icons.account_box, color: Color(0xff2B305E)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: neu.Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: neu.NeumorphicStyle(
                  depth: neu.NeumorphicTheme.embossDepth(context),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (text) {
                    if (!text!.contains("@") || !text.contains(".")) {
                      //Checks Email format validity
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email...",
                    hintStyle: TextStyle(fontSize: 13),
                    errorStyle: TextStyle(fontSize: 10),
                    prefixIcon: Icon(Icons.email, color: Color(0xff2B305E)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: neu.Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: neu.NeumorphicStyle(
                  depth: neu.NeumorphicTheme.embossDepth(context),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Form(
                key: _form2Key,
                child: TextFormField(
                  obscureText: isHidden,
                  validator: (text) {
                    if (text!.length < 8) {
                      //Checks password strength
                      return 'Password needs to be more than 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your password...",
                    hintStyle: TextStyle(fontSize: 13),
                    errorStyle: TextStyle(fontSize: 10),
                    prefixIcon: Icon(Icons.lock, color: Color(0xff2B305E)),
                    suffixIcon: InkWell(
                        onTap: togglepwd,
                        child: isHidden
                            ? Icon(Icons.visibility_off,
                                color: Color(0xff2B305E))
                            : Icon(Icons.visibility, color: Color(0xff2B305E))),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Builder(builder: (context) {
            return MaterialButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_form2Key.currentState!.validate()) {
                    if (_form3Key.currentState!.validate()) {
                      final user =
                          ParseUser.createUser(_username, _password, _email);

                      var response = await user.signUp();
                      if (response.success) {
                        _userData();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error!"),
                              content: Text(response.error!.message),
                              actions: <Widget>[
                                MaterialButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      //   try {
                      //     await auth.createUserWithEmailAndPassword(
                      //         email: _email, password: _password);
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) => Register()));
                      //   } on FirebaseAuthException catch (error) { //Shows error
                      //     Fluttertoast.showToast(
                      //         msg: error.message.toString(),
                      //         gravity: ToastGravity.TOP,
                      //         toastLength: Toast.LENGTH_LONG,
                      //         backgroundColor: Colors.white,
                      //         textColor: Colors.black);
                      //   }
                    }
                  }
                }
              },
              child: Text("Sign Up",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w100)),
              color: Color(0xff2B305E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              splashColor: Colors.cyanAccent,
            );
          }),
          SizedBox(
            height: 15,
          ),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text("Already have an account? Log in",
                  style: TextStyle(decoration: TextDecoration.underline)),
            ),
          ),
        ]),
      )),
    );
  }

  void togglepwd() {
    //Toggles Password visibility
    isHidden = !isHidden;
    setState(() {});
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form2Key = GlobalKey<FormState>();
  final _form3Key = GlobalKey<FormState>();

  late String _username, _password;
  bool isHidden = true;

  Future<void> _userData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('userData', [_username, _password]);
  }

  Future<void> _isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Poppins",
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
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
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
            height: 150,
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 48,
                    color: Color(0xff2B305E),
                  )),
            ),
          ]),
          SizedBox(
            height: 25,
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(left: 38),
              child: Text("Let's get started",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff9195AB))),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: neu.Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: neu.NeumorphicStyle(
                  depth: neu.NeumorphicTheme.embossDepth(context),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Form(
                key: _form3Key,
                child: TextFormField(
                  validator: (text) {
                    if (text!.length < 8) {
                      //Checks Email format validity
                      return 'Username has to be at least 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your username...",
                    hintStyle: TextStyle(fontSize: 13),
                    errorStyle: TextStyle(fontSize: 10),
                    prefixIcon:
                        Icon(Icons.account_box, color: Color(0xff2B305E)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: neu.Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: neu.NeumorphicStyle(
                  depth: neu.NeumorphicTheme.embossDepth(context),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Form(
                key: _form2Key,
                child: TextFormField(
                  obscureText: isHidden,
                  validator: (text) {
                    if (text!.length < 8) {
                      //Checks Password strength
                      return 'Password needs to be more than 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your password...",
                    hintStyle: TextStyle(fontSize: 13),
                    errorStyle: TextStyle(fontSize: 10),
                    prefixIcon: Icon(Icons.lock, color: Color(0xff2B305E)),
                    suffixIcon: InkWell(
                        onTap: togglepwd,
                        child: isHidden
                            ? Icon(Icons.visibility_off,
                                color: Color(0xff2B305E))
                            : Icon(Icons.visibility, color: Color(0xff2B305E))),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Builder(builder: (context) {
            return MaterialButton(
              onPressed: () async {
                if (_form3Key.currentState!.validate()) {
                  if (_form2Key.currentState!.validate()) {
                    final user = ParseUser(_username, _password, null);

                    var response = await user.login();
                    if (response.success) {
                      _userData();
                      _isLogged();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error!"),
                            content: Text(response.error!.message),
                            actions: <Widget>[
                              MaterialButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    //   try {
                    //     await auth.createUserWithEmailAndPassword(
                    //         email: _email, password: _password);
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) => Register()));
                    //   } on FirebaseAuthException catch (error) { //Shows error
                    //     Fluttertoast.showToast(
                    //         msg: error.message.toString(),
                    //         gravity: ToastGravity.TOP,
                    //         toastLength: Toast.LENGTH_LONG,
                    //         backgroundColor: Colors.white,
                    //         textColor: Colors.black);
                    //   }
                  }
                }
              },
              child: Text("Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w100)),
              color: Color(0xff2B305E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              splashColor: Colors.cyanAccent,
            );
          }),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            child: Text("Don't have an account? Sign up",
                style: TextStyle(decoration: TextDecoration.underline)),
          ),
        ]),
      )),
    );
  }

  void togglepwd() {
    //Toggles Password visibility
    isHidden = !isHidden;
    setState(() {});
  }
}
