import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(PropertyPulseApp());
}

/*
  Phase 6 - Single-file app (modified)
  - Dark theme (Blue + Gold)
  - Splash -> Login (dummy) -> Mode Selection (every login)
  - Buyer Mode: BottomNav (Home, Favorites, Profile)
  - Seller Mode: Seller Dashboard (Add Property, My Listings, Profile)
  - Shared in-memory repository for properties using ValueNotifier
  - Seller can add, edit, delete properties
  - Images removed; house emoji used instead
  - Contact buttons added (UI-only)
*/

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
  Simple in-memory repository for properties (shared between Buyer and Seller)
   - exposes ValueNotifier<List<Property>> so UI can listen for changes
----------------------------------------------------------------------------*/

class Property {
  final String id;
  String title;
  int price; // in USD
  String location;
  String type; // Apartment / Condo / Villa / Studio
  String imageUrl; // kept but not used in UI now
  String description;
  String ownerId; // simple owner marker; e.g., "seller_default"

  Property({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.ownerId,
  });

  Property copyWith({
    String? title,
    int? price,
    String? location,
    String? type,
    String? imageUrl,
    String? description,
    String? ownerId,
  }) {
    return Property(
      id: id,
      title: title ?? this.title,
      price: price ?? this.price,
      location: location ?? this.location,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}

class PropertyRepository {
  // Singleton
  PropertyRepository._privateConstructor() {
    // initialize with sample properties
    _properties.value = [
      Property(
        id: const Uuid().v4(),
        title: "Luxury Penthouse",
        price: 1200000,
        location: "New York, NY",
        type: "Condo",
        imageUrl: "",
        description: "Stunning penthouse in the heart of Manhattan.",
        ownerId: "system",
      ),
      Property(
        id: const Uuid().v4(),
        title: "Modern Townhome",
        price: 650000,
        location: "Los Angeles, CA",
        type: "Townhome",
        imageUrl: "",
        description: "Bright modern home close to downtown LA.",
        ownerId: "system",
      ),
      Property(
        id: const Uuid().v4(),
        title: "Cozy Studio",
        price: 220000,
        location: "Miami, FL",
        type: "Studio",
        imageUrl: "",
        description: "Compact and comfortable studio apartment.",
        ownerId: "system",
      ),
    ];
  }
  static final PropertyRepository _instance =
      PropertyRepository._privateConstructor();
  factory PropertyRepository() => _instance;

  // ValueNotifier so UI can listen to updates.
  final ValueNotifier<List<Property>> _properties =
      ValueNotifier<List<Property>>([]);

  ValueNotifier<List<Property>> get propertiesNotifier => _properties;

  List<Property> get properties => List.unmodifiable(_properties.value);

  void addProperty(Property p) {
    final list = List<Property>.from(_properties.value);
    list.insert(0, p);
    _properties.value = list;
  }

  void updateProperty(Property updated) {
    final list =
        _properties.value.map((p) => p.id == updated.id ? updated : p).toList();
    _properties.value = list;
  }

  void removeProperty(String id) {
    final list = _properties.value.where((p) => p.id != id).toList();
    _properties.value = list;
  }
}

/* --------------------------------------------------------------------------
  Splash -> Login -> ModeSelection
----------------------------------------------------------------------------*/

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(milliseconds: 300), () => setState(() => opacity = 1));
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
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
              Icon(Icons.house_rounded, color: Color(0xFFFFD700), size: 84),
              SizedBox(height: 12),
              Text("PropertyPulse",
                  style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  LoginScreen({super.key});

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
                    MaterialPageRoute(builder: (_) => ModeSelectionScreen()));
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignupScreen()));
              },
              child: const Text("Create an account",
                  style: TextStyle(color: Color(0xFFFFD700))),
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

  SignupScreen({super.key});

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
                    MaterialPageRoute(builder: (_) => ModeSelectionScreen()));
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------------
  Mode Selection Screen (appears after login every time)
----------------------------------------------------------------------------*/

class ModeSelectionScreen extends StatelessWidget {
  ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Mode")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text("Choose how you want to use PropertyPulse",
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("I'm a Buyer (Browse Properties)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A75FF),
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => MainBottomNav()));
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_business, color: Color(0xFFFFD700)),
              label: const Text("I'm a Seller (Add / Manage Properties)"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFFD700)),
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => SellerHome()));
              },
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: const Text("Back to Login",
                  style: TextStyle(color: Color(0xFFFFD700))),
            )
          ],
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------------
  Buyer Mode - Main Bottom Navigation (Home, Favorites, Profile)
----------------------------------------------------------------------------*/

class MainBottomNav extends StatefulWidget {
  MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int selectedIndex = 0;
  final List<Property> favorites = [];

