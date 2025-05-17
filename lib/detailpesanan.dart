import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 


class DetailPesananPage extends StatefulWidget {
  
  final Map<String, dynamic> room;

  DetailPesananPage({required this.room});

  @override
  _DetailPesananPageState createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  double totalHarga = 0.0;

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
  if (pickedDate != null) {
    controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    _calculateTotalHarga(); 
  }
}

void _calculateTotalHarga() {
  if (checkInController.text.isNotEmpty && checkOutController.text.isNotEmpty) {
    try {
      
      DateTime checkIn = DateTime.parse(checkInController.text);
      DateTime checkOut = DateTime.parse(checkOutController.text);

      if (checkOut.isAfter(checkIn)) {
        
        int jumlahMalam = checkOut.difference(checkIn).inDays;

        double hargaPerMalam = widget.room['harga'] is int
            ? (widget.room['harga'] as int).toDouble() 
            : widget.room['harga'] is String
                ? double.parse(widget.room['harga']) 
                : widget.room['harga'] ?? 0.0; 

        double total = jumlahMalam * hargaPerMalam;

        setState(() {
          totalHarga = total; 
        });
      } else {
        setState(() {
          totalHarga = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tanggal check-out harus setelah check-in!')),
        );
      }
    } catch (e) {
      print("Error parsing date or calculating price: $e");
    }
  }
}

void _handleConfirmation() async {
  if (nameController.text.isEmpty ||
      phoneController.text.isEmpty ||
      checkInController.text.isEmpty ||
      checkOutController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Harap lengkapi semua data sebelum melanjutkan!'),
      ),
    );
    return;
  }

  final data = {
    'id_kamar': widget.room['id'], 
    'nama_pemesan': nameController.text,
    'no_hp': phoneController.text,
    'tanggal_check_in': checkInController.text,
    'tanggal_check_out': checkOutController.text,
    'total_harga': totalHarga.toString(),
  };

  try {

    final url = Uri.parse('http://10.0.2.2/backend_hotel/addpesanan.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['message'] == 'New order successfully added') {
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Pesanan Berhasil'),
              content: Text(
                  'Kamar nomor ${widget.room['nomor']} dengan tipe ${widget.room['tipe']} telah berhasil dipesan.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                    Navigator.of(context).pop(data); 
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan pesanan: ${responseData['message']}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghubungi server (${response.statusCode})'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan: $e'),
      ),
    );
  }
}

@override
  void initState() {
    super.initState();
    print("Room data: ${widget.room}");
  }

  @override
  void dispose() {
    checkInController.dispose();
    checkOutController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        widget.room['gambar'] ?? 'https://example.com/default-image.jpg';
    final String roomType = widget.room['tipe'] ?? 'Unknown Type';
    final String roomNumber = widget.room['nomor']?.toString() ?? 'Unknown';
    final String roomPrice = widget.room['harga']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                '${widget.room['gambar']}',
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 150),
              ),
              SizedBox(height: 20),
              Text(
                'Nomor Kamar : ${widget.room['nomor']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Tipe: ${widget.room['tipe']}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                'Harga per malam: Rp${widget.room['harga']}',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pemesan',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Nomor HP',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: checkInController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Check-In',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today, size: 20),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, checkInController),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: checkOutController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Check-Out',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today, size: 20),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, checkOutController),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total Harga: Rp$totalHarga',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleConfirmation,
                  child: Text(
                    'Konfirmasi Pesanan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
