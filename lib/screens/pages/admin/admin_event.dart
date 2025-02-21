import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminAddEvent extends StatefulWidget {
  const AdminAddEvent({super.key});

  @override
  State<AdminAddEvent> createState() => _AdminAddEventState();
}

class _AdminAddEventState extends State<AdminAddEvent> {
  final TextEditingController _addTitleController = TextEditingController();
  final TextEditingController _eventDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEvent(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Iconsax.add,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: const Icon(
                        Iconsax.arrow_left_2,
                        size: 17,
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    'Add Event',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SfCalendar(
                view: CalendarView.month,
                todayHighlightColor: Theme.of(context).primaryColor,
                todayTextStyle: TextStyle(
                    fontFamily: 'Playfair', fontWeight: FontWeight.bold),
                showDatePickerButton: true,
                showTodayButton: true,
                headerHeight: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showAddEvent(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.trash)),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            elevation: WidgetStatePropertyAll(0),
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        onPressed: () {},
                        label: Text(
                          'Save',
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  CustomTextInput(
                    label: 'Title',
                    controller: _addTitleController,
                    isTitleNotNecessary: true,
                    isIcon: false,
                  ),
                  CustomTextInput(
                    label: "Event details",
                    controller: _eventDetailsController,
                    isTitleNotNecessary: true,
                    isIcon: false,
                    maxLine: 10,
                    maxLength: 700,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please give details about the notification made';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    leading: Text(
                      'All day?',
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.w700),
                    ),
                    trailing: Switch(
                      activeColor: Colors.white,
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                      inactiveThumbColor: Colors.white,
                      value: true,
                      trackOutlineColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.transparent),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
