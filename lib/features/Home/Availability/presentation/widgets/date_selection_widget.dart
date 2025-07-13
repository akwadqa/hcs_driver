import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';

/// A form field that shows a date picker when tapped,
/// but looks just like a TextFormField with a trailing icon.
class DateFormField extends StatefulWidget {
  /// Label or hint for the field.
  final String labelText;

  /// Called when the user selects a date.
  final ValueChanged<DateTime>? onDateSelected;

  /// Optional initial date to show in the picker / field.
  final DateTime? initialDate;

  /// Earliest date selectable.
  final DateTime firstDate;

  /// Latest date selectable.
  final DateTime lastDate;

  DateFormField({
    super.key,
    this.labelText = 'Select Date',
    this.onDateSelected,
    this.initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : firstDate = firstDate ?? DateTime.now(),
       lastDate = lastDate ?? DateTime(2100);

  @override
  DateFormFieldState createState() => DateFormFieldState();
}

class DateFormFieldState extends State<DateFormField> {
  late TextEditingController _controller;
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _pickedDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(_pickedDate!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    final now = DateTime.now();
    final initial = _pickedDate ?? now;
    final chosen = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (chosen != null) {
      setState(() {
        _pickedDate = chosen;
        _controller.text = DateFormat('yyyy-MM-dd').format(chosen);
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(chosen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(AppStrings.date),
          style: Theme.of(context).textTheme.displayMedium!,
        ),
        8.verticalSpace,
        TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: _onTap,
          decoration: InputDecoration(
            // labelText: widget.labelText,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            suffixIcon: Assets.images.calendar.svg(
              width: 16,
              height: 16,
              fit: BoxFit.scaleDown,
            ),
            border: const OutlineInputBorder(),
          ),
          validator: (s) {
            if (s == null || s.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),
      ],
    );
  }
}
