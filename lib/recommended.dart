import "package:flutter/material.dart";
import "package:bloo/api.dart" as api;
import "package:bloo/videoplayer.dart";

class RecommendedPage extends StatefulWidget {
    createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
    List<Map<String, dynamic>> recommendedVideos = [];
    int refreshSize = 0;

    @override
    Widget build(BuildContext context) {
        if (recommendedVideos.length == 0) {
            getRecommended(true);
            return Container();
        }
        return VideoPlayerWidget(recommendedVideos[0]);
    }

    Future<void> getRecommended(bool fresh) async {
        // The first time it loads we have to refresh.
        var ignore = recommendedVideos.map((video) => video["id"]).join(",");
        var res = await api.request("GET", "/live/recommended?ignore=${ignore}");
        res.forEach((video) {
            recommendedVideos.add(video);
        });

        if (fresh) {
            setState(() {});
        }
    }
}
