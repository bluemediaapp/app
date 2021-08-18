import "package:flutter/material.dart";
import "package:bloo/api_mappings.dart" as wrapper;

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
            )
        );
    }

    Future<void> fetch_user() async {
        user = await wrapper.getUser(widget.userId);
    }
}
