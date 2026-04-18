import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';

// ── Data Models ──
class MenuItem {
  final String title;
  final String subtitle;
  final String price;
  final double priceValue;
  final String category;
  final ImageProvider image;
  final double rating;
  final int reviews;
  final String prepTime;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.priceValue,
    required this.category,
    required this.image,
    this.rating = 4.5,
    this.reviews = 320,
    this.prepTime = '20-25 minutes',
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  String cupSize;
  String milkOption;
  CartItem({required this.item, this.quantity = 1, this.cupSize = 'Medium', this.milkOption = 'Whole Milk'});
}

// ── Detail Screen ──
class ItemDetailScreen extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem, String, String) onAddToCart;

  const ItemDetailScreen({super.key, required this.item, required this.onAddToCart});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  String selectedSize = 'Medium';
  String selectedMilk = 'Whole Milk';
  bool isFavorite = false;
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<String> milkOptions = ['Skim Milk', 'Whole Milk', 'Oat Milk', 'Almond Milk', 'Soy Milk'];

  double get finalPrice {
    double base = widget.item.priceValue;
    if (selectedSize == 'Large') base += 1.0;
    if (selectedSize == 'Small') base -= 0.5;
    return base;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 320,
            width: double.infinity,
            color: Colors.black87,
            child: Image(
              image: widget.item.image,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isFavorite = !isFavorite),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: isFavorite ? Colors.red : Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18, color: isFavorite ? Colors.white : Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.55,
            maxChildSize: 0.85,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: 12),
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  SizedBox(height: 20),
                  Text(widget.item.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text('${widget.item.rating} (${widget.item.reviews})', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(widget.item.prepTime, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text('Cup Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    children: sizes.map((size) => Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedSize == size ? Colors.orange : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selectedSize == size ? Colors.orange : Colors.grey[300]!),
                          ),
                          child: Text(size, style: TextStyle(
                            color: selectedSize == size ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          )),
                        ),
                      ),
                    )).toList(),
                  ),
                  SizedBox(height: 24),
                  Text('Milk Options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMilk,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        items: milkOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                        onChanged: (v) => setState(() => selectedMilk = v!),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(widget.item.subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.6)),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  widget.onAddToCart(widget.item, selectedSize, selectedMilk);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${widget.item.title} added to cart!'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: Duration(seconds: 1),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      Container(width: 1, height: 20, color: Colors.white.withOpacity(0.5)),
                      SizedBox(width: 16),
                      Text('\$${finalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── QR Code Painter ──
class QRCodePainter extends CustomPainter {
  final String data;
  QRCodePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final rand = Random(data.hashCode);
    final cellSize = size.width / 25;

    void drawFinder(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cellSize * 7, cellSize * 7), paint);
      canvas.drawRect(Rect.fromLTWH(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5), Paint()..color = Colors.white);
      canvas.drawRect(Rect.fromLTWH(x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3), paint);
    }

    drawFinder(0, 0);
    drawFinder(size.width - cellSize * 7, 0);
    drawFinder(0, size.height - cellSize * 7);

    for (int row = 0; row < 25; row++) {
      for (int col = 0; col < 25; col++) {
        bool isFinderZone =
            (row < 8 && col < 8) ||
            (row < 8 && col > 16) ||
            (row > 16 && col < 8);
        if (!isFinderZone && rand.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(col * cellSize, row * cellSize, cellSize - 0.5, cellSize - 0.5),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Home Screen ──
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedCategoryIndex = 0;
  final ScrollController _categoryScrollController = ScrollController();
  final GlobalKey _cartIconKey = GlobalKey();
  List<CartItem> cartItems = [];
  OverlayEntry? _overlayEntry;

  final List<String> categories = ['All', 'Coffee', 'Tea', 'Juice', 'Cold Brew'];

  late List<MenuItem> allMenuItems;

  @override
  void initState() {
    super.initState();
    allMenuItems = [
      MenuItem(title: 'Cappuccino',      subtitle: 'Rich and creamy espresso with perfectly steamed frothy milk, a classic Italian coffee experience.', price: '\$4.99', priceValue: 4.99, category: 'Coffee',     image: AssetImage('assets/images/Cappuccino.jpg'),    rating: 4.8, reviews: 532, prepTime: '10-15 min'),
      MenuItem(title: 'Latte',           subtitle: 'Smooth and velvety espresso blended with steamed milk and a light layer of foam.',                   price: '\$5.49', priceValue: 5.49, category: 'Coffee',     image: AssetImage('assets/images/Latte.jpg'),         rating: 4.6, reviews: 410, prepTime: '10-15 min'),
      MenuItem(title: 'Espresso',        subtitle: 'Intense and bold, delivering a concentrated burst of coffee flavor in every sip.',                   price: '\$3.99', priceValue: 3.99, category: 'Coffee',     image: AssetImage('assets/images/Espresso.jpg'),      rating: 4.7, reviews: 289, prepTime: '5-10 min'),
      MenuItem(title: 'Latte Machiato',  subtitle: 'Layers of steamed milk and bold espresso creating a beautiful visual and rich taste.',               price: '\$5.99', priceValue: 5.99, category: 'Coffee',     image: AssetImage('assets/images/LatteMachiato.jpg'), rating: 4.6, reviews: 532, prepTime: '25-30 min'),
      MenuItem(title: 'Green Tea',       subtitle: 'Fresh and light Japanese green tea with a clean, earthy flavor profile.',                           price: '\$3.49', priceValue: 3.49, category: 'Tea',        image: AssetImage('assets/images/GreenTea.jpg'),      rating: 4.4, reviews: 201, prepTime: '5-8 min'),
      MenuItem(title: 'Chai Latte',      subtitle: 'Aromatic spiced tea blended with creamy steamed milk for a warming experience.',                     price: '\$4.49', priceValue: 4.49, category: 'Tea',        image: AssetImage('assets/images/ChaiLatte.jpg'),     rating: 4.5, reviews: 318, prepTime: '10-12 min'),
      MenuItem(title: 'Orange Juice',    subtitle: 'Freshly squeezed oranges packed with vitamins for a refreshing citrus burst.',                       price: '\$3.99', priceValue: 3.99, category: 'Juice',      image: AssetImage('assets/images/OrangeJuice.png'),   rating: 4.3, reviews: 175, prepTime: '5 min'),
      MenuItem(title: 'Mango Juice',     subtitle: 'Sweet tropical mango blend, smooth and naturally sweet with no added sugar.',                       price: '\$4.29', priceValue: 4.29, category: 'Juice',      image: AssetImage('assets/images/MangoJuice.jpg'),    rating: 4.6, reviews: 220, prepTime: '5 min'),
      MenuItem(title: 'Cold Brew',       subtitle: 'Slow-steeped for 12 hours creating an exceptionally smooth and bold cold coffee.',                   price: '\$5.99', priceValue: 5.99, category: 'Cold Brew', image: AssetImage('assets/images/coffee.png'),        rating: 4.9, reviews: 641, prepTime: '2 min'),
      MenuItem(title: 'Honey Cold Brew', subtitle: 'Our signature cold brew topped with honey and almond milk for natural sweetness.',                   price: '\$6.49', priceValue: 6.49, category: 'Cold Brew', image: AssetImage('assets/images/coffee.png'),        rating: 4.8, reviews: 389, prepTime: '2-3 min'),
    ];
  }

  List<MenuItem> get filteredItems {
    if (selectedCategoryIndex == 0) return allMenuItems;
    return allMenuItems.where((e) => e.category == categories[selectedCategoryIndex]).toList();
  }

  int get cartCount => cartItems.fold(0, (s, e) => s + e.quantity);
  double get cartTotal => cartItems.fold(0.0, (s, e) => s + e.item.priceValue * e.quantity);

  void _addToCart(MenuItem item, String size, String milk) {
    setState(() {
      final existing = cartItems.where((e) => e.item.title == item.title && e.cupSize == size && e.milkOption == milk);
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        cartItems.add(CartItem(item: item, cupSize: size, milkOption: milk));
      }
    });
  }

  void _addToCartWithAnimation(MenuItem item, Offset pos) {
    _addToCart(item, 'Medium', 'Whole Milk');
    _flyToCart(pos);
  }

  void _flyToCart(Offset startOffset) {
    final cartBox = _cartIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartBox == null) return;
    final cartPos = cartBox.localToGlobal(Offset.zero);
    final endOffset = Offset(cartPos.dx + 20, cartPos.dy + 20);

    final controller = AnimationController(vsync: this, duration: Duration(milliseconds: 650));
    final animation = Tween<Offset>(begin: startOffset, end: endOffset).animate(CurvedAnimation(parent: controller, curve: Curves.easeInBack));
    final fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: controller, curve: Interval(0.65, 1.0)));

    _overlayEntry = OverlayEntry(
      builder: (ctx) => AnimatedBuilder(
        animation: controller,
        builder: (ctx, _) => Positioned(
          left: animation.value.dx,
          top: animation.value.dy,
          child: FadeTransition(
            opacity: fadeAnim,
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              child: Icon(Icons.local_cafe, color: Colors.white, size: 14),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    controller.forward().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      controller.dispose();
    });
  }

  void _openDetail(MenuItem item) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ItemDetailScreen(
          item: item,
          onAddToCart: (item, size, milk) {
            setState(() {
              final existing = cartItems.where((e) => e.item.title == item.title && e.cupSize == size && e.milkOption == milk);
              if (existing.isNotEmpty) {
                existing.first.quantity++;
              } else {
                cartItems.add(CartItem(item: item, cupSize: size, milkOption: milk));
              }
            });
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.92,
          builder: (ctx, sc) => Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Your Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Spacer(),
                    if (cartItems.isNotEmpty)
                      TextButton(
                        onPressed: () => setModal(() => setState(() => cartItems.clear())),
                        child: Text('Clear all', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                          SizedBox(height: 12),
                          Text('Your cart is empty', style: TextStyle(color: Colors.grey)),
                        ]))
                      : ListView.builder(
                          controller: sc,
                          itemCount: cartItems.length,
                          itemBuilder: (ctx, i) {
                            final c = cartItems[i];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: c.item.image, width: 60, height: 60, fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(c.item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('${c.cupSize} • ${c.milkOption}', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text(c.item.price, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                                  ])),
                                  Row(children: [
                                    GestureDetector(
                                      onTap: () => setModal(() => setState(() {
                                        if (c.quantity > 1) c.quantity--; else cartItems.removeAt(i);
                                      })),
                                      child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle), child: Icon(Icons.remove, size: 14)),
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('${c.quantity}', style: TextStyle(fontWeight: FontWeight.bold))),
                                    GestureDetector(
                                      onTap: () => setModal(() => setState(() => c.quantity++)),
                                      child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle), child: Icon(Icons.add, size: 14, color: Colors.white)),
                                    ),
                                  ]),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                if (cartItems.isNotEmpty) ...[
                  Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('\$${cartTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () { Navigator.pop(ctx); _showCheckout(); },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: Text('Checkout  •  \$${cartTotal.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ FIXED: QR is display-only. Confirm button closes sheet + shows success snackbar immediately.
  void _showCheckout() {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final qrData  = 'CAFE-ORDER:$orderId:TOTAL:${cartTotal.toStringAsFixed(2)}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (ctx, sc) => Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            children: [
              // drag handle
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 16),
              Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Expanded(
                child: ListView(controller: sc, children: [
                  // order items list
                  ...cartItems.map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(child: Text('${e.item.title} (${e.cupSize}) x${e.quantity}', overflow: TextOverflow.ellipsis)),
                      Text('\$${(e.item.priceValue * e.quantity).toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                    ]),
                  )),
                  Divider(height: 28),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('\$${cartTotal.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 28),

                  // QR — display only, no scan required
                  Center(child: Text('Scan to Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  SizedBox(height: 4),
                  Center(child: Text('Show this QR code at the counter', style: TextStyle(color: Colors.grey, fontSize: 13))),
                  SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
                      ),
                      child: Column(children: [
                        CustomPaint(size: Size(180, 180), painter: QRCodePainter(qrData)),
                        SizedBox(height: 10),
                        Text(orderId, style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.2)),
                      ]),
                    ),
                  ),
                  SizedBox(height: 28),
                ]),
              ),

              // Confirm button: close sheet → clear cart → show green snackbar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);                     // close checkout sheet
                    setState(() => cartItems.clear());      // clear cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Expanded(child: Text('Order $orderId placed successfully!')),
                        ]),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Confirm & Place Order',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Hello, Samnang', style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('What coffee would you like?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ]),
                      Spacer(),
                      GestureDetector(
                        onTap: _showCart,
                        child: Stack(
                          key: _cartIconKey,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4, offset: Offset(0, 2))]),
                              child: Icon(Icons.shopping_cart, color: Colors.grey),
                            ),
                            if (cartCount > 0) Positioned(
                              right: -4, top: -4,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: Text('$cartCount', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4, offset: Offset(0, 2))]),
                        child: CircleAvatar(radius: 20, backgroundColor: Colors.white, backgroundImage: AssetImage('assets/images/profile.png')),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Stack(clipBehavior: Clip.none, children: [
                      Container(
                        padding: EdgeInsets.all(20), height: 220,
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          SizedBox(width: 20),
                          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Discover a world of coffee delights', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('The finest of flavours', style: TextStyle(color: Colors.white, fontSize: 13)),
                            SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                              child: Text('Try to test', style: TextStyle(color: Colors.black)),
                            ),
                          ])),
                          SizedBox(width: 150),
                        ]),
                      ),
                      Positioned(right: 10, top: -40, child: Image.asset('assets/images/cafe.webp', width: 160, height: 240, fit: BoxFit.contain)),
                    ]),

                    SizedBox(height: 28),
                    _SectionHeader('Beverages', 'View All'),
                    SizedBox(height: 16),

                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                      child: SingleChildScrollView(
                        controller: _categoryScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(categories.length, (i) {
                            const categoryImages = {
                              'All':       'assets/images/coffee.png',
                              'Coffee':    'assets/images/cafe.webp',
                              'Tea':       'assets/images/GreenTea.jpg',
                              'Juice':     'assets/images/OrangeJuice.png',
                              'Cold Brew': 'assets/images/coffee.png',
                            };
                            final imagePath = categoryImages[categories[i]] ?? 'assets/images/coffee.png';
                            return _BuildCategoryCard(AssetImage(imagePath), categories[i], i);
                          }),
                        ),
                      ),
                    ),

                    SizedBox(height: 28),
                    _SectionHeader('Popular Drinks', 'View All'),
                    SizedBox(height: 16),

                    ...filteredItems.map((item) => _BuildMenuCard(item)),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SectionHeader(String title, String action) => Row(children: [
    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    Spacer(),
    Text(action, style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.orange, color: Colors.orange, fontSize: 14)),
  ]);

  Widget _BuildCategoryCard(ImageProvider image, String title, int index) {
    final isSelected = index == selectedCategoryIndex;
    return GestureDetector(
      onTap: () => setState(() => selectedCategoryIndex = index),
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 220),
          padding: EdgeInsets.only(right: 12),
          height: 35,
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Color.fromARGB(255, 226, 240, 252),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 29, height: 29,
              margin: EdgeInsets.only(left: 3),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 2))]),
              child: CircleAvatar(radius: 20, backgroundColor: Colors.white, backgroundImage: image),
            ),
            SizedBox(width: 8),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }

  Widget _BuildMenuCard(MenuItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _openDetail(item),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: 'item-${item.title}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 85, height: 100,
                child: Image(image: item.image, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 4),
            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 3),
            Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(item.price, style: TextStyle(fontSize: 15, color: Colors.orange, fontWeight: FontWeight.bold)),
              Builder(builder: (btnCtx) => GestureDetector(
                onTap: () {
                  final box = btnCtx.findRenderObject() as RenderBox;
                  _addToCartWithAnimation(item, box.localToGlobal(Offset.zero));
                },
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  child: Icon(Icons.add, color: Colors.white, size: 18),
                ),
              )),
            ]),
          ])),
        ]),
      ),
    );
  }
}