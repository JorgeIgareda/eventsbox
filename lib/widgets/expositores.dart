import 'package:flutter/material.dart';

class Expositores extends StatefulWidget {
  const Expositores({super.key});

  @override
  State<Expositores> createState() => _ExpositoresState();
}

class _ExpositoresState extends State<Expositores> {
  @override
  Widget build(BuildContext context) {
    return noHayExpositores();
  }

  Widget noHayExpositores() {
    return Container(
      width: 160,
      height: 280,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
          style: BorderStyle.solid
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: const Text('Próximamente verás los expositores aquí', textAlign: TextAlign.center,),
    );
  }
}