  @override
  Widget build(BuildContext context) {
    final screens = [
      BuyerHome(onFavToggle: _toggleFav, favorites: favorites),
      FavoritesScreen(favorites: favorites),
      BuyerProfileScreen(),
    ];
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF101419),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        currentIndex: selectedIndex,
        onTap: (i) => setState(() => selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void _toggleFav(Property p) {
    setState(() {
      if (favorites.any((f) => f.id == p.id)) {
        favorites.removeWhere((f) => f.id == p.id);
      } else {
        favorites.add(p);
      }
    });
  }
}

/* ---------------- Buyer Home (search, filters, list) -------------------- */

class BuyerHome extends StatefulWidget {
  final Function(Property) onFavToggle;
  final List<Property> favorites;
  BuyerHome({required this.onFavToggle, required this.favorites, super.key});

  @override
  State<BuyerHome> createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  final repo = PropertyRepository();
  List<Property> shown = [];
  String search = "";
  String selectedLocation = "All";
  String selectedType = "All";
  String priceFilter = "Any";

  final locations = [
    "All",
    "New York, NY",
    "Los Angeles, CA",
    "Miami, FL",
    "Dallas, TX"
  ];
  final types = ["All", "Condo", "Townhome", "Studio", "Villa"];
  final priceRanges = ["Any", "Low <300k", "Mid 300k-700k", "High >700k"];

  @override
  void initState() {
    super.initState();
    shown = repo.properties;
    repo.propertiesNotifier.addListener(_onRepoUpdated);
  }

  @override
  void dispose() {
    repo.propertiesNotifier.removeListener(_onRepoUpdated);
    super.dispose();
  }

  void _onRepoUpdated() {
    applyFilters();
  }

  void applyFilters() {
    final all = repo.properties;
    setState(() {
      shown = all.where((p) {
        final matchSearch = search.isEmpty ||
            p.title.toLowerCase().contains(search.toLowerCase()) ||
            p.location.toLowerCase().contains(search.toLowerCase());
        final matchLocation =
            selectedLocation == "All" || p.location == selectedLocation;
        final matchType = selectedType == "All" || p.type == selectedType;
        bool matchPrice = true;
        if (priceFilter == "Low <300k") matchPrice = p.price < 300000;
        if (priceFilter == "Mid 300k-700k") {
          matchPrice = p.price >= 300000 && p.price <= 700000;
        }
        if (priceFilter == "High >700k") matchPrice = p.price > 700000;
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
    });
    applyFilters();
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
          // Search input
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
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFFD700))),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // Filters row
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
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
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

          const SizedBox(height: 8),

          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              itemBuilder: (context, index) {
                final t = types[index];
                final selected = t == selectedType;
                return ChoiceChip(
                  label: Text(t),
                  selected: selected,
                  selectedColor: const Color(0xFF16202A),
                  backgroundColor: const Color(0xFF0F1418),
                  side: const BorderSide(color: Color(0xFFFFD700)),
                  labelStyle: TextStyle(
                      color: selected
                          ? Colors.blueAccent
                          : const Color(0xFFFFD700)),
                  onSelected: (_) {
                    selectedType = t;
                    applyFilters();
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 10),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text("No properties found",
                        style: TextStyle(color: Color(0xFFFFD700))))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final p = shown[index];
                      final isFav = widget.favorites.any((f) => f.id == p.id);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PropertyDetailsScreen(
                                      property: p,
                                      isFav: isFav,
                                      onFavToggle: widget.onFavToggle)));
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          color: const Color(0xFF14181F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                  color: Color(0xFFFFD700), width: 1)),
                          child: Row(
                            children: [
                              // House emoji instead of image
                              Container(
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1F27),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "🏠",
                                  style: TextStyle(fontSize: 40),
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
                                        Text(p.title,
                                            style: const TextStyle(
                                                color: Color(0xFFFFD700),
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text(
                                            "\$${_formatPrice(p.price)} • ${p.location}",
                                            style: const TextStyle(
                                                color: Colors.white70)),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(p.type,
                                                style: const TextStyle(
                                                    color: Colors.white54)),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Contacting seller for ${p.title}')),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.message,
                                                    color: Color(0xFFFFD700),
                                                    size: 18,
                                                  ),
                                                  label: const Text(
                                                    'Contact',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFFD700),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      isFav
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: isFav
                                                          ? Colors.red
                                                          : Colors.white70),
                                                  onPressed: () =>
                                                      widget.onFavToggle(p),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
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

/* ---------------- Buyer: Details Screen ------------------------------- */

class PropertyDetailsScreen extends StatelessWidget {
  final Property property;
  final bool isFav;
  final Function(Property) onFavToggle;

  PropertyDetailsScreen(
      {required this.property,
      required this.isFav,
      required this.onFavToggle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.redAccent : Colors.white70),
            onPressed: () => onFavToggle(property),
          )
        ],
      ),
      body: ListView(
        children: [
          // House emoji header instead of image
          Container(
            height: 220,
            color: const Color(0xFF1A1F27),
            alignment: Alignment.center,
            child: const Text(
              "🏠",
              style: TextStyle(fontSize: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(property.title,
                  style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("\$${_formatPrice(property.price)} • ${property.location}",
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              Text(property.description,
                  style: const TextStyle(color: Colors.white70, height: 1.4)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text("Schedule Visit"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black),
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Scheduling"))),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text("Contact Seller"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Contacting seller for ${property.title}")),
                  );
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}

/* ---------------- Buyer: Favorites Screen ----------------------------- */

class FavoritesScreen extends StatelessWidget {
  final List<Property> favorites;
  FavoritesScreen({required this.favorites, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favorites.isEmpty
          ? const Center(
              child: Text("No favorites yet",
                  style: TextStyle(color: Color(0xFFFFD700))))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final p = favorites[index];
                return ListTile(
                  leading: const Text(
                    "🏠",
                    style: TextStyle(fontSize: 32),
                  ),
                  title: Text(p.title,
                      style: const TextStyle(color: Color(0xFFFFD700))),
                  subtitle: Text("\$${_formatPrice(p.price)} • ${p.location}",
                      style: const TextStyle(color: Colors.white70)),
                );
              },
            ),
    );
  }
}

/* ---------------- Buyer: Profile Screen ------------------------------- */

class BuyerProfileScreen extends StatelessWidget {
  BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFFFD700),
              child: Icon(Icons.person, size: 55, color: Colors.black)),
          const SizedBox(height: 12),
          const Text("John Doe",
              style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text("johndoe@example.com",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A75FF)),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            child: const Text("Logout"),
          )
        ]),
      ),
    );
  }
}

