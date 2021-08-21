import "package:flutter/material.dart";
import "package:bloo/api_mappings.dart" as wrapper;
import "package:bloo/videos/videoplayer.dart";
import "package:bloo/videos/comments.dart";
import "package:bloo/profileview.dart";
class VideoWidget extends StatefulWidget {
    Map<String, dynamic> videoData;

    VideoWidget(this.videoData);

    createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
    final PageController pageController = new PageController();

    @override
    Widget build(BuildContext context) {
        return PageView(
            controller: pageController,
            children: [
                VideoPlayerPanel(widget.videoData),
                CommentsPanel(),
                ProfileViewerWidget(widget.videoData["creator_id"]),
            ],
        );
    }
}
