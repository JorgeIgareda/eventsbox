import 'package:eventsbox/models/ponente.dart';
import 'package:flutter/material.dart';

Widget listaPonentes(List<Ponente> ponentes) {
  if (ponentes.isNotEmpty) {
    return ListView.builder(
        itemCount: ponentes.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/ponente',
                  arguments: ponentes[index]);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(ponentes[index].image,
                            fit: BoxFit.fill)),
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              '${ponentes[index].name} ${ponentes[index].lastName}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            minVerticalPadding: 0,
                            dense: true,
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                          ),
                          ListTile(
                              title: Text(ponentes[index].company,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              leading: const Icon(Icons.business),
                              horizontalTitleGap: 5,
                              minVerticalPadding: 0,
                              dense: true,
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4)),
                          ponentes[index].position.isNotEmpty
                              ? ListTile(
                                  title: Text(
                                    ponentes[index].position,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  leading: const Icon(
                                      Icons.mark_unread_chat_alt_rounded),
                                  horizontalTitleGap: 5,
                                  minVerticalPadding: 0,
                                  dense: true,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4))
                              : const SizedBox(width: 0, height: 0)
                        ],
                      ),
                    )
                  ],
                ),
                const Divider()
              ],
            ),
          );
        });
  } else {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic, size: 150),
          Text('No hay ponentes',
              style: TextStyle(fontWeight: FontWeight.w500)),
          Text('Todos los ponentes aparecerán aquí')
        ],
      ),
    );
  }
}
