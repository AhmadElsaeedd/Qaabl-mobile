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
                      fontFamily: 'Switzer', // Replace with your font if it's different
                      fontSize: 26, // Adjust the size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'chat to reveal the names of ur matches, easy :)',
                    style: TextStyle(
                      fontFamily: 'Switzer',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],)
                  
            ),
            // Horizontal List for New Chats
            Padding(padding: const EdgeInsets.only(top:20),
            child: Container(
              height: 80, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.new_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.new_matches[index];

                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal:5), // Adjust as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Border color
                        borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                            onTap: () => viewModel.go_to_chat(match.match_id, match.other_user_name, match.other_user_pic),
                            child: Container(
                              width: 80, // Adjust the width as needed
                              child: Card(
                                child: Center(
                                  child: Column(
                                    children: [
                                      //Add the user's image here
                                      CircleAvatar(backgroundImage: AssetImage('lib/assets/${match.other_user_pic}.png',), radius: 30, backgroundColor: const Color(0xFF3439AB),),
                                      Padding(padding: const EdgeInsets.only(top:5),
                                              child: ImageFiltered(
                                                imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                child: Text(
                                                match.other_user_name,
                                                style: const TextStyle(fontFamily: "Switzer", fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          )
                                    ],
                                  )
                                  
                                ),
                              ),
                            )
                            )
                  );
                },
              ),
            ),
            ),
            // Messages Label
            const Padding(padding: EdgeInsets.only(top: 25),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                      fontFamily: 'Switzer', // Replace with your font if it's different
                      fontSize: 26, // Adjust the size as needed
                      fontWeight: FontWeight.bold,
                    ),
                ),
                Text(
                    'everyday ur a step closer to meeting cool ppl :p',
                    style: TextStyle(
                      fontFamily: 'Switzer',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
             )
            ),
            // Vertical List for Old Chats
            Expanded(
              child: 
              ListView.builder(
                padding: EdgeInsets.only(top:20),
                itemCount: viewModel.old_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.old_matches[index];
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical:5), // Adjust as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Border color
                        borderRadius: BorderRadius.circular(10), // Rounded corner radius
                      ),
                      child: InkWell(
                            onTap: () => viewModel.go_to_chat(match.match_id, match.other_user_name, match.other_user_pic),
                            child: ListTile(
                              leading: CircleAvatar(backgroundImage: AssetImage('lib/assets/${match.other_user_pic}.png',), radius: 30, backgroundColor: const Color(0xFF3439AB),),
                              title: ImageFiltered(
                                                imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                                child: Text(
                                                match.other_user_name,
                                                style: const TextStyle(fontFamily: "Switzer", fontWeight: FontWeight.bold),
                                              ),
                                            ),
                              subtitle: Text(match.last_message?.content ??''), // Replace with actual data
                              trailing: Text(formattedTimestamp(match.last_message!.timestamp)),
                          )
                        ),
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
    return DateFormat('hh:mm a').format(timestamp); // This will give a format like "12:15 PM"
  }

  @override
  ChatsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatsViewModel();
}

Widget _bottomNavigationBar(viewModel) {
  return Stack(
    clipBehavior: Clip.none, // Allows the overflowing children to be visible
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.person), // Replace with your PNG
              onPressed: viewModel.go_to_profile,
            ),
            const SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.chat), // Replace with your PNG
              onPressed: viewModel.go_to_chats,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the value as needed to position the logo
        child: GestureDetector(
          onTap: () {viewModel.go_to_home();}, // Add your home action here
          child: Container(
            width: 70, // Adjust the width and height as needed
            height: 70,
            decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF3439AB)), // Border color
                        borderRadius: BorderRadius.circular(40), // Rounded corner radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Shadow color
                            offset: Offset(0, 3),  // Vertical offset
                            blurRadius: 5.0,      // Blur value
                            spreadRadius: 1.0,    // Spread value
                          ),
                        ],
                      ),
            child: CircleAvatar(backgroundImage: AssetImage('lib/assets/logo.png'),backgroundColor: Colors.white,)
          ),
        ),
      ),
    ],
  );
}