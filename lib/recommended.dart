import "package:flutter/material.dart";
import "package:bloo/api_mappings.dart" as wrapper;
import "package:bloo/videoplayer.dart";

class RecommendedPage extends StatefulWidget {
    createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
    List<Map<String, dynamic>> recommendedVideos = [];
    int refreshSize = 2;
    final PageController pageController = new PageController();

    @override
    Widget build(BuildContext context) {
        if (recommendedVideos.length == 0) {
            getRecommended(true);
            return Container();
        }
        return PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: this.buildPage
        );
    }

    Future<void> getRecommended(bool fresh) async {
        // The first time it loads we have to refresh.
        Iterable<int> ignore = recommendedVideos.map((video) => video["id"]);
        var res = await wrapper.get_recommended(ignore);
        res.forEach((video) {
            recommendedVideos.add(video);
        });

        if (fresh) {
            setState(() {});
        }
    }
    Widget buildPage(BuildContext context, int index) {
        int remainingVideos = recommendedVideos.length - index;
        if (remainingVideos <= refreshSize) {
            getRecommended(false);
        }
        return VideoPlayerWidget(this.recommendedVideos[index]);
    }

    void dispose() {
        pageController.dispose();
        super.dispose();
    }
}
