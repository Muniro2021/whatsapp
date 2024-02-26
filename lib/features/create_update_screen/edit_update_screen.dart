import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/create_update_screen/widgets/custome_text_form_field.dart';
import 'package:uct_chat/features/create_update_screen/widgets/radio_item.dart';
import 'package:uct_chat/features/create_update_screen/widgets/radio_item_widget.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/update_message.dart';

class EditUpdateScreen extends StatefulWidget {
  final UpdateMessages updateMessages;

  const EditUpdateScreen({super.key, required this.updateMessages});

  @override
  _EditUpdateScreenState createState() => _EditUpdateScreenState();
}

class _EditUpdateScreenState extends State<EditUpdateScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _timeController;
  late TextEditingController _mentionController;
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;
  late TextEditingController _colorController;
  late TextEditingController _idMentionController;
  List<RadioModel> sampleData = [];
  String? selectedColor;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _timeController = TextEditingController(text: widget.updateMessages.time);
    _mentionController =
        TextEditingController(text: widget.updateMessages.mention);
    _subjectController =
        TextEditingController(text: widget.updateMessages.subject);
    _bodyController = TextEditingController(text: widget.updateMessages.body);
    _colorController = TextEditingController(text: widget.updateMessages.color);
    selectedColor = widget.updateMessages.color;
    _idMentionController =
        TextEditingController(text: widget.updateMessages.idMention);
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.circleInfo,
        'Info',
        Colors.blue,
        "blue",
      ),
    );
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.solidBell,
        'Warning',
        Colors.orange,
        "orange",
      ),
    );
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.triangleExclamation,
        'Urgent',
        Colors.red,
        "red",
      ),
    );
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.handHoldingHeart,
        'Good',
        Colors.green,
        "green",
      ),
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    _mentionController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    _colorController.dispose();
    _idMentionController.dispose();
    super.dispose();
  }

  void _saveUpdate() async {
    if (_formKey.currentState!.validate()) {
      await APIs.editUpdate(
        _mentionController.text,
        _subjectController.text,
        _bodyController.text,
        _colorController.text,
        _timeController.text,
        _idMentionController.text,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Update'),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await APIs.deleteOneUpdate(
                  _timeController.text,
                  _idMentionController.text,
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                enabled: false,
                controller: _mentionController,
                decoration: const InputDecoration(labelText: 'Mention'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a mention';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: _subjectController,
                label: "subject",
                hintText: "Add Subject Here",
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: _bodyController,
                label: "body",
                hintText: "Add Body Here",
                maxLines: 7,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sampleData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: whiteColor,
                      onTap: () {
                        setState(() {
                          for (var element in sampleData) {
                            element.isSelected = false;
                          }
                          sampleData[index].isSelected = true;
                        });
                        selectedColor = sampleData[index].value;
                      },
                      child: RadioItem(item: sampleData[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              InkWell(
                onTap: _saveUpdate,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryLightColor,
                  ),
                  child: const Text(
                    "Edit Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Unna',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
