import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotelalfa/detailkamar.dart';

class ListKamar extends StatefulWidget {
    
  @override
  _ListKamarState createState() => _ListKamarState();
}

class _ListKamarState extends State<ListKamar> {
  List<dynamic> rooms = [];
  bool isLoading = true; 
  String errorMessage = ''; 

  @override
  void initState() {
    super.initState();
    fetchRooms(); 
  }

  Future<void> fetchRooms() async {
    final url = 'http://10.0.2.2/backend_hotel/listkamar.php'; 
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          rooms = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Gagal memuat data. Kode status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Kamar di Hotel Mercure'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) 
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) 
              : ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];

                    final String imageUrl = room['gambar'] ?? 'https://example.com/default-image.jpg';
                    final String roomType = room['tipe'] ?? 'Unknown Type';
                    final String roomNumber = room['nomor']?.toString() ?? 'Unknown';
                    final String roomPrice = room['harga']?.toString() ?? '0';

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 150),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [                                
                                Text(
                                  roomType,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                Text(
                                  'Nomor Kamar: $roomNumber',
                                  style: TextStyle(fontSize: 16),
                                ),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    
                                    Text(
                                      'Harga: Rp$roomPrice / malam',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    
                                    ElevatedButton(
                                      onPressed: () {
                                        
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailKamarPage(room: room),
                                          ),
                                        );
                                      },
                                      child: Text('Detail'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListKamar(),
    debugShowCheckedModeBanner: false,
  ));
}
