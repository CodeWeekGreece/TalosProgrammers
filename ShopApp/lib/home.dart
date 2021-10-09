import 'package:book_in_shop/intro.dart';
import 'package:book_in_shop/main.dart';
import 'package:book_in_shop/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:alan_voice/alan_voice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    AlanVoice.addButton(
        "750aa201e43b3e3f78e30c72b27651232e956eca572e1d8b807a3e2338fdd0dc/stage");
    buttonAlign:
    AlanVoice.BUTTON_ALIGN_LEFT;
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      case "reservations":
        setState(() {
          _pageController.jumpToPage(0);
        });
        break;
      default:
        debugPrint("Uknown command");
    }
  }

  int _currentPage = 0;
  final _pageController = PageController();
  List data = [];
  var uid = "";
  var sid = "";

  bool isDark = false;
  bool isGreek = false;
  bool isLogged = true;

  @override
  //Checks for Language choice and Theme choice
  void initState() {
    super.initState();
    _darkStartup();
    _greekStartup();
    _isLogged();
    _userData();
  }

  Future<bool> _getDarkBoolFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final darkEnabled = prefs.getBool("darkEnabled");
    if (darkEnabled == null) {
      return false;
    }
    return darkEnabled;
  }

  Future<void> _isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', true);
  }

  Future<void> _darkSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkEnabled', isDark);
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

  Future<void> _greekSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('greekEnabled', isDark);
  }

  Future<void> _greekStartup() async {
    final prefs = await SharedPreferences.getInstance();
    bool greekEnabled = await _getLangBoolFromSharedPref();
    setState(() {
      isGreek = greekEnabled;
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
        // results.add(object.objectId.toString());
        setState(() {
          sid = object.objectId.toString();
        });
      }
    }
  }

  List results = [];
  void doQueryByStoreId() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Stores'));
    parseQuery.whereContains('objectId', sid);
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        final object = o as ParseObject;
        results.add(object.get<String>('storeName'));
        results.add(object.get<String>('address'));
        results.add(object.get<String>('type'));
        results.add(object.get<String>('bio'));
        results.add(object.get<String>('reservations'));
        results.add(object.get<int>('tables').toString());
        results.add(object.get<int>('customers').toString());
        results.add(object.get<int>('duration').toString());
        // print('${object.get<String>('storeName')} - ${object.get<String>('bio')}');
      }
    } else {
      results = [
        'Store Name',
        'Address',
        'Type',
        'Biography',
        'Tables',
        'Customers',
        'Duration'
      ];
    }
    setState(() {
      results = results;
    });
  }

  var storename = "";
  void getstoreName() {
    doQueryByStoreId();
    setState(() {
      storename = results[0];
    });
  }

  var address = "";
  void getaddress() {
    doQueryByStoreId();
    setState(() {
      address = results[1];
    });
  }

  var type = "";
  void gettype() {
    doQueryByStoreId();
    setState(() {
      type = results[2];
    });
  }

  var bio = "";
  void getbio() {
    doQueryByStoreId();
    setState(() {
      bio = results[3];
    });
  }

  var tables = "";
  void gettables() {
    doQueryByStoreId();
    setState(() {
      tables = results[5];
    });
  }

  var customers = "";
  void getcustomers() {
    doQueryByStoreId();
    setState(() {
      customers = results[6];
    });
  }

  var duration = "";
  void getduration() {
    doQueryByStoreId();
    setState(() {
      duration = results[7];
    });
  }

  var reservations = "";
  void getreservations() {
    doQueryByStoreId();
    setState(() {
      reservations = results[4];
    });
  }

  List reservationList = [];
  void makereservlist() {
    getreservations();
    setState(() {
      reservationList = reservations.split('*');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
            scaffoldBackgroundColor: const Color(0xFF15202B),
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: isGreek //Page in Greek
              ? Scaffold(
                  body: PageView(
                    controller: _pageController,
                    children: [
                      ListView.builder(
                          itemCount: reservationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(title: Text("Ημέρα: "+reservationList[index].split("_")[0].toString()+" : "+reservationList[index].split("_")[1].split("/")[0].toString()+"\nΌνομα: "+reservationList[index].split("_")[1].split("/")[2].toString()+"\nΆτομα: "+reservationList[index].split("_")[1].split("/")[1].toString(),style: TextStyle(fontSize: 14),));
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      storename,
                                      style: GoogleFonts.overlock(
                                          textStyle: TextStyle(fontSize: 40)),
                                    ),
                                  ]),
                              Text("Διεύθυνση: $address",
                                  style: TextStyle(fontSize: 16)),
                              Text("Τύπος καταστήματος: $type",
                                  style: TextStyle(fontSize: 16)),
                              Text("Βιογραφία: $bio",
                                  style: TextStyle(fontSize: 16)),
                              Text("Πλήθος τραπεζιών: $tables",
                                  style: TextStyle(fontSize: 16)),
                              Text("Πλήθος πελατών: $customers",
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                  "Χρόνος παραμονής πελατών(σε λεπτά): $duration",
                                  style: TextStyle(fontSize: 16)),
                            ]),
                      ),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 85,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  ),
                                ]),
                            Text(
                              "Book In",
                              style: GoogleFonts.overlock(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 48,
                                // color: Color(0xff2B305E)
                              )),
                            ),
                            SizedBox(
                              height: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0, left: 16.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.orange
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.public_rounded,
                                          color: Colors.orange,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Γλώσσα",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                          isGreek ? '  Ελληνικά' : ' Αγγλικά',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    CupertinoSwitch(
                                        value: isGreek,
                                        onChanged: onLangChanged,
                                        activeColor: Colors.orange)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.create_rounded,
                                          color: Colors.lightBlue,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                      "Επεξεργασία",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Spacer(
                                      flex: 7,
                                    ),
                                    Builder(builder: (context) {
                                      return IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Register()));
                                          },
                                          icon: Icon(
                                              Icons.chevron_right_rounded));
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.indigo
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.bedtime_rounded,
                                          color: Colors.indigo,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Σκοτάδι",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                          isDark
                                              ? '              On'
                                              : '                Off',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    CupertinoSwitch(
                                        value: isDark,
                                        onChanged: onModeChanged,
                                        activeColor: Colors.indigo)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.pink.withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.help_rounded,
                                          color: Colors.pink,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                      "Βοήθεια",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Spacer(
                                      flex: 7,
                                    ),
                                    Builder(builder: (context) {
                                      return IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        IntrodutionScreen()));
                                          },
                                          icon: Icon(
                                              Icons.chevron_right_rounded));
                                    }),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Builder(builder: (context) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool('loggedIn', false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Αποσύνδεση",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Builder(builder: (context) {
                                          return Icon(Icons.logout_rounded);
                                        }),
                                      ],
                                    ),
                                  );
                                }),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      getstoreName();
                      getaddress();
                      gettype();
                      getbio();
                      gettables();
                      getcustomers();
                      getduration();
                      makereservlist();
                    },
                  ),
                  bottomNavigationBar: BottomBar(
                    selectedIndex: _currentPage,
                    onTap: (int index) {
                      _pageController.jumpToPage(index);
                      setState(() => _currentPage = index);
                    },
                    items: <BottomBarItem>[
                      BottomBarItem(
                        icon: Icon(Icons.chair_rounded),
                        title: Text('Κρατήσεις'),
                        activeColor: Colors.red,
                        darkActiveColor: Colors.red.shade400,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.store_rounded),
                        title: Text('Το κατάστημά μου'),
                        activeColor: Colors.greenAccent.shade700,
                        darkActiveColor: Colors.greenAccent.shade400,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.settings),
                        title: Text('Ρυθμίσεις'),
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  body: PageView(
                    controller: _pageController,
                    children: [
                     ListView.builder(
                          itemCount: reservationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(title: Text("Date: "+reservationList[index].split("_")[0].toString()+" : "+reservationList[index].split("_")[1].split("/")[0].toString()+"\nName: "+reservationList[index].split("_")[1].split("/")[2].toString()+"\nPeople: "+reservationList[index].split("_")[1].split("/")[1].toString()+"\n",style: TextStyle(fontSize: 14),));
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      storename,
                                      style: GoogleFonts.overlock(
                                          textStyle: TextStyle(fontSize: 40)),
                                    ),
                                  ]),
                              Text("Address: $address",
                                  style: TextStyle(fontSize: 16)),
                              Text("Store Type: $type",
                                  style: TextStyle(fontSize: 16)),
                              Text("Biography: $bio",
                                  style: TextStyle(fontSize: 16)),
                              Text("Amount of tables: $tables",
                                  style: TextStyle(fontSize: 16)),
                              Text("Amount of customers: $customers",
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                  "Customer length of stay(in minutes): $duration",
                                  style: TextStyle(fontSize: 16)),
                            ]),
                      ),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 85,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  ),
                                ]),
                            Text(
                              "Book In",
                              style: GoogleFonts.overlock(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 48,
                                // color: Color(0xff2B305E)
                              )),
                            ),
                            SizedBox(
                              height: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 16.0, left: 16.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.orange
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.public_rounded,
                                          color: Colors.orange,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Language",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                          isGreek ? '  Greek' : ' English',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    CupertinoSwitch(
                                        value: isGreek,
                                        onChanged: onLangChanged,
                                        activeColor: Colors.orange)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.create_rounded,
                                          color: Colors.lightBlue,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                      "Edit Store",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Spacer(
                                      flex: 7,
                                    ),
                                    Builder(builder: (context) {
                                      return IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Register()));
                                          },
                                          icon: Icon(
                                              Icons.chevron_right_rounded));
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.indigo
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.bedtime_rounded,
                                          color: Colors.indigo,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Dark Mode",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                          isDark ? '     On' : '     Off',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    CupertinoSwitch(
                                        value: isDark,
                                        onChanged: onModeChanged,
                                        activeColor: Colors.indigo)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.pink.withOpacity(0.2),
                                              shape: BoxShape.circle),
                                        ),
                                        Icon(
                                          Icons.help_rounded,
                                          color: Colors.pink,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                      "Help",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Spacer(
                                      flex: 7,
                                    ),
                                    Builder(builder: (context) {
                                      return IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        IntrodutionScreen()));
                                          },
                                          icon: Icon(
                                              Icons.chevron_right_rounded));
                                    }),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Builder(builder: (context) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool('loggedIn', false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Logout",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Builder(builder: (context) {
                                          return Icon(Icons.logout_rounded);
                                        }),
                                      ],
                                    ),
                                  );
                                }),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      getstoreName();
                      getaddress();
                      gettype();
                      getbio();
                      gettables();
                      getcustomers();
                      getduration();
                      makereservlist();
                    },
                  ),
                  bottomNavigationBar: BottomBar(
                    selectedIndex: _currentPage,
                    onTap: (int index) {
                      _pageController.jumpToPage(index);
                      setState(() => _currentPage = index);
                    },
                    items: <BottomBarItem>[
                      BottomBarItem(
                        icon: Icon(Icons.chair_rounded),
                        title: Text('Reservations'),
                        activeColor: Colors.red,
                        darkActiveColor: Colors.red.shade400,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.store_rounded),
                        title: Text('My Shop'),
                        activeColor: Colors.greenAccent.shade700,
                        darkActiveColor: Colors.greenAccent.shade400,
                      ),
                      BottomBarItem(
                        icon: Icon(Icons.settings),
                        title: Text('Settings'),
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                )),
    );
  }

  void onModeChanged(bool isDark) {
    _darkSwitch();
    setState(() {
      this.isDark = isDark;
    });
  }

  void onLangChanged(bool isGreek) {
    _greekSwitch();
    setState(() {
      this.isGreek = isGreek;
    });
  }
}
