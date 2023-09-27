import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'in_chat_viewmodel.dart';

class InChatView extends StatefulWidget {
  final String match_id;
  final String user_name;
  const InChatView({Key? key, required this.match_id, required this.user_name}) : super(key: key);

  @override
  _InChatViewState createState() => _InChatViewState();
}

class _InChatViewState extends State<InChatView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InChatViewModel>.reactive(
      viewModelBuilder: () => InChatViewModel(widget.match_id, widget.user_name),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Stack(
              children: [
                // Placeholder for Image
                Positioned(
                  child: Icon(Icons.account_circle, size: 36.0), // Replace with actual image
                ),
                // Blurred User Name
                Positioned(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Text(widget.user_name, style: Theme.of(context).textTheme.headline6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Messages List
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final message = viewModel.data![index];
                    return ListTile(
                      title: Text(message.senderId == viewModel.uid ? 'You' : message.senderId),
                      subtitle: Text(message.text),
                    );
                  },
                ),
              ),
              // Input Box and Send Button
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                      onPressed: () => viewModel.send_message(_messageController.text),
                      child: Text('Send'),
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

// class InChatView extends StackedView<InChatViewModel> {
//   final String match_id;
//   final String user_name;
//   const InChatView({Key? key, required this.match_id, required this.user_name}) : super(key: key);

//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget builder(
//     BuildContext context,
//     InChatViewModel viewModel,
//     Widget? child,
//   ) {
    
//   }

//   @override
//   InChatViewModel viewModelBuilder(
//     BuildContext context,
//   ) =>
//       InChatViewModel(match_id, user_name);
// }
