import 'package:book_in_shop/home.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart' as intro;
import 'package:shared_preferences/shared_preferences.dart';

class IntrodutionScreen extends StatefulWidget {
  @override
  _IntrodutionScreenState createState() => _IntrodutionScreenState();
}

class _IntrodutionScreenState extends State<IntrodutionScreen> {
  List<intro.PageViewModel> getPages() {
    return [
      intro.PageViewModel(
          image: Image.asset(
            "images/Cafe.gif",
            height: 12,
            width: 12,
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
      intro.PageViewModel(
          image: Image.asset(
            "images/Health.gif",
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
      intro.PageViewModel(
          image: Image.asset(
            "images/Restaurant.gif",
            height: 128,
            width: 128,
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
      intro.PageViewModel(
          image: Image.asset(
            "images/shop.gif",
            height: 128,
            width: 128,
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
    ];
  }

  List<intro.PageViewModel> getDarkPages() {
    return [
      intro.PageViewModel(
          image: Image.asset(
            "images/Cafe_Dark.gif",
            height: 12,
            width: 12,
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
      intro.PageViewModel(
          image: Image.asset(
            "images/Health_Dark.gif",
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
      intro.PageViewModel(
          image: Image.asset(
            "images/Restaurant_Dark.gif",
            height: 128,
            width: 128,
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
      intro.PageViewModel(
          image: Image.asset(
            "images/Shop_Dark.gif",
            height: 128,
            width: 128,
          ),
          title: "welcome",
          body: "Make your reservations with our app!",
          footer: Text(
            "Manraf",
          )),
    ];
  }

  bool isDark = false;
  bool isGreek = false;

  @override
  void initState() {
    super.initState();
    _darkStartup();
    _greekStartup();
  }

  Future<bool> _getDarkBoolFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final darkEnabled = prefs.getBool("darkEnabled");
    if (darkEnabled == null) {
      return false;
    }
    return darkEnabled;
  }

  Future<void> _darkStartup() async {
    final prefs = await SharedPreferences.getInstance();
    bool darkEnabled = await _getDarkBoolFromSharedPref();
    setState(() {
      isDark = darkEnabled;
    });
  }

  Future<bool> _getLangBoolFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final greekEnabled = prefs.getBool("greekEnabled");
    if (greekEnabled == null) {
      return false;
    }
    return greekEnabled;
  }

  Future<void> _greekStartup() async {
    final prefs = await SharedPreferences.getInstance();
    bool greekEnabled = await _getLangBoolFromSharedPref();
    setState(() {
      isGreek = greekEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
            scaffoldBackgroundColor: const Color(0xFF13232B),
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: intro.IntroductionScreen(
                  pages: isDark ? getDarkPages() : getPages(),
                  done: Text(
                    "Done",
                  ),
                  onDone: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  showNextButton: false,
                  showSkipButton: true,
                  skip: const Text("Skip"),
                  dotsDecorator: intro.DotsDecorator(
                      size: const Size.square(10.0),
                      activeSize: const Size(20.0, 10.0),
                      activeColor: Colors.cyan,
                      color: Colors.black26,
                      spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)))))),
    );
  }
}
