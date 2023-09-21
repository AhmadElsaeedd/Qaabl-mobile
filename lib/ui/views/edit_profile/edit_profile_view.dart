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
  final List<String>? selected_interests;
  // ignore: non_constant_identifier_names
  const EditProfileView({Key? key, this.selected_interests}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late List<TextEditingController> interestControllers;
  late List<TextEditingController> interestNameControllers;

  @override
  Widget build(BuildContext context) { 
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(widget.selected_interests ?? []),
      //onViewModelReady: (model) => model.load_data(),
      builder: (context, model, child) {
        Map<String, dynamic>? userData = model.user_data;

        if (userData.isNotEmpty) {
          nameController = TextEditingController(text: userData['name'] ?? '');
          interestNameControllers = List.generate(
            (widget.selected_interests != null && widget.selected_interests!.isNotEmpty)
              ? widget.selected_interests!.length
              : (userData['interests']?.length ?? 0),
            (index) {
              String interestName = (widget.selected_interests != null && widget.selected_interests!.isNotEmpty)
                ? widget.selected_interests![index]
                : userData['interests'][index]['name'] ?? '';
              return TextEditingController(text: interestName);
            },
          );
          interestControllers = List.generate(
            //if selected_interests has length 0 or is null, take the length of the interests array from the userData object to be the length of the list
            (widget.selected_interests != null && widget.selected_interests!.isNotEmpty)
              ? widget.selected_interests!.length
              : (userData['interests']?.length ?? 0),
            (index) {
                String interestName = (widget.selected_interests != null && widget.selected_interests!.isNotEmpty)
                  ? widget.selected_interests![index]
                  : userData['interests'][index]['name'] ?? '';
                return TextEditingController(
                  text: userData['interests'].any((interest) => interest['name'] == interestName)
                    ? userData['interests'].firstWhere((interest) => interest['name'] == interestName)['description'] ?? ''
                    : ''
                );
              },
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
                        //condition if the length of selected_interests is 0, use the data fetched from network.
                        labelText: (widget.selected_interests != null && widget.selected_interests!.isNotEmpty)
                          ? widget.selected_interests![index]
                          : userData['interests'][index]['name'] ?? 'Interest ${index + 1}',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // ToDo: Implement save and back logic
                      String name = nameController.text;
                      List<Map<String, String>> interests = List.generate(
                        interestControllers.length,
                        (index) => {
                          'name': interestNameControllers[index].text, // Using the text from the name controller
                          'description': interestControllers[index].text,
                        },
                      );
                      await model.save_and_back(name, interests);
                    },
                    child: Text('Save and Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      model.go_to_add_interests();
                    },
                    child: Text('Add interests'),
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
