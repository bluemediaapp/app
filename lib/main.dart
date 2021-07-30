import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloo/api.dart' as api;
import 'package:bloo/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: SelectorPage(),
            //home: Scaffold(body: LoginPage()),
        );
    }
}

class SelectorPage extends StatefulWidget {
    @override
    _SelectorPageState createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
    bool checkedLogin = false;
    bool loggedIn = false;


    @override
    Widget build(BuildContext context) {
        Widget widget;
        
        // Stop stupid bar at the top
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
        ));

        if (!checkedLogin) {
            // Login check has to be async
            checkLoginStatus();
            widget = SafeArea(child: Text("Verifying login..."));
        } else if (!loggedIn) {
            // Token was not present or expired
            widget = LoginPage();
        } else {
            // No widget was selected
            widget = SafeArea(child: Text("I can't figure what to display..."));
        }

        return Scaffold(
            body: widget,
            appBar: null,
        );
    }
    
    void onLoggedIn() {
        setState(() {
            checkedLogin = true;
            loggedIn = true;
        });
    }
    Future<void> checkLoginStatus() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString("token") ?? "";
        if (token == "") {
            setState(() {
                checkedLogin = true;
                loggedIn = false;
                print("No token saved.");
            });
            return;
        }
        // Check if the token has expired by doing a request. TODO: Possibly check by the time included in the JWT token?
        // The gateway verifies the API token when doing a request
        var res = await api.rawRequest("GET", "/live/loginCheck", ignoreStatus: true);
        // TODO: Change status code to 403
        print(res.statusCode);
        if (res.statusCode == 500) {
            setState(() {
                checkedLogin = true;
                loggedIn = false;
            });
            return;
        }
        setState(() {
            checkedLogin = true;
            loggedIn = true;
        });
        
    }

}