/* --------------------------------------------------------------------------
  Seller Mode - Seller Home (tabs: Add Property, My Listings, Profile)
----------------------------------------------------------------------------*/

class SellerHome extends StatefulWidget {
  SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SellerAddPropertyScreen(),
      SellerListingsScreen(),
      SellerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Seller Dashboard")),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF101419),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list), label: "My Listings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/* ---------------- Seller: Add Property Screen --------------------------- */

class SellerAddPropertyScreen extends StatefulWidget {
  SellerAddPropertyScreen({super.key});

  @override
  State<SellerAddPropertyScreen> createState() =>
      _SellerAddPropertyScreenState();
}

class _SellerAddPropertyScreenState extends State<SellerAddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  final repo = PropertyRepository();

  // if editing an existing property (null means create)
  Property? editing;

  void _resetForm() {
    titleCtrl.clear();
    priceCtrl.clear();
    locationCtrl.clear();
    typeCtrl.clear();
    imageCtrl.clear();
    descCtrl.clear();
    editing = null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final uuid = const Uuid().v4();
    if (editing == null) {
      final p = Property(
        id: uuid,
        title: titleCtrl.text.trim(),
        price: int.tryParse(priceCtrl.text.trim()) ?? 0,
        location: locationCtrl.text.trim(),
        type: typeCtrl.text.trim().isEmpty ? "Other" : typeCtrl.text.trim(),
        imageUrl: "", // not used in UI now
        description: descCtrl.text.trim(),
        ownerId: "seller_default",
      );
      repo.addProperty(p);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Property added')));
      _resetForm();
    } else {
      final updated = editing!.copyWith(
        title: titleCtrl.text.trim(),
        price: int.tryParse(priceCtrl.text.trim()) ?? editing!.price,
        location: locationCtrl.text.trim(),
        type:
            typeCtrl.text.trim().isEmpty ? editing!.type : typeCtrl.text.trim(),
        imageUrl: editing!.imageUrl,
        description: descCtrl.text.trim(),
      );
      repo.updateProperty(updated);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Property updated')));
      _resetForm();
    }
  }

