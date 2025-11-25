import 'package:flutter/material.dart';

void main() {
  runApp(PropertyPulseApp());
}

class PropertyPulseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PropertyPulse",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0E11),
        primaryColor: Colors.blueAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Color(0xFFFFD700),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101419),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

/* --------------------------------------------------------------------------
 * Splash Screen
 * ------------------------------------------------------------------------ */

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300),
        () => setState(() => opacity = 1));

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.house_rounded,
                  color: Color(0xFFFFD700), size: 84),
              SizedBox(height: 12),
              Text(
                'PropertyPulse',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------------
 * Login & Signup (Dummy)
 * ------------------------------------------------------------------------ */

class LoginScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _inputField("Email", email),
            const SizedBox(height: 12),
            _inputField("Password", pass, isPass: true),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => MainBottomNav()));
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SignupScreen()));
              },
              child:
                  const Text("Create an account", style: TextStyle(color: Color(0xFFFFD700))),
            )
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _inputField("Full Name", name),
            const SizedBox(height: 10),
            _inputField("Email", email),
            const SizedBox(height: 10),
            _inputField("Password", pass, isPass: true),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => MainBottomNav()));
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _inputField(String label, TextEditingController c,
    {bool isPass = false}) {
  return TextField(
    controller: c,
    obscureText: isPass,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFFFD700)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFD700))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent)),
      filled: true,
      fillColor: const Color(0xFF111417),
    ),
  );
}

/* --------------------------------------------------------------------------
 * Bottom Navigation
 * ------------------------------------------------------------------------ */

class MainBottomNav extends StatefulWidget {
  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int index = 0;
  List<Property> favorites = [];

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        favorites: favorites,
        onFavToggle: _toggleFav,
      ),
      FavoritesScreen(favorites: favorites),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF101419),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void _toggleFav(Property p) {
    setState(() {
      if (favorites.contains(p)) favorites.remove(p);
      else favorites.add(p);
    });
  }
}

/* --------------------------------------------------------------------------
 * Property Model & Data
 * ------------------------------------------------------------------------ */

class Property {
  final String id, title, location, type, image, description;
  final int price;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.type,
    required this.image,
    required this.price,
    required this.description,
  });
}

class PropertyDB {
  static List<Property> getAll() {
    return [
      Property(
        id: "p1",
        title: "Luxury Penthouse",
        price: 1200000,
        location: "New York, NY",
        type: "Condo",
        image: "https://via.placeholder.com/600x400.png?text=Penthouse",
        description: "Luxury penthouse with rooftop view.",
      ),
      Property(
        id: "p2",
        title: "Modern 3BR Condo",
        price: 650000,
        location: "Los Angeles, CA",
        type: "Condo",
        image: "https://via.placeholder.com/600x400.png?text=Condo",
        description: "Spacious 3 bedroom modern condo.",
      ),
      Property(
        id: "p3",
        title: "Cozy Studio",
        price: 220000,
        location: "Miami, FL",
        type: "Studio",
        image: "https://via.placeholder.com/600x400.png?text=Studio",
        description: "Affordable studio apartment near downtown.",
      ),
      Property(
        id: "p4",
        title: "Family Villa",
        price: 850000,
        location: "Dallas, TX",
        type: "Villa",
        image: "https://via.placeholder.com/600x400.png?text=Villa",
        description: "Large villa with spacious backyard.",
      ),
    ];
  }
}

/* --------------------------------------------------------------------------
 * Home Screen (Search + Filters + List)
 * ------------------------------------------------------------------------ */

class HomeScreen extends StatefulWidget {
  final List<Property> favorites;
  final Function(Property) onFavToggle;

