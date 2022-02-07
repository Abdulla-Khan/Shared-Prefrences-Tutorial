import 'package:flutter/material.dart';
import 'package:localiztion/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logged extends StatefulWidget {
  const Logged({Key? key}) : super(key: key);

  @override
  _LoggedState createState() => _LoggedState();
}

class _LoggedState extends State<Logged> {
  String token = '';
  void initState() {
    get();
    super.initState();
  }

  void get() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 250, left: 39),
        child: Column(
          children: [
            Text(
              'Logged In ${token}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false);
                },
                icon: Icon(Icons.logout_rounded),
                label: Text('Log Out'))
          ],
        ),
      ),
    );
  }
}
