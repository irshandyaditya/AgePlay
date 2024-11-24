import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About AgePlay'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tentang Kami',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'AgePlay adalah solusi pintar untuk membantu pengguna menemukan game yang sesuai berdasarkan usia dan jenis kelamin. '
                'Dengan memanfaatkan teknologi kecerdasan buatan untuk mendeteksi usia dan mengenali jenis kelamin pengguna, AgePlay '
                'memberikan rekomendasi game yang dirancang khusus sesuai kategori umur dan preferensi pengguna, baik untuk anak-anak, '
                'remaja, hingga dewasa. Aplikasi ini berkomitmen menghadirkan lingkungan bermain yang aman, edukatif, dan menghibur, '
                'sehingga pengguna bisa mendapatkan pengalaman bermain yang sesuai dengan kebutuhan dan minat mereka.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Pilih Game yang Tepat dengan AgePlay',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'AgePlay adalah aplikasi pilihan Anda untuk menemukan game yang sesuai dengan karakteristik pribadi Anda. '
                'Dengan teknologi pengenalan usia dan jenis kelamin yang canggih, AgePlay membantu memfilter game yang cocok, '
                'relevan, dan aman untuk setiap pengguna. Bagi orang tua, AgePlay juga menjadi alat bantu penting untuk memastikan '
                'anak-anak mereka mendapatkan rekomendasi game yang edukatif dan sesuai untuk usia mereka. Jadikan AgePlay sebagai '
                'teman Anda dalam memilih game berkualitas!',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Mengapa AgePlay?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Di era digital ini, menemukan game yang tepat bisa menjadi tantangan, terutama dengan banyaknya pilihan yang tersedia. '
                'AgePlay hadir sebagai solusi, mengkombinasikan teknologi deteksi usia dan pengenalan jenis kelamin untuk memberikan '
                'rekomendasi yang disesuaikan. Setiap rekomendasi di AgePlay dipilih dengan cermat untuk memberikan pengalaman bermain '
                'yang aman dan sesuai dengan perkembangan psikologis pengguna. Dengan AgePlay, game bukan hanya hiburan, tapi juga media '
                'pembelajaran yang tepat untuk setiap tahap usia.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
