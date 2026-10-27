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

class CartItem {
  final String name;
  final String? price;
  final String? imageAsset;
  final String? category;
  final int quantity;

  const CartItem({
    required this.name,
    this.price,
    this.imageAsset,
    this.category,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      name: name,
      price: price,
      imageAsset: imageAsset,
      category: category,
      quantity: quantity ?? this.quantity,
    );
  }
}

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
      home: const WelcomePage(),
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
  final List<CartItem> cartItems = [];

  void _addToCart(CartItem item) {
    setState(() {
      final existingIndex = cartItems.indexWhere(
        (cartItem) => cartItem.name == item.name,
      );
      if (existingIndex == -1) {
        cartItems.add(item);
      } else {
        cartItems[existingIndex] = cartItems[existingIndex].copyWith(
          quantity: cartItems[existingIndex].quantity + 1,
        );
      }
      selectedIndex = 1;
    });
  }

  void _changeCartQuantity(String itemName, int change) {
    setState(() {
      final itemIndex = cartItems.indexWhere(
        (cartItem) => cartItem.name == itemName,
      );
      if (itemIndex == -1) return;

      final newQuantity = cartItems[itemIndex].quantity + change;
      if (newQuantity <= 0) {
        cartItems.removeAt(itemIndex);
      } else {
        cartItems[itemIndex] = cartItems[itemIndex].copyWith(
          quantity: newQuantity,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onAddToCart: _addToCart),
      CartPage(
        items: cartItems,
        onIncrease: (name) => _changeCartQuantity(name, 1),
        onDecrease: (name) => _changeCartQuantity(name, -1),
      ),
      const SimplePage(title: 'Ringkas', icon: Icons.auto_awesome_outlined),
      const HistoryPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.viewPaddingOf(context).top,
            child: ColoredBox(
              color: selectedIndex == 1
                  ? const Color(0xFFEABFE5)
                  : selectedIndex == 4
                  ? const Color(0xFFFFE6EF)
                  : const Color(0xFFFFF9FF),
            ),
          ),
          SafeArea(
            top: selectedIndex != 1 && selectedIndex != 4,
            bottom: false,
            child: IndexedStack(index: selectedIndex, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          16,
          10,
          16,
          MediaQuery.viewPaddingOf(context).bottom + 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, 'Beranda'),
            _navItem(1, 'Keranjang'),
            _navItem(2, 'Ringkas'),
            _navItem(3, 'Riwayat'),
            _navItem(4, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, String label) {
    final active = selectedIndex == index;
    final iconWidget = index == 2
        ? Container(
          width: 40,
          height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF858A94),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomPaint(
              size: const Size(30, 30),
              painter: NavIconPainter(index: index, color: Colors.white),
            ),
          )
        : CustomPaint(
            size: const Size(30, 30),
            painter: NavIconPainter(
              index: index,
              color: active ? Colors.redAccent : const Color(0xFF858A94),
            ),
          );

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40, child: Center(child: iconWidget)),
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

class NavIconPainter extends CustomPainter {
  final int index;
  final Color color;

  const NavIconPainter({required this.index, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (index) {
      case 0:
        final home = Path()
          ..moveTo(4.5, 10)
          ..lineTo(10.5, 5)
          ..quadraticBezierTo(12, 3.8, 13.5, 5)
          ..lineTo(19.5, 10)
          ..lineTo(19.5, 16.5)
          ..quadraticBezierTo(19.5, 19.5, 16.5, 19.5)
          ..lineTo(7.5, 19.5)
          ..quadraticBezierTo(4.5, 19.5, 4.5, 16.5)
          ..close();
        canvas.drawPath(home, stroke);
        canvas.drawLine(const Offset(12, 15), const Offset(12, 19), stroke);
      case 1:
        final cart = Path()
          ..moveTo(3, 5)
          ..lineTo(5.2, 5)
          ..lineTo(7.3, 15.3)
          ..quadraticBezierTo(7.6, 16.5, 9, 16.5)
          ..lineTo(18, 16.5)
          ..quadraticBezierTo(19.2, 16.5, 19.6, 15.2)
          ..lineTo(21, 8)
          ..lineTo(6, 8);
        canvas.drawPath(cart, stroke);
        canvas.drawCircle(const Offset(9.5, 20), 1.2, stroke);
        canvas.drawCircle(const Offset(17.5, 20), 1.2, stroke);
      case 2:
        final sparkle = Path()
          ..moveTo(12, 3.5)
          ..lineTo(14, 10)
          ..lineTo(20.5, 12)
          ..lineTo(14, 14)
          ..lineTo(12, 20.5)
          ..lineTo(10, 14)
          ..lineTo(3.5, 12)
          ..lineTo(10, 10)
          ..close();
        canvas.drawPath(sparkle, stroke);
        canvas.drawLine(const Offset(18.5, 4), const Offset(18.5, 7), stroke);
        canvas.drawLine(const Offset(17, 5.5), const Offset(20, 5.5), stroke);
      case 3:
        canvas.drawCircle(const Offset(12, 12), 8.5, stroke);
        canvas.drawLine(const Offset(12, 7), const Offset(12, 12), stroke);
        canvas.drawLine(const Offset(12, 12), const Offset(16, 14), stroke);
      case 4:
        canvas.drawCircle(const Offset(12, 7.5), 3.2, stroke);
        final shoulders = Path()
          ..moveTo(4.5, 20)
          ..quadraticBezierTo(4.8, 14.5, 12, 14.5)
          ..quadraticBezierTo(19.2, 14.5, 19.5, 20);
        canvas.drawPath(shoulders, stroke);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant NavIconPainter oldDelegate) {
    return oldDelegate.index != index || oldDelegate.color != color;
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FF),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        children: [
          if (showSearch) ...[
            const SizedBox(height: 9),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Melayani', style: TextStyle(fontSize: 9, color: muted)),
                SizedBox(width: 8),
                CircleDot(color: pink),
                SizedBox(width: 5),
                Text('Pickup', style: TextStyle(fontSize: 9)),
                SizedBox(width: 8),
                CircleDot(color: Colors.orange),
                SizedBox(width: 5),
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
  final ValueChanged<CartItem> onAddToCart;

  const HomePage({super.key, required this.onAddToCart});

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

  final List<String> categoryImages = const [
    'assets/ikon/ikonseserahan.png',
    'assets/ikon/ikonhampers.png',
    'assets/ikon/ikonmahar.png',
    'assets/ikon/ikonkotakcincin.png',
    'assets/ikon/ikonsouvenir.png',
  ];

  final List<String> products = const [
    'Facial wash',
    'Body lotion',
    'Alat sholat',
    'Cincin',
    'Bunga segar',
  ];

  final List<String> productImages = const [
    'assets/barang/facialwash.png',
    'assets/barang/bodylotion.png',
    'assets/barang/alatsholat.png',
    'assets/barang/cincin.png',
    'assets/barang/bungasegar.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(),
          SizedBox(
            height: 198,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: PageView.builder(
                      controller: _bannerController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bannerImages.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          bannerImages[index],
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 134,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(categories.length, (index) {
                      return SizedBox(
                        width: 62,
                        height: 60,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                categoryImages[index],
                                width: 34,
                                height: 34,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                categories[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Promo Bulan Ini'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 112,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PromoCard(
                        category: 'Seserahan',
                        title: 'Seserahan Pernikahan Aesthetic',
                        price: 'Rp 150.000',
                        imageAsset: 'assets/promo/promoseserahan.png',
                        onBuy: () => widget.onAddToCart(
                          const CartItem(
                            name: 'Seserahan Pernikahan Aesthetic',
                            price: 'Rp 150.000',
                            imageAsset: 'assets/promo/promoseserahan.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      PromoCard(
                        category: 'Hampers',
                        title: 'Hampers Pernikahan Premium',
                        price: 'Rp 350.000',
                        onBuy: () => widget.onAddToCart(
                          const CartItem(
                            name: 'Hampers Pernikahan Premium',
                            price: 'Rp 350.000',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const SectionTitle(title: 'Pilih barang'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 84,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 9),
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => widget.onAddToCart(
                            CartItem(
                              name: products[index],
                              imageAsset: productImages[index],
                            ),
                          ),
                          child: Container(
                            width: 66,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    productImages[index],
                                    width: 56,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                  products[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          ),
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
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
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
                              Text(
                                'Mulai rangkai',
                                style: TextStyle(fontSize: 10),
                              ),
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
  final String category;
  final String title;
  final String price;
  final String? imageAsset;
  final VoidCallback onBuy;

  const PromoCard({
    super.key,
    required this.category,
    required this.title,
    required this.price,
    required this.onBuy,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 112,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: pink, fontSize: 9),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 28,
                  child: OutlinedButton(
                    onPressed: onBuy,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 28),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
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
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: imageAsset == null
                ? Container(
                    width: 76,
                    height: 96,
                    color: const Color(0xFFFFF4FC),
                    child: const Icon(
                      Icons.card_giftcard,
                      size: 37,
                      color: Color(0xFFC6A58D),
                    ),
                  )
                : Image.asset(
                    imageAsset!,
                    width: 72,
                    height: 92,
                    fit: BoxFit.contain,
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
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkPink,
                                ),
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
                                      setState(
                                        () => _ratings[entry.key] = rating,
                                      );
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

// PROFIL

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(1, 0, 1, 20),
        child: Column(
          children: [
          Container(
            height: 220,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.viewPaddingOf(context).top + 10,
              20,
              20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE6EF), Color(0xFFFFEDFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
                Text(
                  DemoAccount.name ?? 'Pengguna',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileField(
                        label: 'Nama',
                        value: DemoAccount.name ?? '-',
                        icon: Icons.account_circle_outlined,
                      ),
                      SizedBox(height: 13),
                      ProfileField(
                        label: 'Email',
                        value: DemoAccount.email ?? '-',
                        icon: Icons.mail_outline,
                      ),
                      SizedBox(height: 13),
                      ProfileField(
                        label: 'Nomor Telepon',
                        value: DemoAccount.phone ?? '-',
                        icon: Icons.phone_outlined,
                      ),
                      SizedBox(height: 13),
                      ProfileField(
                        label: 'Password',
                        value: '********',
                        icon: Icons.key_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                  (route) => false,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          ],
        ),
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

// KATALOG KERANJANG

class CartPage extends StatefulWidget {
  final List<CartItem> items;
  final ValueChanged<String> onIncrease;
  final ValueChanged<String> onDecrease;

  const CartPage({
    super.key,
    required this.items,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const List<CartItem> _products = [
    CartItem(
      name: 'Seserahan Alat Sholat',
      price: 'Rp 230.000',
      imageAsset: 'assets/barang/alatsholat.png',
      category: 'Seserahan',
    ),
    CartItem(
      name: 'Seserahan Sepatu dan Tas',
      price: 'Rp 370.000',
      imageAsset: 'assets/ikon/ikonseserahan.png',
      category: 'Seserahan',
    ),
    CartItem(
      name: 'Seserahan Pernikahan Aesthetic',
      price: 'Rp 150.000',
      imageAsset: 'assets/promo/promoseserahan.png',
      category: 'Seserahan',
    ),
    CartItem(
      name: 'Hampers Pernikahan Premium',
      price: 'Rp 350.000',
      imageAsset: 'assets/ikon/ikonhampers.png',
      category: 'Hampers',
    ),
    CartItem(
      name: 'Hampers Bunga Segar',
      price: 'Rp 230.000',
      imageAsset: 'assets/barang/bungasegar.png',
      category: 'Hampers',
    ),
    CartItem(
      name: 'Hampers Perawatan Diri',
      price: 'Rp 140.000',
      imageAsset: 'assets/barang/bodylotion.png',
      category: 'Hampers',
    ),
    CartItem(
      name: 'Paket Facial Wash',
      price: 'Rp 110.000',
      imageAsset: 'assets/barang/facialwash.png',
      category: 'Barang',
    ),
    CartItem(
      name: 'Cincin Pernikahan',
      price: 'Rp 3.000.000',
      imageAsset: 'assets/barang/cincin.png',
      category: 'Barang',
    ),
  ];

  static const List<Map<String, String>> _categories = [
    {'name': 'Seserahan', 'image': 'assets/ikon/ikonseserahan.png'},
    {'name': 'Hampers', 'image': 'assets/ikon/ikonhampers.png'},
    {'name': 'Mahar', 'image': 'assets/ikon/ikonmahar.png'},
    {'name': 'Kotak Cincin', 'image': 'assets/ikon/ikonkotakcincin.png'},
    {'name': 'Souvenir', 'image': 'assets/ikon/ikonsouvenir.png'},
  ];

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final visibleProducts = _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Semua' ||
          product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD8C8D4)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                  items: [
                    'Semua',
                    'Seserahan',
                    'Hampers',
                    'Barang',
                  ].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (category) {
                    if (category != null) {
                      setState(() => _selectedCategory = category);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              overscroll: false,
            ),
            child: GridView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 16),
              itemCount: visibleProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.79,
              ),
              itemBuilder: (context, index) {
                final product = visibleProducts[index];
                final matchingItems = widget.items.where(
                  (item) => item.name == product.name,
                );
                final quantity = matchingItems.isEmpty
                    ? 0
                    : matchingItems.first.quantity;
                return _buildProductCard(product, quantity);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        MediaQuery.viewPaddingOf(context).top + 2,
        14,
        12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEABFE5), Color(0xFFDFAFD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        children: [
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: muted, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(fontSize: 10),
                    decoration: const InputDecoration(
                      hintText: 'Cari seserahan, souvenir, parcel dan lain lain',
                      hintStyle: TextStyle(fontSize: 9, color: muted),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Text('Melayani', style: TextStyle(fontSize: 8, color: muted)),
              SizedBox(width: 7),
              CircleDot(color: pink),
              SizedBox(width: 4),
              Text('Pickup', style: TextStyle(fontSize: 8)),
              SizedBox(width: 7),
              CircleDot(color: Colors.orange),
              SizedBox(width: 4),
              Text('Delivery', style: TextStyle(fontSize: 8)),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _categories.map((category) {
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      final name = category['name']!;
                      setState(() {
                        _selectedCategory = name == 'Mahar' ||
                                name == 'Kotak Cincin' ||
                                name == 'Souvenir'
                            ? 'Barang'
                            : name;
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            category['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          category['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(CartItem product, int quantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image.asset(
                  product.imageAsset!,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 3,
                child: quantity == 0
                    ? _quantityButton(
                        icon: Icons.add,
                        tooltip: 'Tambah ${product.name}',
                        onPressed: () => widget.onIncrease(product.name),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: darkPink,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _quantityButton(
                              icon: Icons.remove,
                              tooltip: 'Kurangi ${product.name}',
                              onPressed: () => widget.onDecrease(product.name),
                              small: true,
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _quantityButton(
                              icon: Icons.add,
                              tooltip: 'Tambah ${product.name}',
                              onPressed: () => widget.onIncrease(product.name),
                              small: true,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 9),
        ),
        Text(
          product.price!,
          maxLines: 1,
          style: const TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool small = false,
  }) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints.tightFor(
        width: small ? 25 : 30,
        height: small ? 25 : 30,
      ),
      icon: Icon(
        icon,
        color: Colors.white,
        size: small ? 14 : 18,
      ),
    );
  }
}

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

// AUTHENTICATION UI (demo lokal; gunakan backend untuk autentikasi produksi)
class DemoAccount {
  static String? name;
  static String? email;
  static String? password;
  static String? phone;
}

const Color authBorder = Color(0xFFD49ACD);
const Color authButton = Color(0xFFCBA8C9);

class AuthShell extends StatelessWidget {
  final Widget child;
  final bool fullScreenGradient;
  const AuthShell({
    super.key,
    required this.child,
    this.fullScreenGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Container(
        decoration: fullScreenGradient
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF3D8F0), Color(0xFFFFFFFF)],
                ),
              )
            : null,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                width: double.infinity,
                decoration: fullScreenGradient
                    ? null
                    : const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(34),
                          bottom: Radius.circular(34),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFF3D8F0), Color(0xFFFFFFFF)],
                        ),
                      ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 35,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool secret;
  final bool canToggleVisibility;
  final TextInputType? keyboardType;
  const AuthInput({
    super.key,
    required this.label,
    required this.controller,
    this.secret = false,
    this.canToggleVisibility = false,
    this.keyboardType,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant AuthInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refresh);
      widget.controller.addListener(_refresh);
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.controller.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 45,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.secret && !_passwordVisible,
            keyboardType: widget.keyboardType,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 10,
              ),
              suffixIcon: widget.secret && widget.canToggleVisibility
                  ? IconButton(
                      tooltip: _passwordVisible
                          ? 'Sembunyikan password'
                          : 'Tampilkan password',
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 40,
                        height: 40,
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: filled ? authBorder : Colors.transparent,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: authBorder, width: 1.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AuthButton({super.key, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: authButton,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) => AuthShell(
    fullScreenGradient: true,
    child: Column(
      children: [
        const SizedBox(height: 24),
        Image.asset(
          'assets/Parcelin.png',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 18),
        const Text(
          'Hello, Welcome !',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Selamat datang di Parcel.in. Siap membantu anda dalam berbagi kebahagiaan di setiap momen spesial',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 36),
        AuthButton(
          label: 'Login',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          ),
        ),
        const SizedBox(height: 18),
        AuthButton(
          label: 'Sign up',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpPage()),
          ),
        ),
      ],
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi email dan password terlebih dahulu')),
      );
      return;
    }
    if (DemoAccount.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan daftar terlebih dahulu')),
      );
      return;
    }
    if (email.text.trim() != DemoAccount.email ||
        password.text != DemoAccount.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password salah')),
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    fullScreenGradient: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 75),
        const Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Login to continue',
          style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
        ),
        const SizedBox(height: 44),
        AuthInput(
          label: 'Email',
          controller: email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 29),
        AuthInput(
          label: 'Password',
          controller: password,
          secret: true,
          canToggleVisibility: true,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur reset password memerlukan backend'),
              ),
            ),
            child: const Text(
              'Forget password?',
              style: TextStyle(fontSize: 11, color: Color(0xFF555555)),
            ),
          ),
        ),
        const SizedBox(height: 26),
        AuthButton(label: 'Login', onPressed: login),
        const SizedBox(height: 17),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 11),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpPage()),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    super.dispose();
  }

  void signup() {
    if ([name, email, password, phone].any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua kolom wajib diisi')));
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.text.trim())) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Format email tidak valid')));
      return;
    }
    DemoAccount.name = name.text.trim();
    DemoAccount.email = email.text.trim();
    DemoAccount.password = password.text;
    DemoAccount.phone = phone.text.trim();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    fullScreenGradient: true,
    child: Column(
      children: [
        const SizedBox(height: 45),
        const Text(
          'Create Account Now!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 38),
        AuthInput(label: 'Full Name', controller: name),
        const SizedBox(height: 17),
        AuthInput(
          label: 'Email',
          controller: email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 17),
        AuthInput(label: 'Password', controller: password, secret: true),
        const SizedBox(height: 17),
        AuthInput(
          label: 'Phone Number',
          controller: phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 28),
        AuthButton(label: 'Save & Login', onPressed: signup),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: OutlinedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF555555),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Kembali ke Login',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}
