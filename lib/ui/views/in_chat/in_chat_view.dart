import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'in_chat_viewmodel.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class InChatView extends StatefulWidget {
  final String match_id;
  final String user_name;
  final int user_pic;
  const InChatView({Key? key, required this.match_id, required this.user_name, required this.user_pic}) : super(key: key);

  @override
  _InChatViewState createState() => _InChatViewState();
}

class _InChatViewState extends State<InChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InChatViewModel>.reactive(
      viewModelBuilder: () => InChatViewModel(widget.match_id, widget.user_name, widget.user_pic),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFF3439AB),
            title: Stack(
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: AssetImage('lib/assets/${widget.user_pic}.png',), radius: 30, backgroundColor: const Color(0xFF3439AB),),
                    ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Text(
                                widget.user_name,
                                style: const TextStyle(fontFamily: "Switzer", fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                  ],
                )   
              ],
            ),
          ),
          body: Column(
            children: [
              // Messages List
              Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    //itemCount: viewModel.data?.length ?? 0,
                    itemCount: viewModel.displayed_messages.length,
                    itemBuilder: (context, index) {
                      //final message = viewModel.data![index];
                      final message = viewModel.displayed_messages[index];
                      final isCurrentUser = message.sent_by == viewModel.uid;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Align(
                          alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isCurrentUser ? Color(0xFF3439AB) : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isCurrentUser ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  DateFormat('hh:mm a').format(message.timestamp), // using intl package
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: isCurrentUser ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Input Box and Send Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 10, left:10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.send_message(_messageController.text);
                        _messageController.clear();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        },
                      child: Text('Send', style: TextStyle(fontFamily: "Switzer"),),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF34939AB))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
