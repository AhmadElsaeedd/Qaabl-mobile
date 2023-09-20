import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_profile_viewmodel.dart';

// class EditProfileView extends StackedView<EditProfileViewModel> {
//   const EditProfileView({Key? key}) : super(key: key);



//   @override
//   Widget builder(
//     BuildContext context,
//     EditProfileViewModel viewModel,
//     Widget? child,
//   ) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Container(
//         padding: const EdgeInsets.only(left: 25.0, right: 25.0),
//       ),
//     );
//   }

//   @override
//   EditProfileViewModel viewModelBuilder(
//     BuildContext context,
//   ) =>
//       EditProfileViewModel();
// }

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late List<TextEditingController> interestControllers;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(),
      //onViewModelReady: (model) => model.load_data(),
      builder: (context, model, child) {
        Map<String, dynamic>? userData = model.user_data;

        if (userData.isNotEmpty) {
          nameController = TextEditingController(text: userData['name'] ?? '');
          interestControllers = List.generate(
            userData['interests']?.length ?? 0,
            (index) => TextEditingController(
                text: userData['interests'][index]['description'] ?? ''),
          );

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Container(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ListView(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  ...List.generate(
                    interestControllers.length,
                    (index) => TextField(
                      controller: interestControllers[index],
                      decoration: InputDecoration(
                        labelText: userData['interests'][index]['name'] ?? 'Interest ${index + 1}',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // ToDo: Implement save and back logic
                    },
                    child: Text('Save and Back'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
