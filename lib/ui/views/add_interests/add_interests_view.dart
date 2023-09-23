import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_interests_viewmodel.dart';

class AddInterestsView extends StackedView<AddInterestsViewModel> {
  final List interests_names;
  // ignore: non_constant_identifier_names
  const AddInterestsView({Key? key, required this.interests_names})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddInterestsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.predefined_interests.length,
              itemBuilder: (context, index) {
                final interest = viewModel.predefined_interests[index];
                final isSelected =
                    viewModel.selected_interests.contains(interest);
                return ListTile(
                  title: Text(interest),
                  tileColor: isSelected
                      ? Colors.blue
                      : Colors
                          .transparent, // Change the color to your preference
                  onTap: () => viewModel.toggleInterestSelection(interest),
                );
              },
            ),
            ElevatedButton(
              onPressed: () =>
                  viewModel.save_and_back(viewModel.selected_interests),
              child: Text('Save and Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AddInterestsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddInterestsViewModel(interests_names);
}
