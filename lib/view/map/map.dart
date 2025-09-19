import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InternationalMapScreen extends StatefulWidget {
  const InternationalMapScreen({super.key});

  @override
  _InternationalMapScreenState createState() => _InternationalMapScreenState();
}

class _InternationalMapScreenState extends State<InternationalMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final LatLng _defaultCenter = const LatLng(
    26.3351,
    17.2283,
  ); // Libya center as default
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = false;
  String _locationError = '';
  String? _selectedAddress;
  String? _selectedCity;
  String? _selectedPostalCode;
  String? _selectedCountry;
  LatLng? _selectedLocation;
  LatLng? _centerPosition;
  bool _mapMoving = false;
  Timer? _debounceTimer;

  static const String _googleMapsApiKey =
      'AIzaSyCh4R8UsnyNIvblqx2sUa3juTiNHn89d70';

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

      await _updateSelectedLocation(_centerPosition!);
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

  Future<Map<String, dynamic>> _reverseGeocodeWithFallbacks(
    LatLng position,
  ) async {
    // First try: Google Geocoding API
    try {
      final googleResult = await _googleReverseGeocode(position);
      if (googleResult['address'] != null &&
          googleResult['address'].isNotEmpty) {
        return googleResult;
      }
    } catch (e) {
      debugPrint('Google geocoding failed: $e');
    }

    // Second try: OpenStreetMap Nominatim
    try {
      final osmResult = await _osmReverseGeocode(position);
      if (osmResult['address'] != null && osmResult['address'].isNotEmpty) {
        return osmResult;
      }
    } catch (e) {
      debugPrint('OSM geocoding failed: $e');
    }

    // Final fallback: Use Flutter's geocoding plugin
    try {
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;
        final street = place.street ?? '';
        final locality = place.locality ?? '';
        final administrativeArea = place.administrativeArea ?? '';
        final postalCode = place.postalCode ?? '';
        final country = place.country ?? '';

        // Build clean address without postal codes or other codes mixed in
        final addressParts = [
          if (street.isNotEmpty) street,
          if (locality.isNotEmpty && locality != administrativeArea) locality,
          if (administrativeArea.isNotEmpty) administrativeArea,
        ];

        final address = addressParts.join(', ');

        return {
          'address': address.isNotEmpty ? address : 'Selected Location',
          'city': _extractBestCityName(locality, administrativeArea, country),
          'zipCode': postalCode,
          'country': country,
        };
      }
    } catch (e) {
      debugPrint('Flutter geocoding failed: $e');
    }

    // If all else fails, return coordinates
    return {
      'address':
          'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}',
      'city': null,
      'zipCode': null,
      'country': null,
    };
  }

  // Helper to extract the best city name from available data
  String? _extractBestCityName(
    String? locality,
    String? administrativeArea,
    String? country,
  ) {
    if (locality != null && locality.isNotEmpty) {
      return locality;
    }

    if (administrativeArea != null && administrativeArea.isNotEmpty) {
      return administrativeArea;
    }

    return null;
  }

  Future<Map<String, dynamic>> _googleReverseGeocode(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=${position.latitude},${position.longitude}'
        '&key=$_googleMapsApiKey'
        '&language=ar'; // Arabic language for Libya

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        return _parseGoogleGeocodeResult(data['results'][0]);
      }
    }
    throw Exception('Google geocoding failed');
  }

  Map<String, dynamic> _parseGoogleGeocodeResult(Map<String, dynamic> result) {
    final address = result['formatted_address'];
    String? city;
    String? zipCode;
    String? country;

    for (final component in result['address_components']) {
      final types = List<String>.from(component['types']);
      if (types.contains('locality') ||
          types.contains('sublocality') ||
          types.contains('sublocality_level_1')) {
        city = component['long_name'];
      } else if (types.contains('postal_code')) {
        zipCode = component['long_name'];
      } else if (types.contains('country')) {
        country = component['long_name'];
      }
    }

    // Clean up the address by removing country and postal code if they're at the end
    String cleanAddress = address;
    if (country != null && cleanAddress.endsWith(country)) {
      cleanAddress =
          cleanAddress
              .substring(0, cleanAddress.length - country.length)
              .trim();
      if (cleanAddress.endsWith(',')) {
        cleanAddress =
            cleanAddress.substring(0, cleanAddress.length - 1).trim();
      }
    }

    if (zipCode != null && cleanAddress.endsWith(zipCode)) {
      cleanAddress =
          cleanAddress
              .substring(0, cleanAddress.length - zipCode.length)
              .trim();
      if (cleanAddress.endsWith(',')) {
        cleanAddress =
            cleanAddress.substring(0, cleanAddress.length - 1).trim();
      }
    }

    return {
      'address': cleanAddress,
      'city': city,
      'zipCode': zipCode,
      'country': country,
    };
  }

  Future<Map<String, dynamic>> _osmReverseGeocode(LatLng position) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?'
        'format=json&'
        'lat=${position.latitude}&'
        'lon=${position.longitude}&'
        'addressdetails=1';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parseOsmGeocodeResult(data);
    }
    throw Exception('OSM geocoding failed');
  }

  Map<String, dynamic> _parseOsmGeocodeResult(Map<String, dynamic> result) {
    final address = result['display_name'];
    final addressDetails = result['address'] as Map<String, dynamic>? ?? {};

    final city =
        addressDetails['city'] ??
        addressDetails['town'] ??
        addressDetails['village'] ??
        addressDetails['municipality'] ??
        addressDetails['state_district'];

    final zipCode = addressDetails['postcode'];
    final country = addressDetails['country'];

    return {
      'address': address,
      'city': city,
      'zipCode': zipCode,
      'country': country,
    };
  }

  Future<void> _updateSelectedLocation(LatLng position) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isLoading = true;
        _selectedLocation = position;
      });

      try {
        final locationData = await _reverseGeocodeWithFallbacks(position);

        // DEBUG: Print what we received from geocoding
        print('Geocoding result: $locationData');

        // Get the zip code using our helper - pass both city and country
        final String? zipCode =
            locationData['zipCode'] ??
            _getZipCodeForCity(locationData['city'], locationData['country']);

        // DEBUG: Print the zip code result
        print(
          'City: ${locationData['city']}, Country: ${locationData['country']}, Zip Code: $zipCode',
        );

        setState(() {
          _selectedAddress = locationData['address'];
          _selectedCity = locationData['city'];
          _selectedPostalCode = zipCode;
          _selectedCountry = locationData['country'];
        });
      } catch (e) {
        debugPrint("Geocoding error: $e");
        setState(() {
          _selectedAddress =
              'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}';
          _selectedCity = null;
          _selectedPostalCode = null;
          _selectedCountry = null;
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

  String? _getZipCodeForCity(String? city, String? country) {
    if (city == null) return null;

    final normalizedCity = city.toLowerCase().trim();

    final Map<String, String> libyanCityZipCodes = {
      'tripoli': '11011',
      'benghazi': '21011',
      'misrata': '22011',
      'bayda': '21012',
      'zawiya': '11012',
      'zliten': '22012',
      'ajdabiya': '21013',
      'gharyan': '11013',
      'sabha': '31011',
      'derna': '21014',
      'tobruk': '21015',
      'sirte': '22013',
      'bani walid': '22014',
      'tarhuna': '11014',
      'al khums': '22015',
      'zuwara': '11015',
      'yafran': '11016',
      'nalut': '11017',
      'ghat': '31012',
      'jadu': '11018',
      'murzuk': '31013',
      'kufra': '32011',
    };

    final Map<String, String> tunisianCityZipCodes = {
      'sousse': '4000',
      'tunis': '1000',
      'sfax': '3000',
      'djerba': '4100',
      'monastir': '5000',
      'mahdia': '5100',
      'kairouan': '3100',
    };

    return libyanCityZipCodes[normalizedCity] ??
        tunisianCityZipCodes[normalizedCity];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
              target: _defaultCenter,
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

          // Address display in center (original UI)
          if (_selectedAddress != null && !_mapMoving)
            Positioned(
              top: 240,
              left: (MediaQuery.of(context).size.width - 282) / 2,
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

          // Center marker
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
              left: (MediaQuery.of(context).size.width - 282) / 2,
              child: SizedBox(
                width: 282,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.pop(context, {
                        'address': _selectedAddress,
                        'city': _selectedCity,
                        'zipCode': _selectedPostalCode,
                        'country': _selectedCountry,
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
                    t.validate,
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
