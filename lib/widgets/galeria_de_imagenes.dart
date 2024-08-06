import 'package:flutter/material.dart';

class GaleriaDeImagenes extends StatefulWidget {
  const GaleriaDeImagenes({super.key});

  @override
  State<GaleriaDeImagenes> createState() => _GaleriaDeImagenesState();
}

class _GaleriaDeImagenesState extends State<GaleriaDeImagenes> {
  @override
  Widget build(BuildContext context) {
    return noHayImagenes();
  }

  Widget noHayImagenes() {
    return Container(
      width: 300,
      height: 150,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.shade400, width: 1, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: const Text(
        'Próximamente verás las fotos aquí',
        textAlign: TextAlign.center,
      ),
    );
  }
}