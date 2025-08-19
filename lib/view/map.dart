import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class LibyaMapScreen extends StatefulWidget {
  const LibyaMapScreen({super.key});

  @override
  _LibyaMapScreenState createState() => _LibyaMapScreenState();
}

class _LibyaMapScreenState extends State<LibyaMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final LatLng _libyaCenter = const LatLng(26.3351, 17.2283);
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = false;
  String _locationError = '';
  String? _selectedAddress;
  LatLng? _selectedLocation;
  LatLng? _centerPosition;
  bool _mapMoving = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isLoading = true;
      _locationError = '';
    });

    final status = await Permission.location.status;
    if (status.isDenied) {
      final result = await Permission.location.request();
      if (!result.isGranted) {
        setState(() {
          _isLoading = false;
          _locationError = 'Location permission denied';
        });
        return;
      }
    }

    if (status.isPermanentlyDenied) {
      setState(() {
        _isLoading = false;
        _locationError =
            'Location permission permanently denied. Please enable it in app settings.';
      });
      await openAppSettings();
      return;
    }
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _locationError =
              'Location services are disabled. Please enable them.';
        });
        await Geolocator.openLocationSettings();
        return;
      }

      setState(() {
        _isLoading = true;
        _locationError = '';
      });

      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 15),
        );
      } on TimeoutException {
        Position? lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          position = lastKnown;
        } else {
          setState(() {
            _isLoading = false;
            _locationError =
                'Location request timed out. Please select a location manually.';
          });
          return;
        }
      }

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _centerPosition = LatLng(position.latitude, position.longitude);
        _markers.removeWhere(
          (marker) => marker.markerId.value == 'currentLocation',
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Current Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      });

      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _locationError = 'Failed to get location: ${e.toString()}';
      });
      debugPrint("Error getting location: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateSelectedLocation(LatLng position) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isLoading = true;
        _selectedLocation = position;
      });

      try {
        final places = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (places.isNotEmpty) {
          final place = places.first;
          final address = [
            if (place.street != null) place.street,
            if (place.locality != null) place.locality,
            if (place.administrativeArea != null) place.administrativeArea,
            if (place.country != null) place.country,
          ].where((part) => part != null && part.isNotEmpty).join(', ');

          setState(() {
            _selectedAddress =
                address.isNotEmpty ? address : 'Selected Location';
          });
        }
      } catch (e) {
        debugPrint("Geocoding error: $e");
        setState(() {
          _selectedAddress =
              'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}';
        });
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerPosition = position.target;
      _mapMoving = true;
    });
  }

  void _onCameraIdle() {
    if (_centerPosition != null) {
      _updateSelectedLocation(_centerPosition!);
    }
    setState(() {
      _mapMoving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF008AD2),
        title: Text(
          "Select Location",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _libyaCenter,
              zoom: 5.5,
            ),
            mapType: MapType.normal,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            onTap: (LatLng position) {
              // Move camera to tapped position
              _mapController.future.then((controller) {
                controller.animateCamera(CameraUpdate.newLatLng(position));
              });
            },
          ),
          if (_selectedAddress != null && !_mapMoving)
            Positioned(
              top: 240,
              left:
                  (MediaQuery.of(context).size.width - 282) /
                  2, // Centers the container horizontally
              child: Container(
                width: 275,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    _selectedAddress!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          // Center picker widget remains the same
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_pin, color: Color(0xFF008AD2), size: 48),
                if (_mapMoving)
                  CircularProgressIndicator(
                    color: Color(0xFF008AD2),
                    strokeWidth: 2,
                  ),
              ],
            ),
          ),
          // Validate button
          if (_selectedLocation != null && !_mapMoving)
            Positioned(
              bottom: 80,
              left:
                  (MediaQuery.of(context).size.width - 282) /
                  2, // Centers the button horizontally
              child: SizedBox(
                width: 282,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.pop(context, {
                        'address': _selectedAddress,
                        'latitude': _selectedLocation!.latitude,
                        'longitude': _selectedLocation!.longitude,
                      }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008AD2),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Validate",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          // Loading indicator
          if (_isLoading) Center(child: CircularProgressIndicator()),
          // Error message
          if (_locationError.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _locationError,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
