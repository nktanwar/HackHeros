import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/common/widgets/input_fields/custom_text_form_field.dart';

class DatePickerInput extends StatefulWidget {
  const DatePickerInput({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        widget.controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      readOnly: true,

      onTap: () {
        _selectDate(context);
      },
      label: "Date Of Birth",
      hintText: "YYYY-MM-DD",
    );
  }
}
