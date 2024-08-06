import 'package:eventsbox/database/menu_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/item_menu.dart';
import 'package:eventsbox/providers/navigation_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  final List<String> _routes = <String>[];
  void onClicked(int index) {
    setState(() {
      context.read<NavigationBarProvider>().setIndex(index);
    });
    Navigator.pushNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<BottomNavigationBarItem>> items = getMenu(context);
    return FutureBuilder(
        future: items,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return BottomNavigationBar(
            selectedItemColor: Colors.blue[900],
            unselectedItemColor: Colors.grey[800],
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 13,
            unselectedFontSize: 13,
            onTap: onClicked,
            currentIndex: context.watch<NavigationBarProvider>().currentIndex,
            items: snapshot.data!,
          );
        }));
  }

  Future<List<BottomNavigationBarItem>> getMenu(BuildContext context) async {
    List<BottomNavigationBarItem> items = <BottomNavigationBarItem>[];

    List<ItemMenu> menu = await MenuDao().readAll();
    for (ItemMenu item in menu) {
      if (item.location == 2) {
        _routes.add('/${item.content}');
        items.add(BottomNavigationBarItem(
            icon: Icon(Globals.iconMap[item.icon]), label: item.title));
      }
    }
    return items;
  }
}
