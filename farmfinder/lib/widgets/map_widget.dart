import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final MapController _controller = MapController();
  Style? _style;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initStyle();
  }

  void _initStyle() async {
    try {
      _style = await _readStyle();
    } catch (e, stack) {
      print(e);
      print(stack);
      _error = e;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (_error != null) {
      children.add(Expanded(child: Text(_error!.toString())));
    } else if (_style == null) {
      children.add(const Center(child: CircularProgressIndicator()));
    } else {
      children.add(Flexible(child: _map(_style!)));
      children.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_statusText()]));
    }
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children)));
  }

  Future<Style> _readStyle() => StyleReader(
          uri:
              'https://tiles.stadiamaps.com/styles/osm_bright.json?api_key={key}',
          apiKey: dotenv.env['STADIA_MAPS_API_KEY'],
          logger: null)
      .read();

  Widget _map(Style style) => FlutterMap(
        mapController: _controller,
        options: MapOptions(
            initialCenter: style.center ?? const LatLng(49.246292, -123.116226),
            initialZoom: style.zoom ?? 10,
            minZoom: 0,
            maxZoom: 25,
            backgroundColor: Theme.of(context).canvasColor),
        children: [
          VectorTileLayer(
              tileProviders: style.providers,
              theme: style.theme,
              sprites: style.sprites,
              maximumZoom: 22,
              tileOffset: TileOffset.mapbox,
              layerMode: VectorTileLayerMode.vector),
          _currentLocationLayer(),
        ],
      );

  Widget _currentLocationLayer() => CurrentLocationLayer(
        alignPositionOnUpdate: AlignOnUpdate.once,
        alignDirectionOnUpdate: AlignOnUpdate.never,
        style: const LocationMarkerStyle(
          marker: DefaultLocationMarker(
            child: Icon(
              Icons.navigation,
              color: Colors.white,
            ),
          ),
          markerSize: Size(40, 40),
          markerDirection: MarkerDirection.heading,
        ),
      );

  Widget _statusText() => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: StreamBuilder(
          stream: _controller.mapEventStream,
          builder: (context, snapshot) {
            return Text(
                'Zoom: ${_controller.camera.zoom.toStringAsFixed(2)} Center: ${_controller.camera.center.latitude.toStringAsFixed(4)},${_controller.camera.center.longitude.toStringAsFixed(4)}');
          }));
}
