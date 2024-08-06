import 'package:eventsbox/database/calendar_dao.dart';
import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/pages/agenda/tabs/dia.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:flutter/material.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late Future<List<String>> _tabsText;

  @override
  void initState() {
    super.initState();
    Globals.listadoDiasObtenido
        ? _tabsText = CalendarDao().readAll()
        : _tabsText = Api.getListaDias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _tabsText,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data!.isNotEmpty) {
            return DefaultTabController(
                length: snapshot.data!.length,
                child: Scaffold(
                    drawer: const HamburgerMenu(),
                    appBar: AppBar(
                      title: const Text('Agenda'),
                      bottom: TabBar(
                          tabs: snapshot.data!
                              .map((e) => Column(
                                    children: [
                                      Text(
                                        e[0].toUpperCase() +
                                            e.substring(1, e.lastIndexOf(' ')),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                          e.substring(
                                              e.lastIndexOf(' ') + 1, e.length),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ))
                              .toList(),
                          unselectedLabelColor:
                              GlobalThemeData.lightColorScheme.onPrimary,
                          labelColor:
                              GlobalThemeData.lightColorScheme.onPrimary,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorColor:
                              GlobalThemeData.lightColorScheme.onPrimary,
                          indicatorSize: TabBarIndicatorSize.tab),
                    ),
                    body: Builder(builder: (BuildContext context) {
                      final TabController controller =
                          DefaultTabController.of(context);
                      return TabBarView(children: [
                        for (int i = 0; i < controller.length; i++)
                          Dia(snapshot.data![i]),
                      ]);
                    }),
                    bottomNavigationBar: const BottomMenu()));
          }
          return const SizedBox();
        });
  }
}
