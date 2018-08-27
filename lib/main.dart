import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_string/secure_string.dart';

Future main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.indigo),
      title: "OMaharashtra",
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map dt1 = new Map();
  int j, k, i = 1;
  List dt3 = new List(), dt2 = new List(), dt = new List();
  List dist = [
    "Ahmednagar",
    "Akola ",
    "Amravati",
    "Aurangabad",
    "Beed",
    "Bhandara",
    "Buldhana",
    "Chandrapur",
    "Dhule",
    "Gadchiroli",
    "Gondia",
    "Hingoli",
    "Jalgaon",
    "Jalna",
    "Kolhapur",
    "Latur",
    "Mumbai",
    "Mumbai Suburban",
    "Nagpur",
    "Nanded",
    "Nandurbar",
    "Nashik",
    "Osmanabad",
    "Palghar",
    "Parbhani",
    "Pune",
    "Raigad",
    "Ratnagiri",
    "Sangli",
    "Satara",
    "Sindhudurg",
    "Solapur",
    "Thane",
    "Wardha",
    "Washim",
    "Yavatmal"
  ];
  var ldata = new Map(), s, offers = new Map();
  String contents,
      p = '',
      username = "Omaharashtra",
      email = 'www.omaharashtra.com',
      msg,
      district = "Select",
      role = " ",
      f;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  SharedPreferences prefs;
  http.Response response, response2;
  SecureString secureString = new SecureString();

  Future<String> getData() async {
      return 'ok';
  }

  Future<Null> checkconn() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
    } else {
      final snackbar = new SnackBar(
        content: new Text('No internet connection'),
        backgroundColor: Colors.red,
        duration: new Duration(seconds: 5),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkconn();
    imageCache.clear();
  }



  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    new Timer(new Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return new Scaffold(
                key: scaffoldKey,
                appBar: new AppBar(
                    backgroundColor: Colors.indigo,
                    title: new Image(
                      image: new AssetImage("assets/logo.png"),
                    ),
                    actions: <Widget>[
                      new InkWell(
                        child: new Row(children: <Widget>[
                          new Container(
                            width: 90.0,
                            margin: new EdgeInsets.only(top: 8.0),
                            child: new Text(
                              district,
                              textAlign: TextAlign.right,
                              style: new TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          new Icon(Icons.location_on),
                        ]),
                        onTap: () {
                          showModalBottomSheet<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return new Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  child: new Column(
                                    children: <Widget>[
                                      new Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        color: Colors.indigo,
                                        padding: new EdgeInsets.all(15.0),
                                        child: new Row(children: <Widget>[
                                          new Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width -
                                                  120.0,
                                              child: new Text("Select District",
                                                  style: new TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors.white))),
                                          new MaterialButton(
                                            onPressed: () async {
                                              //SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString(
                                                  'dist', "Select");
                                              setState(() {
                                                district = "Select";
                                              });
                                              _onRefresh();
                                              Navigator.of(context).pop();
                                            },
                                            color: Colors.redAccent[200],
                                            height: 32.0,
                                            minWidth: 40.0,
                                            child: new Text("RESET",
                                                style: new TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white)),
                                          )
                                        ]),
                                      ),
                                      new Expanded(child: distlist())
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                    bottom: new PreferredSize(
                        preferredSize: new Size.fromHeight(52.0),
                        child: new InkWell(
                            child: new Container(
                              height: 43.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                              ),
                              margin: new EdgeInsets.only(
                                  bottom: 10.0, left: 10.0, right: 10.0),
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    margin: new EdgeInsets.only(left: 20.0),
                                    width: MediaQuery.of(context).size.width -
                                        80.0,
                                    child: new Text("Search...",
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey[400])),
                                  ),
                                  new Container(
                                    height: 43.0,
                                    child: new Icon(
                                      Icons.search,
                                      color: Colors.grey[400],
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {}))),
                backgroundColor: Colors.white,
                body: new RefreshIndicator(
                  key: _refreshIndicatorKey,
                  child: new ListView(
                    shrinkWrap: false,
                    reverse: false,
                    children: <Widget>[
                      new Container(
                        padding:
                        new EdgeInsets.only(left: 20.0, right: 20.0),
                        height: MediaQuery.of(context).size.height / 3.0,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                                image: new AssetImage(
                                    "assets/banner/sliderback2.jpg"),
                                fit: BoxFit.fill)),
                      ),
                      new Container(
                        height: 130.0,
                        color: Colors.blueGrey[100],
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          padding:
                          const EdgeInsets.only(bottom: 3.0, top: 12.0),
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Container(
                                  width: 80.0,
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                      radius: 30.0),
                                ),
                                new Container(
                                  width: 80.0,
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                      radius: 30.0),
                                ),
                                new Container(
                                  width: 80.0,
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                      radius: 30.0),
                                ),
                                new Container(
                                  width: 80.0,
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                      radius: 30.0),
                                ),
                                new Container(
                                  width: 80.0,
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                      radius: 30.0),
                                ),
                                new Container(
                                  width: 80.0,
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                      radius: 30.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      new Container(
                        height: 230.0,
                        color: Colors.white70,
                        padding: const EdgeInsets.all(10.0),
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(children: <Widget>[
                                new Text("Offers",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22.0)),
                              ]),
                              new Container(
                                  height: 160.0,
                                  padding: new EdgeInsets.only(top: 10.0),
                                  child: new ListView(
                                    scrollDirection: Axis.horizontal,
                                    itemExtent: 120.0,
                                    children: <Widget>[
                                      new Padding(
                                          padding:
                                          new EdgeInsets.only(right: 8.0),
                                          child: new Card(
                                            color: Colors.white,
                                            elevation: 2.0,
                                            child: new Column(
                                              children: <Widget>[
                                                new Container(
                                                    width: 120.0,
                                                    child: new Text(""),
                                                    height: 90.0),
                                                new Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8.0,
                                                        left: 3.0,
                                                        right: 3.0,
                                                        bottom: 5.0),
                                                    child: new Text("")),
                                              ],
                                            ),
                                          )),
                                      new Padding(
                                          padding:
                                          new EdgeInsets.only(right: 8.0),
                                          child: new Card(
                                            color: Colors.white,
                                            elevation: 2.0,
                                            child: new Column(
                                              children: <Widget>[
                                                new Container(
                                                    width: 120.0,
                                                    child: new Text(""),
                                                    height: 90.0),
                                                new Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8.0,
                                                        left: 3.0,
                                                        right: 3.0,
                                                        bottom: 5.0),
                                                    child: new Text("")),
                                              ],
                                            ),
                                          )),
                                      new Padding(
                                          padding:
                                          new EdgeInsets.only(right: 8.0),
                                          child: new Card(
                                            color: Colors.white,
                                            elevation: 2.0,
                                            child: new Column(
                                              children: <Widget>[
                                                new Container(
                                                    width: 120.0,
                                                    child: new Text(""),
                                                    height: 90.0),
                                                new Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8.0,
                                                        left: 3.0,
                                                        right: 3.0,
                                                        bottom: 5.0),
                                                    child: new Text("")),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ))
                            ]),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(
                            top: 10.0,
                            left: 5.0,
                            right: 5.0,
                            bottom: 5.0),
                        decoration: new BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(5.0))),
                        child: new Column(children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          new Center(
                            child: new Text(
                                "Do you have any requirement?",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 21.0)),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(20.0),
                            child: new MaterialButton(
                              height: 40.0,
                              minWidth: 80.0,
                              color: Colors.black,
                              child: new Text("Add Here",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                              onPressed: () => null,
                            ),
                          ),
                        ]),
                      ),
                      new Container(
                        height: 380.0,
                        margin: new EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(
                            color: Colors.indigo[200],
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(5.0))),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              height: 150.0,
                              margin: new EdgeInsets.all(30.0),
                              child: new Image.asset(
                                  "assets/banner/jb2.png"),
                            ),
                            new Container(
                              color: Colors.white,
                              margin: new EdgeInsets.all(10.0),
                              padding: new EdgeInsets.all(10.0),
                              child: new Column(children: <Widget>[
                                new Center(
                                  child: new Text("Need A Job?",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22.0)),
                                ),
                                new Padding(
                                    padding: new EdgeInsets.all(3.0)),
                                new Center(
                                  child: new Text(
                                    "To search job openings for you",
                                    style: new TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                new Padding(
                                    padding: new EdgeInsets.all(3.0)),
                                new InkWell(
                                    onTap: () {},
                                    child: new Container(
                                      padding: new EdgeInsets.only(
                                          top: 2.0,
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 2.0),
                                      decoration: new BoxDecoration(
                                          border: new Border.all(
                                              color: Colors.blue[700])),
                                      child: new Text("click here",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[700],
                                              fontSize: 18.0)),
                                    ))
                              ]),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        height: 380.0,
                        margin: new EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(
                            color: Colors.blueGrey[200],
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(5.0))),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              height: 150.0,
                              margin: new EdgeInsets.all(30.0),
                              child: new Image.asset(
                                "assets/banner/requirement.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            new Container(
                              color: Colors.white,
                              margin: new EdgeInsets.all(10.0),
                              padding: new EdgeInsets.all(10.0),
                              child: new Column(children: <Widget>[
                                new Center(
                                  child: new Text(
                                      "Search your requirements",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24.0)),
                                ),
                                new Padding(
                                    padding: new EdgeInsets.all(3.0)),
                                new Center(
                                  child: new Text(
                                    "To search your requirements",
                                    style: new TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                new Padding(
                                    padding: new EdgeInsets.all(3.0)),
                                new InkWell(
                                    onTap: () => showreq(),
                                    child: new Container(
                                      padding: new EdgeInsets.only(
                                          top: 2.0,
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 2.0),
                                      decoration: new BoxDecoration(
                                          border: new Border.all(
                                              color: Colors.blue[700])),
                                      child: new Text("click here",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[700],
                                              fontSize: 18.0)),
                                    ))
                              ]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  onRefresh: _onRefresh,
                ),
                drawer: new Drawer(
                    child: new Column(
                      children: <Widget>[
                        new UserAccountsDrawerHeader(
                          accountName: new GestureDetector(
                              child: new Text(username,
                                  style: new TextStyle(fontSize: 16.0))),
                          accountEmail: new GestureDetector(
                            child: new Text(
                              email,
                              style: new TextStyle(fontSize: 15.0),
                            ),
                          ),
                          currentAccountPicture: new CircleAvatar(
                            backgroundImage: new AssetImage("assets/fav.png"),
                            backgroundColor: Colors.grey[800],
                          ),
                          decoration: new BoxDecoration(
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(
                                      "assets/banner/sliderback.jpg"))),
                        ),
                        new Expanded(
                            child: new ListView(
                              padding: EdgeInsets.only(top: 0.0),
                              children: <Widget>[
                                new Container(
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            bottom: new BorderSide(
                                                color: Colors.grey[400], width: 0.5))),
                                    child: new ListTile(
                                      leading: new Icon(Icons.account_circle,
                                          color: Colors.pinkAccent[200]),
                                      title: new Text(
                                        p != null ? "Profile" : "Login ",
                                        style: new TextStyle(
                                            fontSize: 15.0, color: Colors.indigo[600]),
                                      ),
                                      onTap: () => check(),
                                    )),
                                new Container(
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            bottom: new BorderSide(
                                                color: Colors.grey[400], width: 0.5))),
                                    child: new ListTile(
                                      leading: new Icon(Icons.share,
                                          color: Colors.blueAccent[200]),
                                      title: new Text(
                                        "Share",
                                        style: new TextStyle(
                                            fontSize: 15.0, color: Colors.indigo[600]),
                                      ),
                                      onTap: () => null,
                                    )),
                                new ListTile(
                                  title: new Text(
                                    "Privacy Policy",
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.indigo[600]),
                                  ),
                                  onTap: () {},
                                ),
                                new ListTile(
                                  title: new Text(
                                    "Terms & Conditions",
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.indigo[600]),
                                  ),
                                  onTap: () {},
                                ),
                                new ListTile(
                                  title: new Text(
                                    "About Us",
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.indigo[600]),
                                  ),
                                  onTap: () {},
                                ),
                                new ListTile(
                                  title: new Text(
                                    "Pricing",
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.indigo[600]),
                                  ),
                                  onTap: () {},
                                ),
                                new ListTile(
                                  title: new Text(
                                    "Contact Us",
                                    style: new TextStyle(
                                        fontSize: 15.0, color: Colors.indigo[600]),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            )),
                      ],
                    )));
          } else {
            return new Scaffold(
              key: scaffoldKey,
              appBar: new AppBar(
                  title: new Image(
                    image: new AssetImage("assets/logo.png"),
                    width: 150.0,
                  )),
              body: snapshot.connectionState.toString() ==
                  "ConnectionState.done"
                  ? new Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: new EdgeInsets.only(top: 110.0),
                  child: new Column(
                    children: <Widget>[
                      new Icon(Icons.error_outline,
                          size: 80.0, color: Colors.grey[400]),
                      new Text("OOPS! something went wrong",
                          style: new TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 21.0,
                              color: Colors.grey[400])),
                      new Text("To Refresh Tap Here",
                          style: new TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: Colors.grey[400])),
                      new Padding(padding: EdgeInsets.all(10.0)),
                      new MaterialButton(
                        height: 30.0,
                        minWidth: 25.0,
                        color: Colors.deepOrangeAccent,
                        elevation: 1.0,
                        splashColor: Colors.blueAccent,
                        textColor: Colors.white,
                        child: new Text("Refresh",
                            style: new TextStyle(fontSize: 14.0)),
                        onPressed: () => setState(() {}),
                      ),
                    ],
                  ))
                  : new ListView(
                shrinkWrap: false,
                reverse: false,
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.only(left: 20.0, right: 20.0),
                    height: MediaQuery.of(context).size.height / 3.0,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage(
                                "assets/banner/sliderback2.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  new Container(
                    height: 130.0,
                    color: Colors.blueGrey[100],
                    child: new ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                      const EdgeInsets.only(bottom: 3.0, top: 12.0),
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Container(
                              width: 80.0,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                  radius: 30.0),
                            ),
                            new Container(
                              width: 80.0,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                  radius: 30.0),
                            ),
                            new Container(
                              width: 80.0,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                  radius: 30.0),
                            ),
                            new Container(
                              width: 80.0,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                  radius: 30.0),
                            ),
                            new Container(
                              width: 80.0,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                  radius: 30.0),
                            ),
                            new Container(
                              width: 80.0,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Icon(Icons.rotate_left,color: Colors.grey[400],),
                                  radius: 30.0),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  new Container(
                    height: 230.0,
                    color: Colors.white70,
                    padding: const EdgeInsets.all(10.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(children: <Widget>[
                            new Text("Offers",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22.0)),
                          ]),
                          new Container(
                              height: 160.0,
                              padding: new EdgeInsets.only(top: 10.0),
                              child: new ListView(
                                scrollDirection: Axis.horizontal,
                                itemExtent: 120.0,
                                children: <Widget>[
                                  new Padding(
                                      padding:
                                      new EdgeInsets.only(right: 8.0),
                                      child: new Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: new Column(
                                          children: <Widget>[
                                            new Container(
                                                width: 120.0,
                                                child: new Text(""),
                                                height: 90.0),
                                            new Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 3.0,
                                                    right: 3.0,
                                                    bottom: 5.0),
                                                child: new Text("")),
                                          ],
                                        ),
                                      )),
                                  new Padding(
                                      padding:
                                      new EdgeInsets.only(right: 8.0),
                                      child: new Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: new Column(
                                          children: <Widget>[
                                            new Container(
                                                width: 120.0,
                                                child: new Text(""),
                                                height: 90.0),
                                            new Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 3.0,
                                                    right: 3.0,
                                                    bottom: 5.0),
                                                child: new Text("")),
                                          ],
                                        ),
                                      )),
                                  new Padding(
                                      padding:
                                      new EdgeInsets.only(right: 8.0),
                                      child: new Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        child: new Column(
                                          children: <Widget>[
                                            new Container(
                                                width: 120.0,
                                                child: new Text(""),
                                                height: 90.0),
                                            new Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 3.0,
                                                    right: 3.0,
                                                    bottom: 5.0),
                                                child: new Text("")),
                                          ],
                                        ),
                                      )),
                                ],
                              ))
                        ]),
                  ),
                  new Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white30,
                    child: new Text(
                      "   Loading...",
                      style: new TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.blueAccent[400]),
                      textAlign: TextAlign.center,
                    ), // new Text("Please wait",style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color:
                  ),
                ],
              ),
            );
          }
        });
  }

  check() {}
  showdata(ownn) async {}
  getvalues(id) {}
  distlist() {
    return new ListView.builder(
      itemCount: dist.length,
      itemBuilder: (context, index) {
        return new Card(
            color: Colors.white,
            elevation: 0.5,
            child: new ListTile(
              title: new Text(
                dist[index],
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.indigoAccent),
              ),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ));
      },
    );
  }
  showreq() {}
  showprov(catname) {}
}
