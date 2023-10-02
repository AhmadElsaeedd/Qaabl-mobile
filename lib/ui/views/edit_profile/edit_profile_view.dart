import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_profile_viewmodel.dart';

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
  //ValueNotifier<int> selectedImageNotifier = ValueNotifier<int>(0);
  late ValueNotifier<int> selectedImageNotifier;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () =>
          EditProfileViewModel(widget.selected_interests ?? []),
      builder: (context, model, child) {
        Map<String, dynamic>? userData = model.user_data;

        if (userData.isNotEmpty) {
          selectedImageNotifier = ValueNotifier<int>(userData['image_index'] ?? 0);
          nameController = TextEditingController(text: userData['name'] ?? '');
          interestNameControllers = List.generate(
            (widget.selected_interests != null &&
                    widget.selected_interests!.isNotEmpty)
                ? widget.selected_interests!.length
                : (userData['interests']?.length ?? 0),
            (index) {
              String interestName = (widget.selected_interests != null &&
                      widget.selected_interests!.isNotEmpty)
                  ? widget.selected_interests![index]
                  : userData['interests'][index]['name'] ?? '';
              return TextEditingController(text: interestName);
            },
          );
          interestControllers = List.generate(
            //if selected_interests has length 0 or is null, take the length of the interests array from the userData object to be the length of the list
            (widget.selected_interests != null &&
                    widget.selected_interests!.isNotEmpty)
                ? widget.selected_interests!.length
                : (userData['interests']?.length ?? 0),
            (index) {
              String interestName = (widget.selected_interests != null &&
                      widget.selected_interests!.isNotEmpty)
                  ? widget.selected_interests![index]
                  : userData['interests'][index]['name'] ?? '';
              return TextEditingController(
                  text: userData['interests']
                          .any((interest) => interest['name'] == interestName)
                      ? userData['interests'].firstWhere((interest) =>
                              interest['name'] ==
                              interestName)['description'] ??
                          ''
                      : '');
            },
          );

          return Scaffold(
            backgroundColor: Colors.white,
            
            body: Stack(
              children: [
              Container(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top:20),
              child: Column(
                children: [
                  ValueListenableBuilder<int>(
            valueListenable: selectedImageNotifier,
            builder: (context, value, child) => GestureDetector(
              onTap: () async {
                int? chosenIndex = await showDialog<int>(
                  context: context,
                  builder: (context) => ImageChooserDialog(),
                );
                if (chosenIndex != null) {
                  selectedImageNotifier.value = chosenIndex; // Set the new value
                }
              },
              child: Column(
                children: [
                  Image.asset('lib/assets/$value.png', height: 200,), // Use the value
                  Text(
                    'Edit Avatar',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                        labelText: (widget.selected_interests != null &&
                                widget.selected_interests!.isNotEmpty)
                            ? widget.selected_interests![index]
                            : userData['interests'][index]['name'] ??
                                'Interest ${index + 1}',
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      model.go_to_add_interests();
                    },
                    child: Text('Edit interests'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isSaving = true; // Set isSaving to true when the button is pressed
                      });
                      //Implement save and back logic
                      //change the color of the button to #3439AB
                      String name = nameController.text;
                      List<Map<String, String>> interests = List.generate(
                        interestControllers.length,
                        (index) => {
                          'name': interestNameControllers[index]
                              .text, // Using the text from the name controller
                          'description': interestControllers[index].text,
                        },
                      );
                      //ToDo: put the correct value into the function, it's not selected_image
                      await model.save_and_back(name, interests, selectedImageNotifier.value);
                      //show a circular progress bar while this await is done
                      setState(() {
                        isSaving = false; // Reset isSaving to false when the await is done
                      });
                    },
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3439AB), // Change the color of the button to #3439AB
                          ),
                    child: Text('Save and Back'),
                  ),
                  
                  Spacer(),
                  Container(
                  margin: EdgeInsets.only(bottom: 20), // Adjust as needed
                  child: _bottomNavigationBar(model),
                ),
                ],
              ),

            ),
            if (isSaving)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ])
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
              icon: Icon(Icons.person), // Replace with your PNG
              onPressed: viewModel.go_to_profile,
            ),
            SizedBox(width: 50), // Leave space for the logo
            IconButton(
              iconSize: 30,
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

class ImageChooserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite, // Take the maximum width available
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Put them in 2 columns next to each other
          ),
          itemCount: 7, // As you have images from 0.png to 6.png
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(index);
              },
              child: Image.asset('lib/assets/$index.png', height: 100,), // Increase the sizes of the images
            );
          },
        ),
      ),
    );
  }
}