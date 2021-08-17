import "package:video_player/video_player.dart";
import "package:flutter/material.dart";
import "package:bloo/api.dart" as api;

class VideoPlayerWidget extends StatefulWidget {
    Map<String, dynamic> videoData;

    VideoPlayerWidget(this.videoData);

    @override
    _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
    dynamic videoController;
    
    @override
    void initState() {
        super.initState();
        videoController = VideoPlayerController.network("${api.API_BASE}/cached/video/${widget.videoData['id']}")..initialize().then((_) {
            setState(() {});
            videoController.setLooping(true);
            videoController.play();
        });
    }

    @override
    Widget build(BuildContext context) {
        return Stack(
            children: <Widget>[
                // Avatar
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: SizedBox(
                        height: 64,
                        width: 64,
                        child: Image.network("${api.API_BASE}/cached/avatar/${widget.videoData['creator_id']}")
                    )
                ),
                Positioned(
                    bottom: 10,
                    left: 10 + 64 + 10,
                    child: generateDescription()
                ),
                // Video player
                Center(
                    child: GestureDetector(
                        onTap: () {
                            if (videoController.value.isPlaying) {
                                videoController.pause();
                            } else {
                                videoController.play();
                            }
                        },
                        child: AspectRatio(
                            aspectRatio: videoController.value.aspectRatio,
                            child: VideoPlayer(videoController)
                        )
                    )
                )
            ]
        );
    }

    Widget generateDescription() {
        List<TextSpan> formattedDescription = [];

        var description = widget.videoData["description"];
        for (String word in description.split(" ")) {
            word = word + " ";
            if (word.startsWith("#")) {
                formattedDescription.add(TextSpan(
                    text: word,
                    style: TextStyle(
                        color: Color(0x99EEEEEE),
                        fontWeight: FontWeight.bold
                    )
                ));

            } else if (word.startsWith("@")) {
                formattedDescription.add(TextSpan(
                    text: word,
                    style: TextStyle(
                        color: Color(0x99EEEEEE),
                        fontWeight: FontWeight.bold
                    )
                ));

            } else {
                formattedDescription.add(TextSpan(
                    text: word,
                    style: TextStyle(
                        color: Color(0x99EEEEEE)
                    )
                ));
            }
        }
        print(formattedDescription);
        return RichText(
            text: TextSpan(
                children: formattedDescription,
            )
        );
    }
    void playPause() {
        if (videoController.value.isPlaying) {
            videoController.pause();
        } else {
            videoController.play();
        }
    }


    @override
    void dispose() {
        super.dispose();
        videoController.dispose();
    }
}
