import 'package:cashierfe/models/Menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cashierfe/pages/category/category.dart';
import 'package:cashierfe/pages/menu/menu.dart';
import 'package:cashierfe/pages/jenis/jenis.dart';

class drawerBar extends StatelessWidget {
  const drawerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 52, 202, 80),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Kategori'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Category()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Menu'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Menu()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Jenis'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const JenisPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Stock'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Pelanggan'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFF46C6B)),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
