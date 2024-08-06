import 'package:eventsbox/database/chat_dao.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/chat.dart';
import 'package:eventsbox/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Asistente asistente;
  const ChatPage(this.asistente, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<Chat>> _mensajes;
  final TextEditingController _controller = TextEditingController(text: '');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _mensajes = ChatDao().readAll();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _mensajes,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<Chat> mensajes = <Chat>[];
          for (Chat chat in snapshot.data!) {
            if (chat.chatTo == widget.asistente.id) {
              mensajes.add(chat);
            }
          }
          // Marcar mensajes como leídos y scrollear hacia abajo el chat
          if (mensajes.isNotEmpty) {
            _scrollToBottom();
            Api.setReaded(mensajes.last.chatTo, mensajes.last.id);
          }
          return Scaffold(
              appBar: AppBar(
                  title: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 21,
                    child: widget.asistente.image.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.asistente.image))
                        : CircleAvatar(
                            backgroundColor: Colors.blueAccent[400],
                            child: Text(widget.asistente.name[0],
                                style: const TextStyle(color: Colors.white)))),
                title: Text(
                    '${widget.asistente.name} ${widget.asistente.lastName}',
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
                subtitle: const Text('No conectado',
                    style: TextStyle(fontSize: 13, color: Colors.white)),
                contentPadding: EdgeInsets.zero,
              )),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: mensajes.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool showDate = false;
                          if (index == 0 ||
                              mensajes[index - 1].date.substring(0, 10) !=
                                  mensajes[index].date.substring(0, 10)) {
                            showDate = true;
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(children: [
                              ///////////////////////////////////////////////////////////////////////////////////
                              ////////////// - Muestra la fecha si es el primer mensaje del día - ///////////////
                              ///////////////////////////////////////////////////////////////////////////////////
                              if (showDate)
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          DateFormat(
                                                  'd \'de\' MMMM \'de\' yyyy',
                                                  'es_ES')
                                              .format(DateTime.parse(
                                                  mensajes[index].date)),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const Expanded(child: Divider())
                                  ],
                                ),
                              ///////////////////////////////////////////////////////////////////////////////////
                              ////////////////// - Si el usuario es el receptor del mensaje - ///////////////////
                              ///////////////////////////////////////////////////////////////////////////////////
                              mensajes[index].sender != 'me'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5))),
                                              child: Text(
                                                  mensajes[index].message)),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                            mensajes[index]
                                                .date
                                                .substring(11, 16),
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    )
                                  ///////////////////////////////////////////////////////////////////////////////////
                                  /////////////////// - Si el usuario es el emisor del mensaje - ////////////////////
                                  ///////////////////////////////////////////////////////////////////////////////////
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            mensajes[index]
                                                .date
                                                .substring(11, 16),
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.blueAccent[100],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5))),
                                              child: Text(
                                                  mensajes[index].message)),
                                        )
                                      ],
                                    )
                            ]),
                          );
                        }),
                  ),
                  ///////////////////////////////////////////////////////////////////////////////////
                  ///////////////////////// - Campo para enviar mensajes - //////////////////////////
                  ///////////////////////////////////////////////////////////////////////////////////
                  const Divider(color: Colors.black),
                  ListTile(
                    title: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: 'Escribe un mensaje',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[700])),
                    ),
                    trailing: IconButton(
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            await Api.sendMessage(
                                _controller.text, widget.asistente.id);
                            _controller.clear();
                            _mensajes = ChatDao().readAll();
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.send)),
                    minVerticalPadding: 0,
                    dense: true,
                  )
                ],
              ));
        }));
  }
}
