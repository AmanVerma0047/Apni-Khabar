import 'package:news_app/models/channel_model.dart';

List<ChannelModel> getChannels() {
  return [
    ChannelModel(name: 'BBC News', imageUrl: 'images/bbc.jpg'),
    ChannelModel(name: 'CNN', imageUrl: 'images/cnn.png'),
    ChannelModel(name: 'Al Jazeera', imageUrl: 'images/timesnow.png'),
    // Add more...
  ];
}
