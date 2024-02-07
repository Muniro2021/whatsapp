import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch extends StatefulWidget {
  final String title;
  final List<SelectedListItem> listdata;
  final TextEditingController dropdownSelectedName;
  final TextEditingController dropdownSelectedId;
  const CustomDropdownSearch({
    super.key,
    required this.title,
    required this.listdata,
    required this.dropdownSelectedName,
    required this.dropdownSelectedId,
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
      onChanged: (value) {
        setState(() {
          
        });
      },
      controller: widget.dropdownSelectedName,
      cursorColor: Colors.blueAccent.withOpacity(0.4),
      style: const TextStyle(color: Colors.white),
      onTap: () {
        FocusScope.of(context).unfocus();
        showdropdownsearch();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.4),
        hintStyle: const TextStyle(color: Colors.white),
        contentPadding: const EdgeInsets.all(10),
        hintText: widget.dropdownSelectedName.text == ""
            ? widget.title
            : widget.dropdownSelectedName.text,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
