/*
 * Copyright (c) 2023 Biwesh Shrestha
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:flutter/material.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';

import 'package:intl/intl.dart';

class CalendarItems extends StatelessWidget {
  CalendarItems({
    Key? key,
    required this.index,
    required this.startDate,
    required this.initialDate,
    required this.selectedDate,
    required this.textColor,
    required this.selectedColor,
    required this.backgroundColor,
    required this.locale,
    required this.onDatePressed,
  }) : super(key: key);

  final int index;
  final DateTime startDate;
  final DateTime initialDate;
  final DateTime selectedDate;
  final Color textColor;
  final Color selectedColor;
  final Color backgroundColor;
  final Locale locale;
  final VoidCallback onDatePressed;

  @override
  Widget build(BuildContext context) {
    DateTime date = startDate.add(Duration(days: index));
    int diffDays = date.difference(selectedDate).inDays;
    int checkPastDate = date.difference(initialDate).inDays;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: (width / 100) * 12.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(
        //   color: diffDays != 0 ? Colors.blueGrey : selectedColor,
        //   width: 1, // Độ dày của border
        // ),
        color: diffDays != 0 ? ColorsManager.primary.withOpacity(0.8) : Colors.white,
      ),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onDatePressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              DateFormat.E(locale.toString()).format(date),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontFamily: 'Nunito',
                  color: diffDays != 0
                      ? checkPastDate >= 0
                          ? Colors.white
                          : Colors.grey[300]
                      : Colors.blue),
            ),
            SizedBox(height: 2.0),
            Text(
              DateFormat.d(locale.toString()).format(date),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontFamily: 'Nunito',
                  color: diffDays != 0
                      ? checkPastDate >= 0
                          ? Colors.white
                          : Colors.grey[300]
                      : Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
