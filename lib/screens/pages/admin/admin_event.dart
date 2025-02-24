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
    return Consumer<AddEventProvider>(builder: (context, eventProvider, child) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Iconsax.arrow_left_2,
                  size: 17,
                )),
            toolbarHeight: 70,
            title: Text(
              'Add Event',
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SfCalendar(
              view: CalendarView.month,
              todayHighlightColor: Theme.of(context).primaryColor,
              todayTextStyle: TextStyle(
                  fontFamily: 'Playfair', fontWeight: FontWeight.bold),
              showDatePickerButton: true,
              showTodayButton: true,
              headerHeight: 70,
              dataSource: MeetingDataSource(eventProvider.events),
              onTap: (CalendarTapDetails details) {
                if (details.appointments != null &&
                    details.appointments!.isNotEmpty) {
                  UpcomingEventsModel selectedEvent =
                      details.appointments!.first;
                  eventProvider.deleteEvent(selectedEvent);
                }
              },
            ),
          ));
    });
  }

  Future<dynamic> _showAddEvent(BuildContext context) {
    bool isAllDay = true;
    final TextEditingController _addTitleController = TextEditingController();
    final TextEditingController _eventDetailsController =
        TextEditingController();
    DateTime selectedDateFrom = DateTime.now();
    TimeOfDay selectedTimeFrom = TimeOfDay.now();
    DateTime selectedDateTo = DateTime.now();
    TimeOfDay selectedTimeTo = TimeOfDay.now();

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Ensures `setState` works inside modal
          builder: (context, setState) {
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
                          icon: const Icon(Iconsax.trash),
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(0),
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            _addevents(
                                selectedDateFrom,
                                isAllDay,
                                selectedTimeFrom,
                                selectedDateTo,
                                selectedTimeTo,
                                _addTitleController,
                                _eventDetailsController,
                                context);
                          },
                          label: Text(
                            'Save',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                          return 'Please provide details about the event';
                        }
                        return null;
                      },
                    ),

                    // Toggle for All Day Event
                    ListTile(
                      leading: const Icon(Iconsax.timer_start),
                      title: const Text(
                        'All day',
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.w700),
                      ),
                      trailing: Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        inactiveThumbColor: Colors.white,
                        value: isAllDay,
                        trackOutlineColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.transparent,
                        ),
                        onChanged: (value) {
                          setState(() {
                            isAllDay = value;
                          });
                        },
                      ),
                    ),

                    isAllDay == true
                        ? Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Date: ${selectedDateFrom.toLocal().day}-${selectedDateFrom.toLocal().month}-${selectedDateFrom.toLocal().year}",
                                ),
                                trailing: const Icon(Iconsax.calendar),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDateFrom,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() => selectedDateFrom = picked);
                                  }
                                },
                              ),
                              ListTile(
                                title: Text(
                                    "Time : ${selectedTimeFrom.format(context)}"),
                                trailing: const Icon(Iconsax.timer_1),
                                onTap: () async {
                                  TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTimeFrom,
                                  );
                                  if (picked != null) {
                                    setState(() => selectedTimeFrom = picked);
                                  }
                                },
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Date From: ${selectedDateFrom.toLocal().day}-${selectedDateFrom.toLocal().month}-${selectedDateFrom.toLocal().year}",
                                ),
                                trailing: const Icon(Iconsax.calendar),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDateFrom,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() => selectedDateFrom = picked);
                                  }
                                },
                              ),
                              ListTile(
                                title: Text(
                                    "Time from: ${selectedTimeFrom.format(context)}"),
                                trailing: const Icon(Iconsax.timer_1),
                                onTap: () async {
                                  TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTimeFrom,
                                  );
                                  if (picked != null) {
                                    setState(() => selectedTimeFrom = picked);
                                  }
                                },
                              ),
                              const Divider(),
                              ListTile(
                                title: Text(
                                  "Date To: ${selectedDateTo.toLocal().day}-${selectedDateTo.toLocal().month}-${selectedDateTo.toLocal().year}",
                                ),
                                trailing: const Icon(Iconsax.calendar),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDateTo,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() => selectedDateTo = picked);
                                  }
                                },
                              ),
                              ListTile(
                                title: Text(
                                    "Time to: ${selectedTimeTo.format(context)}"),
                                trailing: const Icon(Iconsax.timer_1),
                                onTap: () async {
                                  TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTimeTo,
                                  );
                                  if (picked != null) {
                                    setState(() => selectedTimeTo = picked);
                                  }
                                },
                              ),
                            ],
                          )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addevents(
      DateTime selectedDateFrom,
      bool isAllDay,
      TimeOfDay selectedTimeFrom,
      DateTime selectedDateTo,
      TimeOfDay selectedTimeTo,
      TextEditingController _addTitleController,
      TextEditingController _eventDetailsController,
      BuildContext context) {
    final DateTime eventDateTimeFrom = DateTime(
      selectedDateFrom.year,
      selectedDateFrom.month,
      selectedDateFrom.day,
      isAllDay ? 0 : selectedTimeFrom.hour, // Midnight for all-day events
      isAllDay ? 0 : selectedTimeFrom.minute,
    );

    final DateTime eventDateTimeTo = DateTime(
      selectedDateTo.year,
      selectedDateTo.month,
      selectedDateTo.day,
      isAllDay ? 23 : selectedTimeTo.hour, // End of day for all-day events
      isAllDay ? 59 : selectedTimeTo.minute,
    );

    UpcomingEventsModel upcomingEvents = UpcomingEventsModel(
      eventName: _addTitleController.text,
      eventDetails: _eventDetailsController.text,
      from: eventDateTimeFrom,
      to: eventDateTimeTo,
      isAllDay: isAllDay, // Include `isAllDay` flag
    );

    UpcomingEventsModel upcomingEventsTrue = UpcomingEventsModel(
      eventName: _addTitleController.text,
      eventDetails: _eventDetailsController.text,
      from: eventDateTimeFrom,
      to: eventDateTimeFrom.add(Duration(hours: 1)),
      isAllDay: isAllDay, // Include `isAllDay` flag
    );

    if (isAllDay == false) {
      Provider.of<AddEventProvider>(context, listen: false)
          .addEvent(upcomingEvents);
    } else {
      Provider.of<AddEventProvider>(context, listen: false)
          .addEvent(upcomingEventsTrue);
    }
    Navigator.of(context).pop();
  }
}
