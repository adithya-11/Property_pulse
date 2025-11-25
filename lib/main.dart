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
      ),
      home: SplashScreen(),
    );
  }
}

/* ------------------------------------------------------------
                    PHASE 2 — SPLASH SCREEN
-------------------------------------------------------------*/

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => opacity = 1);
    });

    Future.delayed(const Duration(seconds: 3), () {
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
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.house_rounded,
                  color: Color(0xFFFFD700), size: 90),
              SizedBox(height: 20),
              Text(
                "PropertyPulse",
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------------------------------------------------
                    LOGIN SCREEN (DUMMY)
-------------------------------------------------------------*/

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
            const SizedBox(height: 15),
            _inputField("Password", pass, isPass: true),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MainBottomNav()),
                );
              },
              child: const Text("Login"),
            ),

            TextButton(
              onPressed: () {},
              child: const Text(
                "Create an account",
                style: TextStyle(color: Color(0xFFFFD700)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* ------------------------------------------------------------
                  INPUT FIELD COMPONENT
-------------------------------------------------------------*/

Widget _inputField(String label, TextEditingController controller,
    {bool isPass = false}) {
  return TextField(
    controller: controller,
    obscureText: isPass,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFFFD700)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFD700)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
    ),
    style: const TextStyle(color: Colors.white),
  );
}

/* ------------------------------------------------------------
             PHASE 3 — BOTTOM NAVIGATION CONTROLLER
-------------------------------------------------------------*/

class MainBottomNav extends StatefulWidget {
  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int selectedIndex = 0;

  List<Property> favoriteList = [];

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onFavoriteToggle: toggleFavorite, favorites: favoriteList),
      FavoritesScreen(favorites: favoriteList),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF101419),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void toggleFavorite(Property p) {
    setState(() {
      if (favoriteList.contains(p)) {
        favoriteList.remove(p);
      } else {
        favoriteList.add(p);
      }
    });
  }
}

/* ------------------------------------------------------------
            PROPERTY MODEL + SAMPLE DATA (USA)
-------------------------------------------------------------*/

class Property {
  final String title;
  final String price;
  final String location;
  final String image;

  Property({
    required this.title,
    required this.price,
    required this.location,
    required this.image,
  });
}

class PropertyService {
  static List<Property> getProperties() {
    return [
      Property(
        title: "Luxury Penthouse",
        price: "\$1,200,000",
        location: "New York, NY",
        image: "https://via.placeholder.com/400",
      ),
      Property(
        title: "Modern 3BHK Condo",
        price: "\$650,000",
        location: "Los Angeles, CA",
        image: "https://via.placeholder.com/400",
      ),
      Property(
        title: "Cozy Studio Apartment",
        price: "\$220,000",
        location: "Miami, FL",
        image: "https://via.placeholder.com/400",
      ),
    ];
  }
}

/* ------------------------------------------------------------
                   UPDATED HOME SCREEN (PHASE 3)
-------------------------------------------------------------*/

class HomeScreen extends StatelessWidget {
  final List<Property> favorites;
  final Function(Property) onFavoriteToggle;

  HomeScreen({required this.onFavoriteToggle, required this.favorites});

  final properties = PropertyService.getProperties();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PropertyPulse"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final p = properties[index];
          final isFav = favorites.contains(p);

          return Card(
            margin: const EdgeInsets.all(10),
            color: const Color(0xFF14181F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading:
                  Image.network(p.image, width: 60, fit: BoxFit.cover),
              title: Text(
                p.title,
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${p.price} • ${p.location}",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.white70,
                ),
                onPressed: () => onFavoriteToggle(p),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ------------------------------------------------------------
                    FAVORITES SCREEN (PHASE 3)
-------------------------------------------------------------*/

class FavoritesScreen extends StatelessWidget {
  final List<Property> favorites;

  FavoritesScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorites added yet",
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final p = favorites[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  color: const Color(0xFF14181F),
                  child: ListTile(
                    leading: Image.network(p.image, width: 60),
                    title: Text(
                      p.title,
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${p.price} • ${p.location}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* ------------------------------------------------------------
                     PROFILE SCREEN (PHASE 3)
-------------------------------------------------------------*/

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFFFD700),
              child: Icon(Icons.person, size: 60, color: Colors.black),
            ),
            SizedBox(height: 15),
            Text(
              "John Doe",
              style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "johndoe@example.com",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              "Edit Profile (UI only)",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}