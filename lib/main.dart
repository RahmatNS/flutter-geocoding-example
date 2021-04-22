import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position currPosition;
  List<Placemark> placeMarks = [];


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(currPosition == null ? "No location" : "${currPosition.longitude}" +","+ "${currPosition.latitude}",),
            Expanded(
              child: ListView.builder(
                itemCount: placeMarks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Text("Name"),
                            trailing: Text(placeMarks[index].name),
                          ),
                          ListTile(
                            leading: Text("Administrative Area"),
                            trailing: Text(placeMarks[index].administrativeArea),
                          ),
                          ListTile(
                            leading: Text("Sub Administratif Area"),
                            trailing: Text(placeMarks[index].subAdministrativeArea),
                          ),
                          ListTile(
                            leading: Text("Sub Locality"),
                            trailing: Text(placeMarks[index].subLocality),
                          ),
                          ListTile(
                            leading: Text("Street"),
                            trailing: Text(placeMarks[index].street),
                          ),
                        ],
                      ));
                },
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          currPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          placeMarks = await GeocodingPlatform.instance.placemarkFromCoordinates(
              currPosition.latitude, currPosition.longitude);
          setState(() {});

        },
        tooltip: 'Update',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

enum _PositionItemType {
  permission,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
