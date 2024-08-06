import 'package:flutter/material.dart';

Widget categoriaPatrocinador(
    BuildContext context, String categoria, int color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.zero, bottomLeft: Radius.zero,
            topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
        gradient: LinearGradient(
            stops: [0.1, 0.1], colors: [Colors.black, Colors.grey])
            ),
    child: Text(categoria),
  );
}
