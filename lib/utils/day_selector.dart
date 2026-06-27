import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/extensions/first_to_upper.dart';
import 'package:weather_app/extensions/two_digit_string.dart';
import 'package:weather_app/resources/global_resource.dart';
import 'package:weather_app/utils/month_and_week_names.dart';
import 'package:weather_app/utils/translations/translation.dart';

class DaySelector extends StatelessWidget {
  final Function(String date) onChange;
  final String selectedDate;
  const DaySelector({
    super.key,
    required this.onChange,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    GlobalResource globalResource = GlobalResource.of(context);
    Translation translation = globalResource.appTranslation.translations;
    SupportedLanguage lang = globalResource.appSettings.language;

    return ListView.builder(
      itemCount: 7,
      itemExtent: 100,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        DateTime dateTime = DateTime.now().add(Duration(days: index));

        String date = DateFormat('yyyy-MM-dd').format(dateTime);
        bool isSelected = date == selectedDate;

        String dayText = dateTime.day == DateTime.now().day
            ? translation.today
            : getWeekName(dateTime.weekday - 1, lang, context).firstToUpper();

        return GestureDetector(
          onTap: () => onChange(date),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? Theme.of(context).textSelectionTheme.selectionColor
                  : Colors.transparent,
              border: BoxBorder.all(
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dayText, style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  '${dateTime.day.toTwoDigitString()}.${dateTime.month.toTwoDigitString()}',
                  style: isSelected
                      ? Theme.of(context).textTheme.labelSmall
                      : Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
