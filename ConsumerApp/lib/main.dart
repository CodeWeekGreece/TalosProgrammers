import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';




import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'tYL0IJzIeBBuDDI16gusYnRsFjH2oyeHYuMfk1xE';
  final keyClientKey = 'x6iYGjmL71gaz5XzCT4HFE7zQVInEFBhKIuYrUoC';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,

      clientKey: keyClientKey, debug: true);
  
  
  runApp(MaterialApp(home: MainScreen()));
}

class MainScreen extends StatefulWidget {
  State createState() => MainScreenState();
}

class AppointmentsScreen extends StatefulWidget {
  State createState() => AppointmentsScreenState();
}

class SettingsScreen extends StatefulWidget {
  State createState() => SettingsScreenState();
}
class MakeAppointmentScreen extends StatefulWidget{
  State createState() => MakeAppointmentScreenState();
}

class MainScreenState extends State {
  var showProfile = false;
  var longitude;
  var latitude;
  bool locationCollected = false;

  void getCurrentLocation() async {
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      longitude = location.longitude;
      latitude = location.latitude;
      locationCollected = true;
    });
  }

  Timer? timer;

  void initState() {
    super.initState();
    appTheme.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    getCurrentLocation();
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => getCurrentLocation());
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  GoogleMapController? mapController;

  void UpdateMapLocation() {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 18),
      ),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightTheme,
        darkTheme: ThemeData.dark().copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(primary: Colors.black))),
        themeMode: appTheme.currentTheme(),
        home: Scaffold(
          appBar: AppBar(
            title: Text("bookIN",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  color: Colors.white,
                )),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  setState(() {});
                },
              )
            ],
          ),
          body: Stack(children: [
            if (locationCollected == true)
              GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude), zoom: 18))
            else
              Center(
                  child:
                      CircularProgressIndicator(color: lightTheme.accentColor)),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 65)),
                ElevatedButton.icon(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MakeAppointmentScreen()));
                      
                  },
                  icon: Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  label: Text("Make a reservation"),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                  
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  onPressed: () {
                    UpdateMapLocation();
                  },
                  child: Text("Nearby places"),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 35)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
                Padding(padding: EdgeInsets.only(top: 35)),
              ],
            ))
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentsScreen()));
            },
            child: Icon(Icons.event_note),
          ),
        ));
  }
}

class AppointmentsScreenState extends State {
  void initState() {
    super.initState();
    appTheme.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    List appointments = [
      ["Shop", "9:00 - 10:30", Icons.shop],
      ["Restaurant", "13:00 - 15:00", Icons.restaurant],
    ];
    return MaterialApp(
        theme: lightTheme,
        darkTheme: ThemeData.dark(),
        themeMode: appTheme.currentTheme(),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Appointments"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {},
              )
            ],
          ),
          body: Scrollbar(
              child: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(appointments[index][2]),
                  title: Text(appointments[index][0]),
                  subtitle: Text(appointments[index][1]),
                  trailing: IconButton(
                    color: Colors.redAccent,
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  ),
                ),
                elevation: 12,
              );
            },
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ));
  }
}

class SettingsScreenState extends State {
  void ChangeTheme(value) {
    appTheme.switchTheme();
  }

  void initState() {
    super.initState();
    appTheme.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String Language = "English";

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: appTheme.currentTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(child: Text("")),
            Row(
              children: [
                Expanded(child: Text("")),
                Text(
                  "Light",
                  style: TextStyle(fontSize: 22),
                ),
                Switch(
                    value: appTheme.getTheme(),
                    onChanged: (bool value) {
                      ChangeTheme(value);
                    }),
                Text(
                  "Dark",
                  style: TextStyle(fontSize: 22),
                ),
                Expanded(child: Text(""))
              ],
            ),
            DropdownButton(
              items: ['English', 'Greek'].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  Language = value.toString();
                });
              },
              hint: Text(
                Language,
                style: TextStyle(fontSize: 22),
              ),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "Log out",
                  style: TextStyle(fontSize: 22),
                )),
            Expanded(child: Text(""))
          ],
        ),
      ),
    );
  }
}
class MakeAppointmentScreenState extends State{
  var showProfile = false;
  var longitude;
  var latitude;
  bool locationCollected = false;
  bool first_step = false, second_step= false, third_step= false, initial_step= true, first_step2=false, fourth_step=false, fifth_step=false;
  final first_field1= TextEditingController(), initial_field = TextEditingController();
  var rand_date;
  var shop, people_numb, ora;
  List timeofreserv= ['8:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00'];
  var counter;

