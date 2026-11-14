import 'package:flutter/material.dart';

class VenueMapViewer extends StatelessWidget {
  const VenueMapViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Denah Venue NusaEvent Hub',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 350,
            width: double.infinity,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(40),
              child: Container(
                width: 600,
                height: 400,
                color: Colors.deepPurple.shade50,
                child: Stack(
                  children: [
                    _venueRoom(
                      'Panggung Utama',
                      180,
                      20,
                      240,
                      90,
                      Colors.deepPurple.shade200,
                    ),
                    _venueRoom(
                      'Area Seminar A',
                      20,
                      140,
                      170,
                      100,
                      Colors.blue.shade100,
                    ),
                    _venueRoom(
                      'Area Seminar B',
                      210,
                      140,
                      170,
                      100,
                      Colors.green.shade100,
                    ),
                    _venueRoom(
                      'Registrasi',
                      410,
                      140,
                      170,
                      100,
                      Colors.orange.shade100,
                    ),
                    _venueRoom(
                      'Kantin',
                      20,
                      280,
                      170,
                      90,
                      Colors.pink.shade100,
                    ),
                    _venueRoom(
                      'Toilet',
                      210,
                      280,
                      170,
                      90,
                      Colors.grey.shade300,
                    ),
                    _venueRoom(
                      'Pintu Masuk',
                      410,
                      280,
                      170,
                      90,
                      Colors.teal.shade100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.zoom_in, color: Colors.deepPurple),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cubit layar atau gunakan gestur untuk memperbesar dan menggeser denah.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _venueRoom(
    String name,
    double left,
    double top,
    double width,
    double height,
    Color color,
  ) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
