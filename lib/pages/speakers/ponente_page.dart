import 'package:eventsbox/models/ponente.dart';
import 'package:flutter/material.dart';

class PonentePage extends StatelessWidget {
  final Ponente ponente;
  const PonentePage(this.ponente, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(ponente.image, fit: BoxFit.fitWidth)),
            ListTile(
              title: Text(
                '${ponente.name} ${ponente.lastName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _infoPonente(ponente.company, Icons.business),
            ponente.position.isNotEmpty
                ? _infoPonente(
                    ponente.position, Icons.mark_unread_chat_alt_rounded)
                : const SizedBox(width: 0, height: 0),
            ponente.description.isNotEmpty
                ? _infoPonente(ponente.description, Icons.description)
                : const SizedBox(width: 0, height: 0),
            ponente.city.isNotEmpty
                ? _infoPonente(ponente.city, Icons.location_city)
                : const SizedBox(width: 0, height: 0)
          ],
        ),
      ),
    );
  }

  Widget _infoPonente(String valor, IconData icon) {
    return ListTile(
        title: Text(
          valor,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        leading: Icon(icon),
        horizontalTitleGap: 5);
  }
}
