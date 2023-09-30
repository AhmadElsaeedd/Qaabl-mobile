import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'chats_viewmodel.dart';

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: // New Chats Label
                  Text(
                'New Chats',
                style: TextStyle(
                  fontFamily: 'Switzer', // Replace with your font if it's different
                  fontSize: 22, // Adjust the size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Horizontal List for New Chats
            Container(
              height: 100, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.new_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.new_matches[index];
                  return InkWell(
                      onTap: () => viewModel.go_to_chat(match.match_id, match.other_user_name),
                      child: Container(
                        width: 80, // Adjust the width as needed
                        child: Card(
                          child: Center(
                            child: Text(match
                                .other_user_name), // Display the other user's name
                          ),
                        ),
                      ));
                },
              ),
            ),
            // Messages Label
            Text(
              'Messages',
              style: TextStyle(
                  fontFamily: 'Switzer', // Replace with your font if it's different
                  fontSize: 22, // Adjust the size as needed
                  fontWeight: FontWeight.bold,
                ),
            ),
            // Vertical List for Old Chats
            Expanded(
              child: 
              ListView.builder(
                itemCount: viewModel.old_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.old_matches[index];
                  return InkWell(
                      onTap: () => viewModel.go_to_chat(match.match_id, match.other_user_name),
                      child: ListTile(
                        title: Text(match
                            .other_user_name), // Display the other user's name
                        subtitle: Text(match.last_message?.content ??
                            ''), // Replace with actual data
                      ));
                },
              ),
            ),
            _bottomNavigationBar(viewModel),
          ],
        ),
      ),
    );
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
              icon: Icon(Icons.person), // Replace with your PNG
              onPressed: viewModel.go_to_profile,
            ),
            SizedBox(width: 50), // Leave space for the logo
            IconButton(
              icon: Icon(Icons.chat), // Replace with your PNG
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
            child: Image.asset('lib/assets/logo.png'),
          ),
        ),
      ),
    ],
  );
}