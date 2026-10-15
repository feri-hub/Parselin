import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const ParcelApp());
}

const Color pink = Color(0xFFAC579C);
const Color darkPink = Color(0xFF91485C);
const Color softPink = Color(0xFFFFF4FC);
const Color pageBg = Color(0xFFF3F3F3);
const Color muted = Color(0xFF888994);

class ParcelApp extends StatelessWidget {
  const ParcelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parcel App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageBg,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: pink),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SimplePage(title: 'Keranjang', icon: Icons.shopping_cart_outlined),
    SimplePage(title: 'Ringkas', icon: Icons.auto_awesome_outlined),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 5),
        padding: const EdgeInsets.only(top: 10, bottom: 19),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_outlined, 'Beranda'),
            _navItem(1, Icons.shopping_cart_outlined, 'Keranjang'),
            _navItem(2, Icons.auto_awesome, 'Ringkas'),
            _navItem(3, Icons.access_time, 'Riwayat'),
            _navItem(4, Icons.person_outline, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final active = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 25,
              color: active ? Colors.redAccent : const Color(0xFF858A94),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                color: active ? Colors.redAccent : const Color(0xFF858A94),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HEADER

class AppHeader extends StatelessWidget {
  final bool showSearch;
  final String greeting;

  const AppHeader({
    super.key,
    this.showSearch = true,
    this.greeting = 'Hai, Fery',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(1, 2, 1, 8),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FF),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          if (showSearch) ...[
            const SizedBox(height: 9),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 22),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Cari seserahan, souvenir, parcel dan lain lain',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Melayani', style: TextStyle(fontSize: 9, color: muted)),
                CircleDot(color: pink),
                Text('Pickup', style: TextStyle(fontSize: 9)),
                CircleDot(color: Colors.orange),
                Text('Delivery', style: TextStyle(fontSize: 9)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                greeting,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CircleDot extends StatelessWidget {
  final Color color;
  const CircleDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.6),
      ),
    );
  }
}

// BERANDA

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> bannerImages = const [
    'assets/images/adds.png',
    'assets/images/adds2.png',
    'assets/images/adds3.png',
    'assets/images/adds4.png',
    'assets/images/adds5.png',
  ];

  final PageController _bannerController = PageController();
  late final Timer _bannerTimer;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_bannerController.hasClients) return;

      _bannerIndex = (_bannerIndex + 1) % bannerImages.length;
      _bannerController.animateToPage(
        _bannerIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  final List<String> categories = const [
    'Seserahan',
    'Hampers',
    'Mahar',
    'Kotak Cincin',
    'Souvenir',
  ];

  final List<String> products = const [
    'Facial wash',
    'Body lotion',
    'Alat sholat',
    'Cincin',
    'Bunga segar',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(),
          SizedBox(
            width: double.infinity,
            height: 136,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: PageView.builder(
                controller: _bannerController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bannerImages.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    bannerImages[index],
                    width: double.infinity,
                    height: 136,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 59,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Container(
                  width: 48,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        color: Color(0xFFB9A184),
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        categories[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 17),
          const SectionTitle(title: 'Promo Bulan Ini'),
          const SizedBox(height: 8),
          SizedBox(
            height: 112,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                PromoCard(
                  title: 'Seserahan Pernikahan Aesthetic',
                  price: 'Rp 150.000',
                ),
                SizedBox(width: 9),
                PromoCard(
                  title: 'Hampers Pernikahan Premium',
                  price: 'Rp 350.000',
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const SectionTitle(title: 'Pilih barang'),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 9),
              itemBuilder: (context, index) {
                return Container(
                  width: 54,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Icon(
                          Icons.image_outlined,
                          color: Color(0xFFBDBDBD),
                          size: 29,
                        ),
                      ),
                      Text(
                        products[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 7),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFEFFA), Color(0xFFF7E8F4)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: darkPink, size: 14),
                    SizedBox(width: 5),
                    Text(
                      'STUDIO RANGKAI INTERAKTIF',
                      style: TextStyle(
                        fontSize: 9,
                        color: darkPink,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Buat Parcel Impianmu',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Susun sendiri isi seserahan, pilih kotak & dekorasi dalam 3 menit.',
                  style: TextStyle(fontSize: 10, height: 1.5),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Mulai rangkai', style: TextStyle(fontSize: 10)),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String title;
  final String price;

  const PromoCard({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seserahan', style: TextStyle(color: pink, fontSize: 9)),
                SizedBox(height: 5),
                Icon(Icons.card_giftcard, size: 37, color: Color(0xFFC6A58D)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 23),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    side: const BorderSide(color: pink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Beli',
                    style: TextStyle(color: Colors.black, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// RIWAYAT

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<int> _ratings = [4, 4, 4, 4];

  final List<Map<String, String>> orders = const [
    {
      'name': 'Body Lotion CHANEL 200ml',
      'price': 'Rp 250.000',
      'date': '29/09/2026',
    },
    {
      'name': 'Facial Wash COSRX 150ml',
      'price': 'Rp 110.000',
      'date': '21/06/2026',
    },
    {
      'name': 'Alat Sholat Lengkap',
      'price': 'Rp 350.000',
      'date': '15/04/2026',
    },
    {'name': 'Cincin Nikah', 'price': 'Rp 3.000.000', 'date': '10/03/2026'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(),
          const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 10),
            child: Text('Order History', style: TextStyle(fontSize: 14)),
          ),
          ...orders.asMap().entries.map(
            (entry) => Container(
              height: 102,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: softPink,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  Container(
                    width: 51,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFFBBBBBB),
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: darkPink),
                        ),
                        const SizedBox(height: 11),
                        Text(
                          entry.value['price']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFBA879D),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            RatingStars(
                              rating: _ratings[entry.key],
                              onChanged: (rating) {
                                setState(() => _ratings[entry.key] = rating);
                              },
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      entry.value['date']!,
                      style: const TextStyle(
                        fontSize: 8,
                        color: darkPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const RatingStars({super.key, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final isSelected = index < rating;

          return SizedBox(
            width: 26,
            height: 28,
            child: IconButton(
              onPressed: () => onChanged(index + 1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 26, height: 28),
              tooltip: 'Beri rating ${index + 1} dari 5',
              icon: Icon(
                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isSelected
                    ? const Color(0xFFE9A52E)
                    : const Color(0xFFD5C9D0),
                size: 21,
              ),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(
          '$rating/5',
          style: const TextStyle(
            color: darkPink,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// PROFIL

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(1, 0, 1, 20),
      child: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE6EF), Color(0xFFFFEDFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 69,
                  height: 69,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 45,
                    color: Color(0xFF929292),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Fery',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            color: const Color(0xFFFFFAFC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Private Information',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFCE9FC), Color(0xFFFFE9ED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileField(
                        label: 'Nama',
                        value: 'Feri Bagus Riadi',
                        icon: Icons.account_circle_outlined,
                      ),
                      SizedBox(height: 13),
                      ProfileField(
                        label: 'Email',
                        value: 'feribagus02@gmail.com',
                        icon: Icons.mail_outline,
                      ),
                      SizedBox(height: 13),
                      ProfileField(
                        label: 'Password',
                        value: '**************',
                        icon: Icons.key_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(label, style: const TextStyle(fontSize: 11)),
        ),
        Container(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              Icon(icon, size: 25, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// HALAMAN SEMENTARA

class SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;

  const SimplePage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 65, color: pink),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
