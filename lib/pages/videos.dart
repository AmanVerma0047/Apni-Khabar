import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/channel_model.dart';
import 'package:news_app/services/ApiKeys.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final String apiKey = YOUTUBE_API_KEY;

  List<String> featuredVideoIds = [];
  List<String> featuredVideoTitles = [];

  List<String> channelVideoIds = [];
  List<String> channelVideoTitles = [];

  List<ChannelModel> channels = [];
  bool isLoading = true;

  String selectedChannelId = 'UC16niRr50-MSBwiO3YDb3RA'; // BBC

  @override
  void initState() {
    super.initState();
    channels = [
      ChannelModel(
        name: 'BBC News',
        imageUrl: 'images/bbc.jpg',
        channelId: 'UC16niRr50-MSBwiO3YDb3RA',
      ),
      ChannelModel(
        name: 'CNN',
        imageUrl: 'images/cnn.png',
        channelId: 'UCupvZG-5ko_eiXAupbDfxWw',
      ),
      ChannelModel(
        name: 'Times Now',
        imageUrl: 'images/timesnow.png',
        channelId: 'UC6RJ7-PaXg6TIH2BzZfTV7w',
      ),
    ];
    fetchFeaturedVideos();
    fetchChannelVideos(selectedChannelId);
  }

  Future<void> fetchFeaturedVideos() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UC16niRr50-MSBwiO3YDb3RA&maxResults=10&order=viewCount&type=video&key=$apiKey'; // Using BBC News for featured

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;

      setState(() {
        featuredVideoIds = items
            .map((item) => item['id']['videoId'] as String?)
            .whereType<String>()
            .toList();

        featuredVideoTitles = items
            .map((item) => item['snippet']['title'] as String?)
            .whereType<String>()
            .toList();
      });
    }
  }

  Future<void> fetchChannelVideos(String channelId) async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&order=date&type=video&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;

      setState(() {
        channelVideoIds = items
            .map((item) => item['id']['videoId'] as String?)
            .whereType<String>()
            .toList();

        channelVideoTitles = items
            .map((item) => item['snippet']['title'] as String?)
            .whereType<String>()
            .toList();

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void openVideo(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPlayer(videoId: videoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Featured Videos',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' - Popular Now',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 179, 249),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredVideoIds.length,
                      itemBuilder: (context, index) {
                        final videoId = featuredVideoIds[index];
                        final thumbnailUrl =
                            'https://img.youtube.com/vi/$videoId/0.jpg';
                        return GestureDetector(
                          onTap: () => openVideo(videoId),
                          child: Container(
                            width: 300,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(thumbnailUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Color.fromARGB(255, 0, 179, 255),
                                size: 60,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Channels',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' - Popular News Channels',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 179, 249),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: channels.length,
                      itemBuilder: (context, index) {
                        final channel = channels[index];
                        return Channels(
                          channel: channel,
                          onTap: () {
                            setState(() {
                              selectedChannelId =
                                  channel.channelId ?? selectedChannelId;
                            });
                            fetchChannelVideos(selectedChannelId);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Videos',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' - Recently Trending',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 179, 249),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: channelVideoIds.length,
                    itemBuilder: (context, index) {
                      return ChannelsVideos(
                        videoId: channelVideoIds[index],
                        title: channelVideoTitles[index],
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class Channels extends StatelessWidget {
  final ChannelModel channel;
  final VoidCallback onTap;

  const Channels({super.key, required this.channel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    channel.imageUrl ?? 'assets/images/default_channel.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              channel.name ?? '',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenPlayer extends StatefulWidget {
  final String videoId;
  const FullScreenPlayer({super.key, required this.videoId});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: const Text('Now Playing')),
          body: Center(child: player),
        );
      },
    );
  }
}

class ChannelsVideos extends StatelessWidget {
  final String videoId;
  final String title;

  const ChannelsVideos({super.key, required this.videoId, required this.title});

  @override
  Widget build(BuildContext context) {
    final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenPlayer(videoId: videoId),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 64,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
