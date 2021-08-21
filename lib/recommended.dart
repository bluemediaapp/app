import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:bloo/api_mappings.dart" as wrapper;
import "package:bloo/videos/video.dart";

class RecommendedPage extends StatefulWidget {
    createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
    List<Map<String, dynamic>> recommendedVideos = [];
    int refreshSize = 2;
    bool enableScroll = true;
    final PageController pageController = new PageController();
    int lastPage = 0;

    @override
    Widget build(BuildContext context) {
        if (recommendedVideos.length == 0) {
            getRecommended(true);
            return Center(
                child: SpinKitWave(
                    color: Color(0xFF00FFFF),
                    size: 25
                )
            );
        }
        if (this.enableScroll) {
            return PageView.builder(
                controller: pageController,
                scrollDirection: Axis.vertical,
                itemBuilder: this.buildPage
            );
        } else {
            try {
                lastPage = pageController.page?.floor() ?? 0;
            } catch (e) {}
            return this.buildPage(context, lastPage);
        }
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
        return VideoWidget(this.recommendedVideos[index]);
    }
    
    void dispose() {
        pageController.dispose();
        super.dispose();
    }
}