  void getCurrentLocation() async {
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      longitude = location.longitude;
      latitude = location.latitude;
      locationCollected = true;
      

    });
  }

  Timer? timer;

  void initState() {
    super.initState();
    appTheme.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    getCurrentLocation();
    
        
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  

  
  
  List<String> store_type = ['restaurant', 'cafe', 'consumer store'];
  

  List<ParseObject> results = <ParseObject>[];
  void doQueryByLocation() async {
  final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('location2'));

    // Create our GeoPoint for the query
    final dallasGeoPoint =
        ParseGeoPoint(latitude: latitude, longitude: longitude);

    // You can also use `withinMiles` and `withinRadians` the same way,
    // but with different measuring unities
    parseQuery.whereWithinKilometers('location', dallasGeoPoint, 5);
    //parseQuery.whereWithinMiles('location', dallasGeoPoint, 3000);

    // The query will resolve only after calling this method, retrieving
    // an array of `ParseObjects`, if success
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // Let's show the results
      for (var o in apiResponse.results! as List<ParseObject>) {
        print(
            'location2: ${o.get<String>('type')} - Location: ${o.get<ParseGeoPoint>('location')!.latitude}, ${o.get<ParseGeoPoint>('location')!.longitude}');
      }
    

      setState(() {
        results = apiResponse.results as List<ParseObject>;
        
        
        for (var o in apiResponse.results! as List<ParseObject>){
          
          if (o.get<bool>('availability')== false){
            results.remove(o.get<String>('name'));
            print (o.get<String>('name'));
            
            
          }
        }
      });
    } else {
      results = [];
    }
  }
  
  List<ParseObject> results2 = <ParseObject>[];
  void doQueryBySearch() async {
    // Create your query
    
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Stores'));
    
    // `whereContains` is a basic query method that checks if string field
    // contains a specific substring
    parseQuery.whereContains('storeName', initial_field.text.toString());

    // The query will resolve only after calling this method, retrieving
    // an array of `ParseObjects`, if success
    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // Let's show the results
      for (var o in apiResponse.results!) {
        final object = o as ParseObject;
        print('${object.get<String>('name')}');
      }

      setState(() {
        results2 = apiResponse.results as List<ParseObject>;
      });
    } else {
      results2 = [];
    }
  }
 
  
   
 
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: appTheme.currentTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Make an Appointment"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
  crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
           
            Visibility( 
            child: Padding( padding: EdgeInsets.all(16.0),
            child: Text("Choose number of people", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
            
            visible: first_step, 
                ),
            
            
            Visibility(child: Padding( child:
            TextField( keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter number of people',
              ),
              
              controller: first_field1, ), padding: EdgeInsets.all(16.0)
              
                
            
        ), visible : fifth_step),
        
        Visibility(child: Padding( child:
            TextField( 
              
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of ${store_type[0]}',
              ),
  
              
              controller: initial_field, ), padding: EdgeInsets.all(16.0)
              
                
            
        ), visible : initial_step), 

        
           
            Visibility(child: Padding( padding: EdgeInsets.all(16.0),
            child: 
            ElevatedButton(
            child: Text('DONE', style: TextStyle(fontSize: 25)),
            onPressed:(){
            
            doQueryBySearch();
            
            },
            )), visible: initial_step 
            
            ),
            Visibility(child: Padding( padding: EdgeInsets.all(16.0),
            child: 
            ElevatedButton(
            child: Text('DONE', style: TextStyle(fontSize: 25)),
            onPressed:(){
            people_numb= first_field1.text;
              
            
            },
            )), visible: third_step 
            
            ),
            
    Visibility( child: Padding( padding: EdgeInsets.all(16.0),
    child:
             Text(
              'Shop that you chose: $shop', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
            )),visible: second_step,
            ),

    Visibility( child: Padding( padding: EdgeInsets.all(16.0),
    child:
             Text(
              'Date that you chose: $shop', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
            )),visible: false,
            ),

             Visibility( child: Container(
              child: ElevatedButton(
                  onPressed: doQueryByLocation,
                  child: Text('location'),
                  style: ElevatedButton.styleFrom(primary: Colors.blue)),
                  
            ), visible: false
            ),
            
            Visibility( child:
            Expanded( 
              child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) 
                  
                  { if(results[index].get<bool>('availability')==true){
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      
                      child: Text(
                       
                        results[index].get<String>('name').toString(),
                    ));};
                    return Container();
                  }),
            ),visible: third_step
            ),
            Visibility( child:
            Expanded( 
              child: ListView.builder(
                  itemCount: results2.length,
                  itemBuilder: (context, index) 
                  
                  { 
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      
                      child: ElevatedButton(
                        child:
                        Text(results2[index].get<String>('name').toString()),
                        onPressed:(){
                          setState(() {
                      second_step=true;
                      initial_step = false;
                      shop = results2[index].get<String>('name').toString();
                      counter=index;
                      
                    });
                          

                        }
                    ));
                    
                  }),
            ),visible: initial_step
            ),
            
            Visibility(child: Text( 'Your prefered date: ${rand_date.toString().split(' ')[0]} and time $ora', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
            ),

    visible: fourth_step

    ),
            
            Visibility( child: Padding(padding: EdgeInsets.all(16.0),
            child:
            ElevatedButton(
    onPressed: () {
        DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2021, 3, 5),
                              maxTime: DateTime(2022, 6, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            rand_date = date;
                            setState(() {third_step=true;});
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                          
    },
    
    child: 
        Text('Press to pick a preferred date', textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 30 ),
        
    )
            )), visible: second_step
    
    ),
    
    Visibility(child: Expanded( child: ListView.builder(
                  itemCount: 9,
                  itemBuilder: (context, index) {return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                          
             child: ElevatedButton(
             child: Text(timeofreserv[index].toString()), 
             onPressed:(){ 
                setState(() {
               ora = timeofreserv[index].toString();
               fourth_step=true;
               
               if (results2[counter].get<String>('reservations').toString().allMatches(ora).length<int.parse(results2[counter].get<String>('customers').toString())){
                 fifth_step=true;

               }
               });
             }      
    )); }), ),visible: third_step),
    
            
          ],
        ),
      ),
    );
  }
  
}


