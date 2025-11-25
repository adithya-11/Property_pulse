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
          secondary: Color(0xFFFFD700), // Gold
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101419),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class Property {
  final int id;
  final String title;
  final String price;
  final String location;
  final String image;

  Property({
    required this.id,
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
        id: 1,
        title: "Modern 2BHK Apartment",
        price: "₹45,00,000",
        location: "Bangalore, India",
        image: "https://via.placeholder.com/400",
      ),
      Property(
        id: 2,
        title: "Luxury Villa",
        price: "₹1,20,00,000",
        location: "Hyderabad, India",
        image: "https://via.placeholder.com/400",
      ),
      Property(
        id: 3,
        title: "Cozy 1BHK Studio",
        price: "₹25,00,000",
        location: "Delhi, India",
        image: "https://via.placeholder.com/400",
      ),
    ];
  }
}

class HomeScreen extends StatelessWidget {
  final List<Property> properties = PropertyService.getProperties();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PropertyPulse"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search properties...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A1F27),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFFD700)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFFFD700)),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 12),
              children: const [
                FilterChipItem(label: "Apartment"),
                FilterChipItem(label: "Villa"),
                FilterChipItem(label: "Studio"),
                FilterChipItem(label: "Luxury"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyDetailScreen(property: property),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xFF14181F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFFFD700),
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.network(
                        property.image,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        property.title,
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${property.price} • ${property.location}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipItem extends StatelessWidget {
  final String label;

  const FilterChipItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label),
        labelStyle: const TextStyle(color: Color(0xFFFFD700)),
        backgroundColor: const Color(0xFF1A1F27),
        side: const BorderSide(color: Color(0xFFFFD700)),
      ),
    );
  }
}

class PropertyDetailScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailScreen({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(property.image, width: double.infinity, height: 220, fit: BoxFit.cover),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              property.title,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "${property.price}\n${property.location}",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }
}