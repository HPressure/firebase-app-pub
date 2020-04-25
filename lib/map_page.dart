import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

const LatLng _coordinates = LatLng(64.418654, 40.804021);

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _animationController;
  Animation<double> _animateIcon;
  Completer<GoogleMapController> _controller = Completer();
  double _scrollExtent;
  bool _buttonState;
  double _opacity = 0.0;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _coordinates,
    zoom: 14.4746,
  );

  @override
  void initState() {
    _buttonState = true;
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: -0.5).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollExtent = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: FloatingActionButton(
          child: RotationTransition(
            turns: _animateIcon,
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 30,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          onPressed: () {
            if (_buttonState) {
              _scrollController.animateTo(_scrollExtent,
                  duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
              setState(() {
                _animationController.forward();
                _opacity = 1.0;
              });
              _buttonState = false;
            } else {
              _scrollController.animateTo(-_scrollExtent,
                  duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
              setState(() {
                _animationController.reverse();
                _opacity = 0.0;
              });
              _buttonState = true;
            }
          },
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            leading: null,
            pinned: true,
            floating: true,
            expandedHeight:
            MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 10.0, bottom: 20.0),
              title: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _opacity,
                  child: Text('Мастер')),
              background: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _createMarker(),
                onMapCreated: _onMapCreated,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Builder(builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(24.0),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Адрес:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'г. Новодвинск, ул. Космонавтов, д. 6\n'),
                            TextSpan(
                                text: 'Часы работы:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'Пн-Пт: 09:00-17:00\n'
                                    'Сб-Вс: Выходной\n'),
                            TextSpan(
                                text: 'Контактная информация:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '8(958)584-33-93\n'
                                    'kkmmas@yandex.ru'),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async{
    _controller.complete(controller);
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: _coordinates,
        infoWindow: InfoWindow(title: 'ООО "Мастер"'),
      ),
    ].toSet();
  }
}