  void startEdit(Property p) {
    setState(() {
      editing = p;
      titleCtrl.text = p.title;
      priceCtrl.text = p.price.toString();
      locationCtrl.text = p.location;
      typeCtrl.text = p.type;
      imageCtrl.text = p.imageUrl;
      descCtrl.text = p.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(editing == null ? "Add New Property" : "Edit Property",
              style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            controller: titleCtrl,
            decoration: _fieldDecoration("Title"),
            validator: (v) =>
                v == null || v.trim().isEmpty ? "Enter title" : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: priceCtrl,
            decoration: _fieldDecoration("Price (USD)"),
            keyboardType: TextInputType.number,
            validator: (v) =>
                v == null || v.trim().isEmpty ? "Enter price" : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
              controller: locationCtrl,
              decoration: _fieldDecoration("Location"),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Enter location" : null),
          const SizedBox(height: 8),
          TextFormField(
              controller: typeCtrl,
              decoration: _fieldDecoration("Type (Condo / Villa / Studio)")),
          const SizedBox(height: 8),
          // imageCtrl kept but not used in UI, can be removed later
          TextFormField(
              controller: imageCtrl,
              decoration: _fieldDecoration("Image URL (optional)")),
          const SizedBox(height: 8),
          TextFormField(
              controller: descCtrl,
              decoration: _fieldDecoration("Description"),
              maxLines: 4),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(editing == null ? "Add Property" : "Save Changes"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black),
                onPressed: _submit,
              ),
              const SizedBox(width: 12),
              if (editing != null)
                OutlinedButton(
                  onPressed: () {
                    _resetForm();
                    setState(() {});
                  },
                  child: const Text("Cancel"),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFD700))),
                )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
          const Text(
              "Tip: After adding a property, switch to Buyer mode to see it listed.",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 200),
        ]),
      ),
    );
  }
}

/* ---------------- Seller: My Listings (editable) ----------------------- */

class SellerListingsScreen extends StatefulWidget {
  SellerListingsScreen({super.key});

  @override
  State<SellerListingsScreen> createState() => _SellerListingsScreenState();
}

class _SellerListingsScreenState extends State<SellerListingsScreen> {
  final repo = PropertyRepository();
  List<Property> myListings = [];

  @override
  void initState() {
    super.initState();
    repo.propertiesNotifier.addListener(_onRepoUpdate);
    _onRepoUpdate();
  }

  @override
  void dispose() {
    repo.propertiesNotifier.removeListener(_onRepoUpdate);
    super.dispose();
  }

  void _onRepoUpdate() {
    setState(() {
      myListings =
          repo.properties.where((p) => p.ownerId == "seller_default").toList();
    });
  }

  void _delete(Property p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete listing?"),
        content: const Text("This will remove the listing locally."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              repo.removeProperty(p.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Listing removed")));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  void _edit(Property p) {
    showDialog(
      context: context,
      builder: (_) {
        final titleCtrl = TextEditingController(text: p.title);
        final priceCtrl = TextEditingController(text: p.price.toString());
        final descCtrl = TextEditingController(text: p.description);
        return AlertDialog(
          title: const Text("Edit Listing"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Title")),
                TextField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: "Price (USD)"),
                    keyboardType: TextInputType.number),
                TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                final updated = p.copyWith(
                    title: titleCtrl.text.trim(),
                    price: int.tryParse(priceCtrl.text.trim()) ?? p.price,
                    description: descCtrl.text.trim());
                repo.updateProperty(updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Listing updated")));
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return myListings.isEmpty
        ? const Center(
            child: Text("You have no listings yet",
                style: TextStyle(color: Color(0xFFFFD700))))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: myListings.length,
            itemBuilder: (context, index) {
              final p = myListings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFF14181F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Text(
                    "🏠",
                    style: TextStyle(fontSize: 32),
                  ),
                  title: Text(p.title,
                      style: const TextStyle(color: Color(0xFFFFD700))),
                  subtitle: Text("\$${_formatPrice(p.price)} • ${p.location}",
                      style: const TextStyle(color: Colors.white70)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70),
                        onPressed: () => _edit(p)),
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _delete(p)),
                  ]),
                ),
              );
            },
          );
  }
}

/* ---------------- Seller: Profile Screen -------------------------------- */

class SellerProfileScreen extends StatelessWidget {
  SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFFFD700),
            child: Icon(Icons.store, size: 56, color: Colors.black)),
        const SizedBox(height: 12),
        const Text("Seller Account",
            style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text("seller@example.com",
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A75FF)),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen())),
          child: const Text("Logout"),
        )
      ]),
    );
  }
}

/* -------------------- Small helpers & decorations ----------------------- */

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFFFFD700)),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFD700))),
    filled: true,
    fillColor: const Color(0xFF111417),
  );
}

InputDecoration _filterDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFFFFD700)),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFD700))),
    filled: true,
    fillColor: const Color(0xFF0F1418),
  );
}

Widget _inputField(String label, TextEditingController controller,
    {bool isPass = false}) {
  return TextField(
    controller: controller,
    obscureText: isPass,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFFFD700)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFD700))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent)),
      fillColor: const Color(0xFF111417),
      filled: true,
    ),
    style: const TextStyle(color: Colors.white),
  );
}

String _formatPrice(int price) {
  if (price >= 1000000) return "${(price / 1000000).toStringAsFixed(1)}M";
  if (price >= 1000) return "${(price / 1000).toStringAsFixed(0)}k";
  return price.toString();
}
