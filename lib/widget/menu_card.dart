import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String name;
  final String image;

  const MenuCard({Key? key, required this.name, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.8),
            Colors.black.withOpacity(.3),
          ]),
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        height: 100,
        width: 100,
        child: Center(
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
