import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'its_a_match_viewmodel.dart';

class ItsAMatchView extends StackedView<ItsAMatchViewModel> {
  const ItsAMatchView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ItsAMatchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Center the buttons
            children: [
              ElevatedButton(
                onPressed: () {
                  // "Go to chats" button action here
                  viewModel.go_to_chats();
                },
                child: Text("Go to chats"),
              ),
              ElevatedButton(
                onPressed: () {
                  // "Keep swiping" button action here
                  viewModel.go_to_swiping();
                },
                child: Text("Keep swiping"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ItsAMatchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ItsAMatchViewModel();
}
