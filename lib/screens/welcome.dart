import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subidha/app.dart';
import 'package:subidha/screens/about.dart';
import 'package:subidha/screens/payment.dart';
import 'package:subidha/screens/profile.dart';
import 'package:subidha/screens/ride_history.dart';
import 'package:subidha/screens/terms_and_condition.dart';

import 'contactsupport.dart';
import 'map.dart';

class WelcomePage extends StatefulWidget {
  static const String idScreen = "welcome";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    return new Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: new Text('Profile'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new ProfilePage()));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: new Text('My Bookings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new PaymentPage()));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: new Text('View ride history'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new RideHistoryPage()));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.contact_support),
              title: new Text('Contact Support'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ContactsupportPage()));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.branding_watermark_sharp),
              title: new Text('Terms and condition'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new TermsandconditionPage()));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: new Text('About Page'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new AboutPage()));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: new Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => App())));
              },
            ),
            new Divider(
              color: Colors.white,
              height: 5.0,
            ),
          ]),
        ),
      ),
      body: Stack(
        children: [
          Maps(),
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5.0,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
