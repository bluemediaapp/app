import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/foundation.dart" as foundation;
import "package:bloo/api.dart" as api;
import "package:bloo/login.dart";
import "package:bloo/recommended.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
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
    // Login
    bool checkedLogin = false;
    bool loggedIn = false;

    Widget active = RecommendedPage();

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
            widget = LoginPage(this.onLoggedIn);
        } else {
            // Logged in!
            widget = active;
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
