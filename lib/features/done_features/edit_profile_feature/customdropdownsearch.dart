import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class CustomDropdownSearch extends StatefulWidget {
  final String title;
  final List<SelectedListItem> listdata;
  final TextEditingController dropdownSelectedName;
  final TextEditingController dropdownSelectedId;
  String position;
  CustomDropdownSearch({
    super.key,
    required this.title,
    required this.listdata,
    required this.dropdownSelectedName,
    required this.dropdownSelectedId,
    required this.position,
  });

  @override
  State<CustomDropdownSearch> createState() => _CustomDropdownSearchState();
}

class _CustomDropdownSearchState extends State<CustomDropdownSearch> {
  void showdropdownsearch() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: widget.listdata,
        selectedItems: (List<dynamic> selectedList) {
          SelectedListItem selectedListItem = selectedList[0];
          widget.dropdownSelectedName.text = selectedListItem.name;
          widget.dropdownSelectedId.text = selectedListItem.value!;
        },
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontFamily: 'Unna'),
      onSaved: (val) => widget.position = val ?? '',
      validator: (val) =>
          val != null && val.isNotEmpty ? null : 'Required Field',
      controller: widget.dropdownSelectedName,
      cursorColor: Colors.black,
      onTap: () {
        FocusScope.of(context).unfocus();
        showdropdownsearch();
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.accessibility, color: primaryLightColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        label: const Text('Position'),
        labelStyle: const TextStyle(color: seconderyDarkColor),
        hintText: widget.dropdownSelectedName.text == ""
            ? widget.title
            : widget.dropdownSelectedName.text,
      ),
    );
  }
}
