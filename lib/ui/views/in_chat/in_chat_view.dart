import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
// import 'package:qaabl_mobile/ui/common/ui_helpers.dart';
import 'in_chat_viewmodel.dart';
import 'package:intl/intl.dart';
// import 'dart:ui';
import 'package:qaabl_mobile/models/message_model.dart';

class InChatView extends StatefulWidget {
  final String match_id;
  final String user_name;
  final int user_pic;
  final String other_user_id;
  const InChatView(
      {Key? key,
      required this.match_id,
      required this.user_name,
      required this.user_pic,
      required this.other_user_id})
      : super(key: key);

  @override
  _InChatViewState createState() => _InChatViewState();
}

class _InChatViewState extends State<InChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Map<String, GlobalKey> messageKeys = {};

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InChatViewModel>.reactive(
      viewModelBuilder: () => InChatViewModel(widget.match_id, widget.user_name,
          widget.user_pic, widget.other_user_id),
      onViewModelReady: (viewModel) async {
        await viewModel.view_profile_data(widget.other_user_id);
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: AppBar(
              backgroundColor: Color(0xFF3439AB),
              title: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
								viewModel.trackProfileViewEvent(
									widget.match_id,
									widget.other_user_id
								);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      child: UserProfileView(
                                        interests:
                                            List<Map<String, dynamic>>.from(
                                                viewModel.user_data?[
                                                        'interests'] ??
                                                    []),
                                      ),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'lib/assets/${widget.user_pic}.png',
                                ),
                                radius: 30,
                                backgroundColor: const Color(0xFF3439AB),
                              ),
                            ),
                            ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: FittedBox(
                                fit: BoxFit
                                    .scaleDown, // Adjust the text to fit inside the available space
                                child: Text(
                                  widget.user_name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    child: UserProfileView(
                                      interests:
                                          List<Map<String, dynamic>>.from(
                                              viewModel.user_data?[
                                                      'interests'] ??
                                                  []),
                                    ),
                                  ),
                                ),
                                isScrollControlled: true,
                              );
                              break;
                            case 'Delete':
                              //delete chat server-side
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text("Confirm Deletion"),
                                    content: Text(
                                        "Are you sure you want to delete this chat? This action is irreversible."),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                color: Color(0xFF3439AB))),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the alert dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete",
                                            style: TextStyle(
                                                color: Colors.redAccent)),
                                        onPressed: () async {
                                          //Call the function that deletes the chat
                                          await viewModel.delete_chat(
                                              widget.match_id,
                                              widget.other_user_id);
                                          //Go back to the chats view
                                          await viewModel.go_to_chats();
                                          Navigator.of(context)
                                              .pop(); // Close the alert dialog after deleting
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Profile',
                            child: Text('View Profile'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text(
                              'Delete Chat',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              // Messages List
              Expanded(
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (scrollEnd) {
                    final metrics = scrollEnd.metrics;
                    if (metrics.atEdge) {
                      if (metrics.pixels == metrics.maxScrollExtent) {
                        viewModel.loadMessagesBatch();
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: viewModel.displayed_messages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.displayed_messages[index];
                      final isCurrentUser = message.sent_by == viewModel.uid;
                      final timestampString =
                          message.timestamp.toIso8601String();
                      messageKeys[timestampString] =
                          messageKeys[timestampString] ?? GlobalKey();
                      final key = messageKeys[timestampString] ?? GlobalKey();
                      return GestureDetector(
                        onLongPress: isCurrentUser
                            ? null // Disable long press for the current user's messages.
                            : () {
                                _showEmojiOptions(
                                    viewModel, message, timestampString);
                              },
                        child: Padding(
                          key: key,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Align(
                            alignment: isCurrentUser
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Color(0xFF3439AB)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isCurrentUser
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(message.timestamp),
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: isCurrentUser
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (message.reaction != "No reaction")
                                    Positioned(
                                      bottom: -4,
                                      right: 0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          message.reaction,
                                          style: TextStyle(
                                              fontSize: 15), // Adjust as needed
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Input Box and Send Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0), // Add some horizontal padding
                        child: CupertinoTextField(
                          controller: _messageController,
                          placeholder: 'type your message...',
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    CupertinoButton(
                      onPressed: () {
                        final messageText = _messageController.text.trim();
                        if (messageText.isNotEmpty) {
                          viewModel.send_message(messageText);
                          _messageController.clear();

                          if (_scrollController.offset ==
                              _scrollController.position.maxScrollExtent) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        }
                      },
                      child: Text('Send', style: TextStyle()),
                      color: Color(
                          0xFF3439AB), // This is still valid for CupertinoButton
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical:
                              10.0), // Adjust the button padding if needed
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

  void _showEmojiOptions(
      InChatViewModel viewModel, Message message, String timestampString) {
    final GlobalKey? messageKey = messageKeys[timestampString];

    if (messageKey?.currentContext == null) {
      print("I am returning");
      return;
    }

    final RenderBox renderBox =
        messageKey!.currentContext!.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin:
                EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal margin
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey
                  .withOpacity(0.8), // Make the background slightly opaque
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Wrap(
              children: [
                _buildEmojiOption(viewModel, '😀', message),
                _buildEmojiOption(viewModel, '❤️', message),
                _buildEmojiOption(viewModel, '😂', message),
                _buildEmojiOption(viewModel, '👍', message),
                _buildEmojiOption(viewModel, '😢', message),
                _buildEmojiOption(viewModel, '😡', message),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after some time or on selection
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Widget _buildEmojiOption(
      InChatViewModel viewModel, String emoji, Message message) {
    return GestureDetector(
      onTap: () {
        viewModel.react_to_message(emoji, message);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          emoji,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
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
            physics:
                ClampingScrollPhysics(), // This will enable scrolling in the ListView
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
