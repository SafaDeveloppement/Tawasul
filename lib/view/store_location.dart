import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tawasul_application/view/Quick_access/shops.dart';
import 'voice_search.dart';

class StoreLocation extends StatefulWidget {
  const StoreLocation({super.key});

  @override
  State<StoreLocation> createState() => _StoreLocationState();
}

class _StoreLocationState extends State<StoreLocation> {
  int selectedIndex = 0;
  final MapController _mapController = MapController();

  final List<Map<String, dynamic>> stores = [
    {
      'title': 'Tawasul All',
      'address': 'Street Al Khotot, Al Baida\nLibya',
      'phone': '+218922559400',
      'location': LatLng(32.7628, 21.7551),
    },
    {
      'title': 'Tawasul Apple',
      'address': 'Venice, Benghazi\nLibya',
      'phone': '+218922559300',
      'location': LatLng(32.1167, 20.0667),
    },
    {
      'title': 'Tawasul Xiaomi',
      'address': 'Benghazi, Benghazi\nLibya',
      'phone': '+218922559400',
      'location': LatLng(32.114, 20.078),
    },
    {
      'title': 'Tawasul Samsung',
      'address': 'Street Al-Riwayat ard Ben Ali, Benghazi\nLibya',
      'phone': '+218922559300',
      'location': LatLng(32.130, 20.090),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildMap(),
            Expanded(child: _buildStoreList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FindTawasul()),
                ),
            child: Container(
              margin: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF008AD2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey),
                    onPressed: () async {
                      final searchQuery = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VoiceSearchScreen(),
                        ),
                      );
                      if (searchQuery != null && searchQuery.isNotEmpty) {
                        _handleVoiceSearchResult(searchQuery);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleVoiceSearchResult(String query) {
    final lowerQuery = query.toLowerCase();
    final matchingStores =
        stores.where((store) {
          return store['title'].toLowerCase().contains(lowerQuery) ||
              store['address'].toLowerCase().contains(lowerQuery);
        }).toList();

    if (matchingStores.isNotEmpty) {
      setState(() {
        selectedIndex = stores.indexOf(matchingStores.first);
        _mapController.move(matchingStores.first['location'], 10.0);
      });
    }
  }

  Widget _buildMap() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: stores[selectedIndex]['location'],
          initialZoom: 6.5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers:
                stores.map((store) {
                  final isSelected = stores.indexOf(store) == selectedIndex;
                  return Marker(
                    width: 40,
                    height: 40,
                    point: store['location'],
                    child: Icon(
                      Icons.location_pin,
                      color:
                          isSelected ? const Color(0xFF008AD2) : Colors.black,
                      size: 40,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final store = stores[index];
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () {
            setState(() => selectedIndex = index);
            _mapController.move(store['location'], 10.0);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border:
                  isSelected
                      ? Border.all(color: const Color(0xFF008AD2), width: 1.5)
                      : null,
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF008AD2),
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store['address'],
                        style: const TextStyle(color: Colors.grey, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    const Icon(Icons.phone, color: Color(0xFF008AD2)),
                    Text(
                      store['phone'],
                      style: const TextStyle(
                        color: Color(0xFF008AD2),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
