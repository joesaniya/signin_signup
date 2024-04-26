import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_logup_start_task/view/signin_view.dart';
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

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('username');
    log('id:$userId');

    if (userId != null) {
      var userDoc = await _firestore.collection('users').doc(userId).get();
      log('users:$userDoc');
      setState(() {
        _username = userDoc.data()?['email'];
      });
    } /*else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }*/
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
      appBar: AppBar(title: Text('Home Screen')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_username != null ? 'Welcome, $_username' : 'Welcome'),
            SizedBox(
              height: 40,
            ),
            InkWell(
                onTap: () {
                  _signOut();
                },
                child: Container(child: Text('SignOut')))
          ],
        ),
      ),
    );
  }
}
