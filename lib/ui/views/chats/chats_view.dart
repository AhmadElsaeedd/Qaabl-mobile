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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  style: Theme.of(context).textTheme.titleLarge,
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
                  return Container(
                    width: 80, // Adjust the width as needed
                    child: Card(
                      child: Center(
                        child: Text(match.other_user_name), // Display the other user's name
                      ),
                    ),
                  );
                },
              ),
            ),
            // Messages Label
            Text(
              'Messages',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Vertical List for Old Chats
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.old_matches.length,
                itemBuilder: (context, index) {
                  final match = viewModel.old_matches[index];
                  return ListTile(
                    title: Text(match.other_user_name), // Display the other user's name
                    subtitle: Text(match.last_message?.content ?? ''), // Replace with actual data
                  );
                },
              ),
            ),
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
