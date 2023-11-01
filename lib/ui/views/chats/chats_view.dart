import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'chats_viewmodel.dart';
import 'dart:ui';

class ChatsView extends StackedView<ChatsViewModel> {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Chats',
                      style: TextStyle(
                        fontSize: 26, // Adjust the size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'chat to reveal the names of ur matches :)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
            // Horizontal List for New Chats
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 100, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.new_matches.length,
                  itemBuilder: (context, index) {
                    final match = viewModel.new_matches[index];

                    return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5), // Adjust as needed
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey), // Border color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                            onTap: () => viewModel.go_to_chat(
                                match.match_id,
                                match.other_user_name,
                                match.other_user_pic,
                                match.other_user_id),
                            child: Container(
                              //constraints: BoxConstraints(minWidth: 80),
                              width: 100,
                              child: Card(
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //Add the user's image here
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'lib/assets/${match.other_user_pic}.png',
                                      ),
                                      radius: 30,
                                      backgroundColor: const Color(0xFF3439AB),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: ImageFiltered(
                                        imageFilter: ImageFilter.blur(
                                            sigmaX: 4, sigmaY: 4),
                                        child: FittedBox(
                                          fit: BoxFit
                                              .scaleDown, // Adjust the text to fit inside the available space
                                          child: Text(
                                            match.other_user_name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ),
                            )));
                  },
                ),
              ),
            ),
            // Messages Label
            const Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 26, // Adjust the size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ur steps closer to the coolest ppl :p',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
            // Vertical List for Old Chats
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                itemCount: viewModel.old_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.old_matches[index];
                  bool? is_sent_by_user = match.last_message_sent_by_user;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5), // Adjust as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Border color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corner radius
                    ),
                    child: InkWell(
                        onTap: () => viewModel.go_to_chat(
                            match.match_id,
                            match.other_user_name,
                            match.other_user_pic,
                            match.other_user_id),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              'lib/assets/${match.other_user_pic}.png',
                            ),
                            radius: 30,
                            backgroundColor: const Color(0xFF3439AB),
                          ),
                          title: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Text(
                              match.other_user_name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Text(
                            (is_sent_by_user! ? 'you: ' : '') +
                                (match.last_message?.content ?? ''),
                            style: TextStyle(
                              fontWeight: is_sent_by_user
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: is_sent_by_user
                                  ? const Color.fromARGB(255, 115, 115, 115)
                                  : Colors.black,
                            ),
                          ),
                          trailing: Text(formattedTimestamp(
                              match.last_message!.timestamp)),
                        )),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5), // Adjust as needed
              child: _bottomNavigationBar(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  String formattedTimestamp(DateTime timestamp) {
    return DateFormat('hh:mm a')
        .format(timestamp); // This will give a format like "12:15 PM"
  }

  @override
  ChatsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatsViewModel();
}

Widget _bottomNavigationBar(viewModel) {
  Color profileColor = (viewModel.current_page == "profile" ||
          viewModel.current_page == "edit_profile" ||
          viewModel.current_page == "settings")
      ? Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  Color chatColor = (viewModel.current_page == "chats")
      ? Color(0xFF3439AB)
      : const Color.fromARGB(255, 104, 104, 104);

  return Stack(
    clipBehavior: Clip.none, // Allows the overflowing children to be visible
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.person),
              color: profileColor,
              onPressed: viewModel.go_to_profile,
            ),
            SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.chat),
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
            viewModel.go_to_home();
          }, // Add your home action here
          child: Container(
              width: 70, // Adjust the width and height as needed
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF3439AB)), // Border color
                borderRadius:
                    BorderRadius.circular(40), // Rounded corner radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    offset: Offset(0, 3), // Vertical offset
                    blurRadius: 5.0, // Blur value
                    spreadRadius: 1.0, // Spread value
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/logo.png'),
                backgroundColor: Colors.white,
              )),
        ),
      ),
    ],
  );
}
