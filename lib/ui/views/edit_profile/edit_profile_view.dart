import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  List<String>? selected_interests;
  // ignore: non_constant_identifier_names
  EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late List<TextEditingController> interestControllers;
  late List<TextEditingController> interestNameControllers;
  late ValueNotifier<int> selectedImageNotifier;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedImageNotifier = ValueNotifier<int>(0); 
    nameController = TextEditingController();
    interestControllers = <TextEditingController>[];
    interestNameControllers = <TextEditingController>[];
  }

  @override
  void dispose() {
    nameController.dispose();
    interestControllers.forEach((controller) => controller.dispose());
    interestNameControllers.forEach((controller) => controller.dispose());
    selectedImageNotifier.dispose();
    super.dispose();
  }

  void _showInterestsDialog(EditProfileViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose your interests'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: model.predefined_interests.map((interest) {
                  //bool isSelected = model.selected_interests.contains(interest);
                  //ToDo: check the name key of the interests array in each map
                  bool isSelected = model.user_data['interests'].any((map) => map['name'] == interest);
                  print("The interest is: " + interest.toString() + " and is selected is: " + isSelected.toString());
                  return ListTile(
                    title: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black, // Change text color based on selection.
                      ),
                    ),
                    tileColor: isSelected ? Color(0xFF3439AB) : Colors.transparent,
                    onTap: () {
                      model.toggleInterestSelection(interest);
                      // If the interest is newly selected, create and add a new controller.
                      if (model.selected_interests.contains(interest)) {
                        print("Added an interest: " + model.selected_interests.toString());
                        model.interest_are_those(model.selected_interests);
                        interestControllers.add(TextEditingController());
                        interestNameControllers.add(TextEditingController(text: interest));
                      } else {
                        // If the interest is deselected, find and remove the corresponding controller.
                        final index = interestNameControllers.indexWhere((controller) => controller.text == interest);
                        if (index != -1) {
                          interestControllers[index].dispose();
                          interestNameControllers[index].dispose();
                          interestControllers.removeAt(index);
                          interestNameControllers.removeAt(index);
                        }
                      }
                      // To rebuild the widgets with the new controllers.
                      setState(() {});
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () =>
          //EditProfileViewModel(widget.selected_interests ?? []),
          EditProfileViewModel(),
      builder: (context, model, child) {
        Map<String, dynamic>? userData = model.user_data;
        print("User data is: "+ userData.toString());

        if (userData.isNotEmpty) {
          selectedImageNotifier = ValueNotifier<int>(userData['image_index'] ?? 0);
          nameController = TextEditingController(text: userData['name'] ?? '');
          print("I am rebuilding");
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
                      _showInterestsDialog(model);
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
                      print("Interests are: " + interests.toString());
                      //put the correct value into the function, it's not selected_image
                      await model.save_and_back(name, interests, selectedImageNotifier.value);
                      //show a circular progress bar while this await is done
                      setState(() {
                        isSaving = false; // Reset isSaving to false when the await is done
                      });
                    },
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3439AB),
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