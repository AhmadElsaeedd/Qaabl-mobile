import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/ui/common/ui_helpers.dart';
import 'in_chat_viewmodel.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class InChatView extends StatefulWidget {
  final String match_id;
  final String user_name;
  final int user_pic;
  final String other_user_id;
  const InChatView({Key? key, required this.match_id, required this.user_name, required this.user_pic, required this.other_user_id}) : super(key: key);

  @override
  _InChatViewState createState() => _InChatViewState();
}

class _InChatViewState extends State<InChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InChatViewModel>.reactive(
      viewModelBuilder: () => InChatViewModel(widget.match_id, widget.user_name, widget.user_pic, widget.other_user_id),
      //run the function that gets the other user's data as soon as the chat is fully loaded
      onViewModelReady: (viewModel) async {
        await viewModel.view_profile_data(widget.other_user_id);
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFF3439AB),
            title: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
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
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              onSelected: (value) {
                                switch (value) {
                                  case 'Profile': 
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => GestureDetector(
                                        onTap: () => Navigator.of(context).pop(),
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 0.35,
                                          child: UserProfileView(
                                            interests: List<Map<String, dynamic>>.from(viewModel.user_data?['interests'] ?? []),
                                          ),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                    );
                                    break;
                                  case 'Delete':
                                    //make sure that they want to delete the chat first

                                    //delete chat server-side
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm Deletion"),
                                          content: Text("Are you sure you want to delete this chat? This action is irreversible."),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel", style:TextStyle(fontFamily: "Switzer", color: Color(0xFF3439AB))),
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the alert dialog
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
                                              onPressed: () async {
                                                //Call the function that deletes the chat
                                                await viewModel.delete_chat(widget.match_id, widget.other_user_id);
                                                //Go back to the chats view
                                                await viewModel.go_to_chats();
                                                Navigator.of(context).pop(); // Close the alert dialog after deleting
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Profile',
                                  child: Text('View Profile'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete Chat', style: TextStyle(color: Colors.red),),
                                ),
                              ],
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Add some horizontal padding
                        child: CupertinoTextField(
                          controller: _messageController,
                          placeholder: 'Type a message',
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust the internal padding of the text field
                          //cursorRadius: BorderRadius.circular(8.0),  // Optional: Add some border radius if you like
                          //clearButtonMode: OverlayVisibilityMode.editing, // Optional: Show clear button when editing
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    CupertinoButton(
                      onPressed: () {
                        viewModel.send_message(_messageController.text);
                        _messageController.clear();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text('Send', style: TextStyle(fontFamily: "Switzer")),
                      color: Color(0xFF3439AB),  // This is still valid for CupertinoButton
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Adjust the button padding if needed
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

class UserProfileView extends StatelessWidget {
  final List<Map<String, dynamic>> interests;

  const UserProfileView({Key? key, required this.interests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3439AB),
        //title:
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: UserInterestsWidget(interests: interests),
    );
  }
}

class UserInterestsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> interests;

  const UserInterestsWidget({Key? key, required this.interests})
      : super(key: key);

  @override
  _UserInterestsWidgetState createState() => _UserInterestsWidgetState();
}

class _UserInterestsWidgetState extends State<UserInterestsWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true, // This will size the ListView to its content
            physics: ClampingScrollPhysics(), // This will enable scrolling in the ListView
            itemCount: widget.interests.length,
            itemBuilder: (context, index) {
              final interest = widget.interests[index];
              return ExpansionTile(
                title: Text(interest['name']),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(interest['description'] ?? ''),
                  ),
                ],
                initiallyExpanded: index == selectedIndex,
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}