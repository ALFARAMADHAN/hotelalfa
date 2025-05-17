import 'package:hotelalfa/listkamar.dart';
import 'package:flutter/material.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  final PageController onboardingController = PageController();
  int indexPage = 0;

  List<Map<String, String>> onboardPageData = [
    {
      "title": "Selamat Datang di Hotel Mercure",
      "image":
          "https://image-tc.galaxy.tf/wijpeg-2ofe2wg1akyihp1lytvujz7ud/presidential-suite-bedroom.jpg",
      "subtitle": "Temukan pengalaman menginap terbaik dengan layanan istimewa."
    },
    {
      "title": "Pesan Kamar dengan Mudah",
      "image":
          "https://dailyhotels.id/wp-content/uploads/2021/03/Standard-Room-e1617073694126.jpg",
      "subtitle": "Nikmati kemudahan memesan kamar dan akses fasilitas eksklusif dalam hitungan detik."
    },
    {
      "title": "Kenyamanan yang Anda Butuhkan",
      "image":
          "https://d2e5ushqwiltxm.cloudfront.net/wp-content/uploads/sites/18/2021/03/04084856/11.-Family-Room-1-Novotel28512-min.jpg",
      "subtitle": "Jelajahi kamar mewah dan layanan premium untuk pengalaman tak terlupakan."
    },
    {
      "title": "Kemudahan dalam Satu Sentuhan",
      "image":
          "https://www.kempinski.com/var/site/storage/images/2/6/2/8/2648262-1-eng-GB/c90e9a6c766d-89879449_4K.jpg",
      "subtitle": "Akses layanan hotel dan kelola reservasi dengan aplikasi intuitif."
    },
    {
      "title": "Hotel Mercure di Ujung Jari Anda",
      "image":
          "https://www.furama.com/images/FRF_Superior_01.jpg",
      "subtitle":
          "Cek, pesan, dan kelola reservasi Anda dengan aplikasi pintar ini."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: onboardingController,
              onPageChanged: (page) {
                setState(() {
                  indexPage = page;
                });
              },
              itemCount: onboardPageData.length,
              itemBuilder: (context, index) {
                return OnboardingData(
                  title: onboardPageData[index]['title']!,
                  image: onboardPageData[index]['image']!,
                  subtitle: onboardPageData[index]['subtitle']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                (indexPage == onboardPageData.length - 1)
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => ListKamar()),
                          );
                        },
                        child: const Text(
                          "Get Started",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      )
                    : const SizedBox.shrink(),
                
                Row(
                  children: List.generate(
                    onboardPageData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indexPage == index
                            ? Colors.blue
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (indexPage == onboardPageData.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListKamar()),
                      );
                    } else {
                      onboardingController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnboardingData extends StatelessWidget {
  final String title;
  final String image;
  final String subtitle;

  const OnboardingData({
    super.key,
    required this.title,
    required this.image,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(
          image,
          height: 210,
          width: 360,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              "Error Loading product images from server",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}