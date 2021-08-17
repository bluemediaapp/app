import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/foundation.dart" as foundation;
import "package:bloo/api_mappings.dart" as wrapper;
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
            return Scaffold(
                body: Container(),
                backgroundColor: Color(0x000)
            );
        } else if (!loggedIn) {
            // Token was not present or expired
            return Scaffold(
                body: LoginPage(this.onLoggedIn)
            );
        } else if (active != null) {
            // Logged in!
            return Scaffold(
                body: active,
                backgroundColor: Color(0x000),
            );
        } else {
            return Scaffold(
                body: Text("No page to render..?")
            );
        }
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
        try {
            await wrapper.get_current_user();

            // Success
            setState(() {
                checkedLogin = true;
                loggedIn = true;
            });
        } catch (e) {
            // Not logged in
            setState(() {
                checkedLogin = true;
                loggedIn = false;
            });
        }
    }

}
