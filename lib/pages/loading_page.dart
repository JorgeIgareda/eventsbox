import 'package:eventsbox/globals/global_theme.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final String route;

  const LoadingPage(this.route, {super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void toProcess() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushNamed(context, widget.route);
  }

  @override
  void initState() {
    super.initState();
    toProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 35, 43, 56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Image(
            image: NetworkImage(
                'https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/b1/18/ef/b118ef7b-4c11-fb4f-50ac-d628f172987b/febed30b-65c8-4357-a15f-c0e1ae512e68_Disen_U0303o_sin_ti_U0301tulo__U00282_U0029.png/643x0w.jpg'),
          ),
          CircularProgressIndicator(
              color: GlobalThemeData.lightColorScheme.onPrimary)
        ],
      ),
    );
  }
}
