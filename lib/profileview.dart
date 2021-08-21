import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:google_fonts/google_fonts.dart'; 
import "package:bloo/api_mappings.dart" as wrapper;
import "package:bloo/api.dart" as api;

class ProfileViewerWidget extends StatefulWidget {
    int userId;

    ProfileViewerWidget(this.userId);

    createState() => _ProfileViewerWidgetState();
}

class _ProfileViewerWidgetState extends State<ProfileViewerWidget> {
    final PageController pageController = new PageController();
    Map<String, dynamic>? user;

    @override
    Widget build(BuildContext context) {
        if (user == null) {
            fetchUser();
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [SpinKitWave(
                    color: Color(0xFF00FFFF),
                    size: 25
                )]
            );
        }
        return Container(
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF)
            ),
            child: Column(
                children: [
                    Center(
                        child: Column(
                            children: [
                                SizedBox(
                                    child: Image.network("${api.API_BASE}/cached/avatar/${widget.userId}"),
                                    height: 150,
                                    width: 150
                                ),
                                Text(
                                    "@" + (user?["username"] ?? "ghost"),
                                    style: GoogleFonts.robotoMono(
                                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                                        fontWeight: FontWeight.w500,
                                    )
                                ),
                            ]
                        )
                    )
                ],
            )
        );
    }

    Future<void> fetchUser() async {
        user = await wrapper.getUser(widget.userId);
        setState((){});
    }
}
