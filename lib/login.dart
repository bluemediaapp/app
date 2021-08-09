import "package:flutter/material.dart";
import 'dart:math';
import "package:bloo/api.dart" as api;
import "package:shared_preferences/shared_preferences.dart";


class LoginPage extends StatefulWidget {
    VoidCallback loginCallback;

    LoginPage(this.loginCallback);

    @override
    _LoginState createState() {
        return _LoginState();
    }
}

class _LoginState extends State<LoginPage> {
    String error = "";
    bool allowedBadPassword = false;

    // Controllers
    final usernameController = new TextEditingController();
    final passwordController = new TextEditingController();

    // Random icon
    int randomIcon = 0;

    void new_icon() {
        var newIcon = Random().nextInt(5) + 1;
        if (newIcon == randomIcon) {
            new_icon();
        } else {
            randomIcon = newIcon;
        }
        
    }

    @override
    Widget build(BuildContext context) {
        if (randomIcon == 0) {
            new_icon();
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
                // Random icon
                Padding(
                    padding: EdgeInsets.only(left: 64, right: 64, bottom: 16),
                    child: GestureDetector(
                        onTap: () {
                            setState(() {
                                new_icon();
                            });
                        },
                        child: Image.network(api.API_BASE + "/cached/avatar/${randomIcon}")
                    )
                ),
                // Error text
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Text(
                            error,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red
                            )
                        )
                    ),
                ),
                // Username and password
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: TextField(
                        controller: usernameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Username",
                        )
                    ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: TextField(
                        controller: passwordController,
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Password",
                        )
                    ),
                ),
                // Login and signup buttons
                InkWell(
                    onTap: login,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text("Login")
                    )
                ),
                InkWell(
                    onTap: register,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text("Register")
                    )
                )


            ]
        );
    }

    void login() {
        print("Logging in...");
        var username = usernameController.text;
        var password = passwordController.text;

        api.rawRequest("GET", "/live/login", headers: {"username": username, "password": password}).then((res) {
            saveToken(res.body);
            widget.loginCallback();
        }).catchError((err) {
            setState(() {
                error = err;
            });
        });
    }
    void saveToken(String token) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        print("Saved token!");
    }
    void register() {
        var username = usernameController.text;
        var password = passwordController.text;

        if (isBadPassword(password) && !allowedBadPassword) {
            setState(() {
                allowedBadPassword = true;
                error = "Password might be insecure. Press register again if you really want to do this.";
            });
            return;
        }
        print("Creating account!");
        // TODO: Change to POST
        api.rawRequest("GET", "/live/register", headers: {"username": username, "password": password}).then((res) {
            saveToken(res.body);
            widget.loginCallback();
        }).catchError((err) {
            setState(() {
                error = err;
            });
        });
    }

    bool isBadPassword(String password) {
        if (password.length < 13) return true;
        return false;
    }

    @override
    void dispose() {
        // Clean up the controller when the widget is removed from the
        // widget tree.
        usernameController.dispose();
        passwordController.dispose();
        super.dispose();
    }
}
