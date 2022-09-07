import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCalendar extends StatefulWidget {
  final List dates;
  const CustomCalendar({Key? key, required this.dates}) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  bool isEvent = false;
  DateRangePickerController calendarController = DateRangePickerController();
  @override
  Widget build(BuildContext context) {
    List<DateTime> listDate = [];
    for (String element in widget.dates) {
      List<String> date = element.split('-');
      listDate.add(
        DateTime(
          int.parse(date[0]),
          int.parse(date[1]),
          int.parse(date[2].substring(0, 2)),
        ),
      );
    }
    final isTablet = Provider.of<bool>(context);
    return Padding(
      padding:
          EdgeInsets.only(left: 25.w, right: 25.w, top: isTablet ? 12.h : 0.h),
      child: SfDateRangePicker(
        controller: calendarController,
        monthViewSettings: const DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                textStyle: TextStyle(color: Colors.white))),
        selectionColor: const Color.fromARGB(255, 213, 0, 50),
        selectionShape: DateRangePickerSelectionShape.rectangle,
        backgroundColor: const Color(0xFF232323),
        headerStyle: const DateRangePickerHeaderStyle(
            textStyle: TextStyle(color: Colors.white)),
        onSelectionChanged: (date) {
          log(date.value.toString());
          log(calendarController.selectedRange!.toStringShort());
        },
        monthCellStyle: DateRangePickerMonthCellStyle(
          cellDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 213, 0, 50),
              borderRadius: BorderRadius.circular(10)),
          disabledDatesDecoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(0)),
          disabledDatesTextStyle: const TextStyle(color: Colors.white),
          textStyle: const TextStyle(color: Colors.white),
        ),
        selectionMode: DateRangePickerSelectionMode.multiple,
        initialSelectedDates: listDate,
        initialDisplayDate: listDate.first,
        selectableDayPredicate: (date) {
          if (listDate.contains(date)) {
            log("data bosildi");
            return true;
          } else {
            return false;
          }
        },
      ),
    );
  }
}
