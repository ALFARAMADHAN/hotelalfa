import 'package:flutter/material.dart';
import 'package:hotelalfa/detailpesanan.dart';

class DetailKamarPage extends StatelessWidget {
  final Map<String, dynamic> room;

  DetailKamarPage({required this.room});

  @override
  Widget build(BuildContext context) {
    
    final String imageUrl =
        room['gambar'] ?? 'https://example.com/default-image.jpg';
    final String roomType = room['tipe'] ?? 'Unknown Type';
    final String roomNumber = room['nomor']?.toString() ?? 'Unknown';
    final String roomFloor = room['lantai']?.toString() ?? 'Tidak diketahui';
    final String roomPrice = room['harga']?.toString() ?? '0';
    final List<String> facilities = room['fasilitas'] != null
        ? (room['fasilitas'] as String).split(',').map((e) => e.trim()).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kamar di Hotel Mercure'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 200),
            ),
            SizedBox(height: 20),
            
            Text(
              'Tipe: $roomType',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nomor Kamar: $roomNumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Lantai: $roomFloor',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Harga: Rp$roomPrice / malam',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 20),
            
            Text(
              'Fasilitas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            facilities.isNotEmpty
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: facilities.map((facility) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 20),
                          SizedBox(width: 5),
                          Text(
                            facility,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : Text('Tidak ada fasilitas yang tersedia.'),
            Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPesananPage(room: room),
                    ),
                  );
                },
                child: Text(
                  'Booking',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
