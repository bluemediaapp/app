import "package:flutter/material.dart";
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
        return Container(
            decoration: BoxDecoration(
                color: Color(0xFFCCCCCC)
            ),
            child: Column(
                children: [
                    Positioned(
                        child: SizedBox(
                            child: Image.network("${api.API_BASE}/cached/avatar/${widget.userId}"),
                            height: 250,
                            width: 250
                        ),
                        top: 5,
                        left: 50

                    )
                ],
            )
        );
    }

    Future<void> fetch_user() async {
        user = await wrapper.getUser(widget.userId);
    }
}
