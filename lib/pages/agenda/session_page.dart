import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/models/session.dart';
import 'package:eventsbox/models/track.dart';
import 'package:eventsbox/pages/agenda/tabs/chat.dart';
import 'package:eventsbox/pages/agenda/tabs/info.dart';
import 'package:eventsbox/pages/agenda/tabs/preguntas.dart';
import 'package:eventsbox/pages/agenda/tabs/votaciones.dart';
import 'package:flutter/material.dart';

class SessionPage extends StatelessWidget {
  final Session sesion;
  final List<Track> tracks;
  final List<Ponente> ponentes;
  final List<Ponente> moderadores;
  final List<Patrocinador> patrocinadores;

  const SessionPage(this.sesion, this.tracks, this.ponentes, this.moderadores, this.patrocinadores,  {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const ListTile(trailing: Icon(Icons.place, color: Colors.white)),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Container(
              color: Colors.white,
              child: _tabBar),
          ),
        ),
        body: TabBarView(children: [
          Info(sesion, tracks, ponentes, moderadores, patrocinadores),
          const Chat(),
          const Preguntas(),
          const Votaciones()
        ]),
      ),
    );
  }

  TabBar get _tabBar => TabBar(
              labelColor: Colors.blue[900],
              unselectedLabelColor: Colors.blue[900],
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.blue[800],
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
              Tab(text: 'INFO'),
              Tab(text: 'CHAT'),
              Tab(text: 'PREGUNTAS'),
              Tab(text: 'VOTACIONES')
            ]);
}