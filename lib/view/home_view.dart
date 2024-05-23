import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_logup_start_task/view/signin_view.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  String? uName;

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('username');
    log('id:$userId');
    setState(() {
      uName = userId;
    });

    log('id email:$uName');

    if (userId != null) {
      var userDoc = await _firestore.collection('users').doc(userId).get();
      log('users:$userDoc');
      setState(() {
        _username = userDoc.data()?['email'];
      });
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  final _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    try {
      await _auth.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('userId');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during signout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          'Home Screen',
        ),
        backgroundColor: Colors.purple.withOpacity(0.9),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(_username != null ? 'Welcome, $_username' : 'Welcome'),

            Text(uName != null ? 'Welcome, $uName' : 'Welcome Guest'),
            SizedBox(
              height: 40,
            ),
            InkWell(
                onTap: () {
                  _signOut();
                },
                child: Container(child: Text('SignOut')))
          ],
        ),*/
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 15),
        child: Center(
          child: Card(
            color: Colors.purple.withOpacity(0.9),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              // height: MediaQuery.of(context).size.height,
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/education_welcome.json',
                    repeat: true, // Set to false if you don't want it to loop
                    reverse: false,
                    animate: true,
                    height: 200.0,
                    width: 200.0, // Set the desired width for the animation
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                  Text(
                    uName != null ? 'Welcome, $uName' : 'Welcome Guest',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                      onTap: () {
                        _signOut();
                      },
                      child: Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              'SignOut',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