  HomeScreen({required this.favorites, required this.onFavToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Property> all = PropertyDB.getAll();
  List<Property> shown = [];

  String search = "";
  String selectedLocation = "All";
  String selectedType = "All";
  String priceFilter = "Any";

  final locations = ["All", "New York, NY", "Los Angeles, CA", "Miami, FL", "Dallas, TX"];
  final types = ["All", "Apartment", "Condo", "Villa", "Studio"];
  final priceRanges = ["Any", "Low <300k", "Mid 300k-700k", "High >700k"];

  @override
  void initState() {
    super.initState();
    shown = all;
  }

  void applyFilters() {
    setState(() {
      shown = all.where((p) {
        final matchSearch =
            search.isEmpty ||
            p.title.toLowerCase().contains(search.toLowerCase()) ||
            p.location.toLowerCase().contains(search.toLowerCase());

        final matchLocation =
            selectedLocation == "All" || p.location == selectedLocation;

        final matchType = selectedType == "All" || p.type == selectedType;

        bool matchPrice = true;
        if (priceFilter == "Low <300k") {
          matchPrice = p.price < 300000;
        } else if (priceFilter == "Mid 300k-700k") {
          matchPrice = p.price >= 300000 && p.price <= 700000;
        } else if (priceFilter == "High >700k") {
          matchPrice = p.price > 700000;
        }

        return matchSearch && matchLocation && matchType && matchPrice;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      search = "";
      selectedLocation = "All";
      selectedType = "All";
      priceFilter = "Any";
      shown = all;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PropertyPulse"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: clearFilters,
          )
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (v) {
                search = v;
                applyFilters();
              },
              decoration: InputDecoration(
                hintText: "Search by title or city...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFFD700)),
                filled: true,
                fillColor: const Color(0xFF0F1418),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFFFD700))),
              ),
            ),
          ),

          // FILTERS ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: priceFilter,
                    items: priceRanges
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) {
                      priceFilter = v.toString();
                      applyFilters();
                    },
                    dropdownColor: const Color(0xFF101419),
                    decoration: _filterDecoration("Price"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField(
                    value: selectedLocation,
                    items: locations
                        .map((loc) =>
                            DropdownMenuItem(value: loc, child: Text(loc)))
                        .toList(),
                    onChanged: (v) {
                      selectedLocation = v.toString();
                      applyFilters();
                    },
                    dropdownColor: const Color(0xFF101419),
                    decoration: _filterDecoration("Location"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // PROPERTY TYPE FILTER
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              itemBuilder: (context, index) {
                final type = types[index];
                final selected = type == selectedType;

                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  selectedColor: const Color(0xFF16202A),
                  backgroundColor: const Color(0xFF0F1418),
                  side: const BorderSide(color: Color(0xFFFFD700)),
                  labelStyle: TextStyle(
                      color: selected ? Colors.blueAccent : Color(0xFFFFD700)),
                  onSelected: (_) {
                    selectedType = type;
                    applyFilters();
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 10),
            ),
          ),

          const SizedBox(height: 10),

          // LIST
          Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text(
                      "No properties match",
                      style: TextStyle(color: Color(0xFFFFD700)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final p = shown[index];
                      final isFav = widget.favorites.contains(p);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(
                                p: p,
                                isFav: isFav,
                                onFav: widget.onFavToggle,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          color: const Color(0xFF14181F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                                color: Color(0xFFFFD700), width: 1),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  bottomLeft: Radius.circular(14),
                                ),
                                child: Image.network(
                                  p.image,
                                  width: 140,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: const TextStyle(
                                          color: Color(0xFFFFD700),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "\$${_formatPrice(p.price)} • ${p.location}",
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(p.type,
                                              style: const TextStyle(
                                                  color: Colors.white54)),
                                          IconButton(
                                            icon: Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFav
                                                  ? Colors.red
                                                  : Colors.white70,
                                            ),
                                            onPressed: () {
                                              widget.onFavToggle(p);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

InputDecoration _filterDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFFFFD700)),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFD700)),
    ),
    filled: true,
    fillColor: const Color(0xFF0F1418),
  );
}

String _formatPrice(int price) {
  if (price >= 1000000) return "${(price / 1000000).toStringAsFixed(1)}M";
  if (price >= 1000) return "${(price / 1000).toStringAsFixed(0)}k";
  return price.toString();
}

/* --------------------------------------------------------------------------
 * Details Screen
 * ------------------------------------------------------------------------ */

class DetailsScreen extends StatelessWidget {
  final Property p;
  final bool isFav;
  final Function(Property) onFav;

  DetailsScreen({required this.p, required this.isFav, required this.onFav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.redAccent : Colors.white70,
            ),
            onPressed: () => onFav(p),
          )
        ],
      ),
      body: ListView(
        children: [
          Image.network(
            p.image,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${_formatPrice(p.price)} • ${p.location}",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Text(
                  p.description,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Schedule Visit (UI Only)"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming soon")),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

/* --------------------------------------------------------------------------
 * Favorites Screen
 * ------------------------------------------------------------------------ */

class FavoritesScreen extends StatelessWidget {
  final List<Property> favorites;

  FavoritesScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(color: Color(0xFFFFD700)),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final p = favorites[index];
                return ListTile(
                  leading: Image.network(
                    p.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    p.title,
                    style: const TextStyle(color: Color(0xFFFFD700)),
                  ),
                  subtitle: Text(
                    "\$${_formatPrice(p.price)} • ${p.location}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
    );
  }
}

/* --------------------------------------------------------------------------
 * Profile Screen
 * ------------------------------------------------------------------------ */

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          children: const [
            SizedBox(height: 40),
            CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFFFD700),
              child: Icon(Icons.person, size: 55, color: Colors.black),
            ),
            SizedBox(height: 12),
            Text(
              "John Doe",
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "johndoe@example.com",
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}