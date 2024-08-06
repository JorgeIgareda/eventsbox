import 'package:flutter/material.dart';

class GaleriaDeVideos extends StatefulWidget {
  const GaleriaDeVideos({super.key});

  @override
  State<GaleriaDeVideos> createState() => _GaleriaDeVideosState();
}

class _GaleriaDeVideosState extends State<GaleriaDeVideos> {
  @override
  Widget build(BuildContext context) {
    return noHayVideos();
  }

  Widget noHayVideos() {
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
        'Próximamente verás los vídeos aquí',
        textAlign: TextAlign.center,
      ),
    );
  }
}