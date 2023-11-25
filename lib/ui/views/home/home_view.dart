// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:qaabl_mobile/ui/common/ui_helpers.dart';
// import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
// import 'package:qaabl_mobile/ui/common/app_colors.dart';
// import 'package:qaabl_mobile/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'home_viewmodel.dart';
import 'dart:async';
import 'package:intl/intl.dart';

typedef ShowNoteDialogCallback = void Function(
    BuildContext, String, HomeViewModel);
GlobalKey _iconKey = GlobalKey();

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Duration of the slide animation
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -20), // Start position (from the top)
      end: const Offset(0, 0), // End position (final position)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) {
        viewModel
            .trackHomePageVisit(); // Call the tracking method when the model is ready
      },
      builder: (context, viewModel, child) {
        if (viewModel.replaying == false) {
          viewModel.nextUser = viewModel.get_next_user();
        }
        viewModel.replaying = false;
        viewModel.get_notes();

        // Reset and start the animation for the new user
        _animationController.reset();
        _animationController.forward();

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      _helloText(),
                      if (viewModel.nextUser != null) ...[
                        Container(
                          child: Center(
                            child: _userDetails(viewModel.nextUser, viewModel,
                                context, _slideAnimation),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Center(
                            child: check_profile_button(
                                viewModel.nextUser, viewModel, context),
                          ),
                        ),
                      ] else if (viewModel.user_continues == false) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: Column(
                            children: [
                              const Text(
                                'fill your profile!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "why?",
                                style: TextStyle(
                                  fontSize: 18, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "rn ur not visible, less chances of meeting ppl :(",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CupertinoButton(
                                color: const Color.fromARGB(255, 239, 239, 239),
                                onPressed: viewModel.go_to_profile,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: const Text(
                                  "Go to profile",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Switzer"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ] else if (viewModel.nextUser == null &&
                          viewModel.no_more_users == false) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: const Column(
                            children: [
                              Text(
                                'Finding people!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "give us a sec :)",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ] else if (viewModel.no_more_users == true) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: Column(
                            children: [
                              Text(
                                'No more users',
                                style: TextStyle(
                                  fontFamily: 'Switzer',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "appreciate u using qaabl btw",
                                style: TextStyle(
                                  fontSize: 14, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CupertinoButton(
                                color: Color(0xFF3439AB),
                                child: Text('Share Qaabl'),
                                onPressed: () {
                                  // Implement sharing functionality
                                  Share.share(
                                      'im on qaabl, join me! https://testflight.apple.com/join/syEy5gAZ');
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "help us spread the word and share it with ur friends!",
                                style: TextStyle(
                                  fontSize: 10, // Adjust the size as needed
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: 0), // Adjust as needed
                        child: _bottomNavigationBar(viewModel),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: notification_icon(context, viewModel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _userDetails(
      nextUser, viewModel, context, Animation<Offset> slideAnimation) {
    SwipeItem? swipeItem; // Declare swipeItem as nullable
    final GlobalKey<_UserCardState> userCardKey = GlobalKey<_UserCardState>();

    // Define the callback outside of swipeItem
    Future<void> onSlideUpdateCallback(SlideRegion? region) async {
      if (region.toString() == "SlideRegion.inNopeRegion") {
        // show dislike feedback
        userCardKey.currentState!.showFeedback("Dislike");
      } else if (region.toString() == "SlideRegion.inLikeRegion") {
        // show like feedback
        userCardKey.currentState!.showFeedback("Like");
      } else if (region.toString() == "SlideRegion.inSuperLikeRegion") {
        // show like feedback
        userCardKey.currentState!.showFeedback("Superlike");
      } else {
        // hide feedback for other cases
        userCardKey.currentState!.hideFeedback();
      }
    }

    swipeItem = SwipeItem(
        content: UserCard(nextUser, viewModel, context, _slideAnimation,
            userCardKey, showNoteDialog),
        likeAction: () {
          viewModel.like_user(
              nextUser['id'], nextUser['potential_match'], "like");
        },
        nopeAction: () {
          viewModel.dislike_user(nextUser['id']);
        },
        superlikeAction: () {
          showNoteDialog(context, nextUser['id'], viewModel);
          viewModel.like_user(
              nextUser['id'], nextUser['potential_match'], "super_like");
          //ToDo: implement leaving them a note here
        },
        onSlideUpdate: onSlideUpdateCallback
        // Include other actions like superLike if you have them
        );

    MatchEngine matchEngine = MatchEngine(swipeItems: [swipeItem]);

    return Container(
      key: ValueKey(DateTime.now().millisecondsSinceEpoch),
      height: 500,
      child: SwipeCards(
        matchEngine: matchEngine,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              alignment: Alignment.center, child: swipeItem!.content);
        },
        onStackFinished: () {
          // Load more users or any action when all cards are swiped
        },
        upSwipeAllowed: true,
        fillSpace: true,
      ),
    );
  }

  void showNoteDialog(
      BuildContext context, String liked_user_uid, HomeViewModel viewModel) {
    TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'tell them why u super liked them',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          content: TextField(
            controller: noteController,
            decoration:
                const InputDecoration(hintText: "leave them a note here..."),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('send'),
              onPressed: () {
                String note = noteController.text;
                viewModel.leave_note(viewModel.previous_user!['id'], note);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

Widget _helloText() {
  return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text(
            'Hello, in Qaabl!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            "explore cool people, at ur fingertips",
            style: TextStyle(
              fontSize: 14, // Adjust the size as needed
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));
}

Widget notification_icon(BuildContext context, HomeViewModel viewModel) {
  Widget iconContent;
  if (viewModel.user_notes != null) {
    iconContent = Stack(
      alignment: Alignment.topRight,
      children: [
        Icon(Icons.notifications),
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  } else {
    iconContent = Icon(Icons.notifications);
  }

  return InkWell(
    key: _iconKey, // Assign the global key to your InkWell
    onTap: () => _showDropDown(context, viewModel),
    child: iconContent,
  );
}

void _showDropDown(BuildContext context, HomeViewModel viewModel) {
  final RenderBox renderBox =
      _iconKey.currentContext!.findRenderObject() as RenderBox;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
  final double dropdownWidth =
      MediaQuery.of(context).size.width * 0.8; // Example: 80% of screen width
  final double iconWidth = renderBox.size.width;

  // Calculate the left position by subtracting the width of the dropdown from the right edge of the icon.
  final double leftPosition = offset.dx + iconWidth - dropdownWidth;

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () {
        // This empty onTap handler is necessary to detect taps outside the dropdown.
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry
                    .remove(); // Remove the overlay when you tap outside the dropdown.
              },
            ),
          ),
          Positioned(
            left: leftPosition, // Updated left position
            top: offset.dy + renderBox.size.height,
            width: dropdownWidth, // Set the width of the dropdown.
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                ),
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: viewModel.user_notes?.map((note) {
                        return ListTile(
                          title: Text(
                              "someone left u this note: " + note['content'],
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          trailing: Text(
                            viewModel.formatTimestamp(note['timestamp']),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            overlayEntry.remove();
                          },
                        );
                      }).toList() ??
                      [
                        ListTile(
                          title: Text("no notifications yet",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () {
                            overlayEntry.remove();
                          },
                        )
                      ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Overlay.of(context)!.insert(overlayEntry);
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
                const ClampingScrollPhysics(), // This will enable scrolling in the ListView
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

class UserProfileView extends StatelessWidget {
  final List<Map<String, dynamic>> interests;
  final String aspiration;

  const UserProfileView(
      {Key? key, required this.interests, required this.aspiration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3439AB),
        title: const Text(
          'More about me...',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'I aspire to be a: $aspiration',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'And my interests are:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          UserInterestsWidget(interests: interests),
        ],
      )),
    );
  }
}

Widget _bottomNavigationBar(viewModel) {
  Color profileColor = (viewModel.current_page == "profile" ||
          viewModel.current_page == "edit_profile" ||
          viewModel.current_page == "settings")
      ? const Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  Color chatColor = (viewModel.current_page == "chats")
      ? const Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  return Stack(
    clipBehavior: Clip.none, // Allows the overflowing children to be visible
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.person),
              color: profileColor,
              onPressed: viewModel.go_to_profile,
            ),
            const SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.chat),
              color: chatColor,
              onPressed: viewModel.go_to_chats,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the value as needed to position the logo
        child: GestureDetector(
          onTap: () {
            // viewModel.signOut();
          }, // Add your home action here
          child: Container(
              width: 70, // Adjust the width and height as needed
              height: 70,
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFF3439AB)), // Border color
                borderRadius:
                    BorderRadius.circular(40), // Rounded corner radius
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 3),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/logo.png'),
                backgroundColor: Colors.white,
              )),
        ),
      ),
    ],
  );
}

class UserCard extends StatefulWidget {
  final nextUser;
  final viewModel;
  final context;
  final slideAnimation;
  final key;
  final ShowNoteDialogCallback showNoteDialog;

  UserCard(this.nextUser, this.viewModel, this.context, this.slideAnimation,
      this.key, this.showNoteDialog)
      : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String? feedback; // this variable will store the feedback "Like" or "Dislike"
  Color? feedbackColor;
  IconData? feedbackIcon;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: Stack(children: [
        Card(
            color: const Color.fromARGB(255, 239, 239, 239),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 2,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 25)),
                            const Text(
                              "One of my interests is:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.nextUser['interests'][0]['name']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Image.asset(
                              'lib/assets/${widget.nextUser['image_index']}.png',
                              height: 170,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            const Text(
                              "And I aspire to be a:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.nextUser['aspiration']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                // Align Like and Dislike buttons horizontally
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      showFeedback("Repeat");
                                      await Future.delayed(
                                          const Duration(milliseconds: 400));
                                      widget.viewModel.replay_user();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(Icons.repeat_rounded,
                                        color: Colors.yellow), // Close icon
                                  ),
                                  //Make this button bigger
                                  ElevatedButton(
                                    onPressed: () async {
                                      showFeedback("Dislike");
                                      await Future.delayed(
                                          const Duration(milliseconds: 400));
                                      widget.viewModel
                                          .dislike_user(widget.nextUser['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(40, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(Icons.thumb_down,
                                        color: Colors.black), // Close icon
                                  ),
                                  //Make this button bigger
                                  ElevatedButton(
                                    onPressed: () async {
                                      showFeedback("Like");
                                      await Future.delayed(
                                          const Duration(milliseconds: 400));
                                      widget.viewModel.like_user(
                                          widget.nextUser['id'],
                                          widget.nextUser['potential_match'],
                                          "like");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(40, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: const Color(0xFF3439AB),
                                    ),
                                    child: const Icon(Icons.thumb_up,
                                        color: Colors.white), // Check icon
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      showFeedback("Superlike");
                                      await Future.delayed(
                                          const Duration(milliseconds: 400));
                                      //show the dialog here
                                      showNoteDialog(
                                          context,
                                          widget.nextUser['id'],
                                          widget.viewModel);
                                      widget.viewModel.like_user(
                                          widget.nextUser['id'],
                                          widget.nextUser['potential_match'],
                                          "super_like");
                                      //ToDo: implement leaving them a note here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded button
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(Icons.star,
                                        color: Colors.blue), // Close icon
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
        if (feedback != null)
          Positioned(
            top: 50, // adjust as needed
            left: feedback == "Like" ? 20 : null, // 20px from left if "Like"
            right: feedback == "Dislike"
                ? 20
                : null, // 20px from right if "Dislike"
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: feedbackColor!.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30.0), // rounded corners
              ),
              child: Icon(
                feedbackIcon,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
      ]),
    );
  }

  void showNoteDialog(
      BuildContext context, String liked_user_uid, HomeViewModel viewModel) {
    TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'tell them why u super liked them',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          content: TextField(
            controller: noteController,
            decoration:
                const InputDecoration(hintText: "leave them a note here..."),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('send'),
              onPressed: () {
                String note = noteController.text;
                viewModel.leave_note(viewModel.previous_user!['id'], note);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showFeedback(String feedbackText) {
    setState(() {
      feedback = feedbackText;
      if (feedbackText == "Like") {
        feedbackColor = const Color(0xFF3439AB);
        feedbackIcon = Icons.thumb_up; // change this to your "like" icon
      } else if (feedbackText == "Dislike") {
        feedbackColor = Colors.black;
        feedbackIcon = Icons.thumb_down; // change this to your "dislike" icon
      } else if (feedbackText == "Repeat") {
        feedbackColor = Colors.yellow;
        feedbackIcon = Icons.repeat_rounded;
      } else if (feedbackText == "Superlike") {
        feedbackColor = Colors.blue;
        feedbackIcon = Icons.star;
      }
    });
  }

  void hideFeedback() {
    setState(() {
      feedback = null;
      feedbackColor = null;
      feedbackIcon = null;
    });
  }
}

Widget check_profile_button(nextUser, viewModel, context) {
  if (nextUser != null && nextUser['interests'].isNotEmpty) {
    return Column(
      children: [
        Text(
          "I have ${nextUser['interests'].length} interests, check me out",
          style: const TextStyle(
            fontSize: 14, // Adjust the size as needed
          ),
        ),
        ElevatedButton(
          onPressed: () {
            viewModel.trackProfileViewEvent(nextUser['id']);
            print('tracked profile view');
            showModalBottomSheet(
              context: context,
              builder: (context) => GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: UserProfileView(
                    interests:
                        List<Map<String, dynamic>>.from(nextUser['interests']),
                    aspiration: nextUser['aspiration'],
                  ),
                ),
              ),
              isScrollControlled: true,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3439AB), // Background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded button
            ),
          ),
          child:
              const Text("View Profile", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  } else {
    return const Text("No more users to display.");
  }
}
