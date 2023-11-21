import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class appBaru extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const appBaru({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(title,
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ))),
      centerTitle: true,
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      backgroundColor: Colors.white,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
