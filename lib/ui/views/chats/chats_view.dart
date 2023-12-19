import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'chats_viewmodel.dart';
import 'dart:ui';
import 'package:shimmer/shimmer.dart';

class ChatsView extends StackedView<ChatsViewModel> {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatsViewModel viewModel,
    Widget? child,
  ) {
    final isLoading = viewModel.isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Chats',
                      style: GoogleFonts.lexend(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'chat to find out who they are!',
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
            // Horizontal List for New Chats
            if (isLoading)
              _buildShimmerEffect(isHorizontal: true)
            else ...[
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
                                        backgroundColor:
                                            const Color(0xFF3439AB),
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
                                              style: GoogleFonts.lexend(
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
            ],

            // Messages Label
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.lexend(
                        fontSize: 26, // Adjust the size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   'ur steps closer to the coolest ppl :p',
                    //   style: GoogleFonts.lexend(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                )),
            if (isLoading) _buildShimmerEffect(isHorizontal: false) else ...[],
            // Vertical List for Old Chats
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: viewModel.old_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.old_matches[index];
                  bool? is_sent_by_user = match.last_message_sent_by_user;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
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
                              style: GoogleFonts.lexend(
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            (is_sent_by_user! ? 'you: ' : '') +
                                (match.last_message?.content ?? ''),
                            style: GoogleFonts.lexend(
                              fontWeight: is_sent_by_user
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: is_sent_by_user
                                  ? const Color.fromARGB(255, 115, 115, 115)
                                  : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
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

  @override
  void onViewModelReady(ChatsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.viewedChatPage();
  }

  Widget _buildShimmerEffect({required bool isHorizontal}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: isHorizontal ? _buildHorizontalShimmer() : _buildVerticalShimmer(),
    );
  }

  Widget _buildHorizontalShimmer() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2, // Show 2 items for shimmer effect
        itemBuilder: (context, index) => Container(
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          2,
          (index) => // Generate 2 placeholder items
              Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Container(
                height: 10,
                color: Colors.grey,
              ),
              subtitle: Container(
                height: 10,
                color: Colors.grey,
                margin: EdgeInsets.only(top: 5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formattedTimestamp(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
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
