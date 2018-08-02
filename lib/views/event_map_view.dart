import 'package:austin_feeds_me/data/events_repository.dart';
import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:austin_feeds_me/util/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:austin_feeds_me/util/url_util.dart';
import 'package:austin_feeds_me/util/event_util.dart';

class EventMapView extends StatefulWidget {
  EventMapView({Key key}) : super(key: key);

  @override
  _Maps createState() => new _Maps();
}

class _Maps extends State<EventMapView> {
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();

    EventRepository.getEvents().then((List<AustinFeedsMeEvent> events) {
      List<Marker> markers = [];
      for (var currentEvent in events) {
        Marker currentMarker = new Marker(
            width: 30.0,
            height: 30.0,
            point: currentEvent.latLng,
            builder: (ctx) => new GestureDetector(
                  child: Image.asset(
                    ImageUtil.getAppLogo(),
                    width: 30.0,
                    height: 30.0,
                  ),
                  onTap: () => onEventClick(currentEvent),
                ));
        markers.add(currentMarker);
      }
      setState(() {
        this.markers = markers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
        options: new MapOptions(
          center: new LatLng(30.2669444, -97.7427778),
          zoom: 12.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          new MarkerLayerOptions(markers: markers)
        ]);
  }

  onEventClick(AustinFeedsMeEvent austinFeedsMeEvent) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                child: ImageUtil.getEventImageWidget(
                      austinFeedsMeEvent, 400.0, 200.0),),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new Text(
                    EventUtil
                        .getEventDateAndTimeDisplayText(austinFeedsMeEvent),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new Text(
                    austinFeedsMeEvent.name,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                  ),
                  new Text(
                    austinFeedsMeEvent.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  new FlatButton(onPressed: () => UrlUtil.launchURL(austinFeedsMeEvent.url),
                      child: new Text("RSVP", style: const TextStyle(fontSize: 18.0)),
                  color: Colors.lightBlue,)
                ],
              ));
        });
  }
}
