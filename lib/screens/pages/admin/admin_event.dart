import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/common/widget.dart';
import 'package:livingseed_media/screens/models/events_model.dart';
import 'package:livingseed_media/screens/pages/services/add_event_services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminAddEvent extends StatefulWidget {
  const AdminAddEvent({super.key});

  @override
  State<AdminAddEvent> createState() => _AdminAddEventState();
}

class _AdminAddEventState extends State<AdminAddEvent> {
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
      body:
          Consumer<AddEventProvider>(builder: (context, eventProvider, child) {
        return SingleChildScrollView(
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
                  dataSource: MeetingDataSource(eventProvider.events),
                  onTap: (CalendarTapDetails details) {
                    if (details.appointments != null &&
                        details.appointments!.isNotEmpty) {
                      UpcomingEvents selectedEvent =
                          details.appointments!.first;
                      eventProvider.deleteEvent(selectedEvent);
                    }
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<dynamic> _showAddEvent(BuildContext context) {
    final TextEditingController _addTitleController = TextEditingController();
    final TextEditingController _eventDetailsController =
        TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

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
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Iconsax.trash)),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            elevation: WidgetStatePropertyAll(0),
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        onPressed: () {
                          final DateTime eventDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          UpcomingEvents upcomingEvents = UpcomingEvents(
                              eventName: _addTitleController.text,
                              eventDetails: _eventDetailsController.text,
                              from: eventDateTime,
                              to: eventDateTime.add(const Duration(hours: 1)));
                          Provider.of<AddEventProvider>(context, listen: false)
                              .addEvent(upcomingEvents);
                          Navigator.of(context).pop();
                        },
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
                    title:
                        Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                    trailing: const Icon(Iconsax.calendar),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  ListTile(
                    title: Text("Time: ${selectedTime.format(context)}"),
                    trailing: const Icon(Iconsax.timer),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
