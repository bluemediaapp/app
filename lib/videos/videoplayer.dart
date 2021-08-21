import "package:video_player/video_player.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:bloo/api.dart" as api;

class VideoPlayerPanel extends StatefulWidget {
    Map<String, dynamic> videoData;

    VideoPlayerPanel(this.videoData);

    @override
    _VideoPlayerPanelState createState() => _VideoPlayerPanelState();
}

class _VideoPlayerPanelState extends State<VideoPlayerPanel> {
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
        var widgets = <Widget>[];

       
        // Video player
        widgets.add(
            Center(
                child: GestureDetector(
                    onTap: this.playPause,
                    child: AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController)
                    )
                )
            )
        );

        // Loading / Paused icon
        if (!videoController.value.isInitialized) {
            // Loading video
            widgets.add(
                Center(
                    child: SpinKitWave(
                        color: Color(0xFF00FFFF),
                        size: 25
                    )
                )
            );
        } else if (!this.videoController.value.isPlaying) {
            // Video is paused
            widgets.add(
                Center(
                    child: InkWell(
                        onTap: this.playPause,
                        child: Icon(
                            Icons.play_arrow,
                            color: Color(0xFF00FFFF),
                            size: 48
                        )
                    )
                )
            );
        }


        // Avatar
        widgets.add(
            Positioned(
                bottom: 10,
                left: 10,
                child: SizedBox(
                    height: 64,
                    width: 64,
                    child: Image.network("${api.API_BASE}/cached/avatar/${widget.videoData['creator_id']}")
                )
            )
        );
        
        // Description
        widgets.add(
            Positioned(
                bottom: 10,
                left: 10 + 64 + 10,
                child: generateDescription()
            )
        );
        
        // Render
        return Stack(
            children: widgets
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
        return RichText(
            text: TextSpan(
                children: formattedDescription,
            )
        );
    }
    void playPause() {
        setState(() {
            if (videoController.value.isPlaying) {
                videoController.pause();
            } else {
                videoController.play();
            }
        });
    }


    @override
    void dispose() {
        super.dispose();
        videoController.dispose();
    }
}
