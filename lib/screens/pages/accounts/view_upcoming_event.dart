import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/screens/models/models.dart';

class ViewUpcomingEvents extends StatelessWidget {
  final UpcomingEventsModel upcomingEvents;
  const ViewUpcomingEvents({super.key, required this.upcomingEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Expanded(
                    child: Text(
                      'Upcoming Event',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      upcomingEvents.eventName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      upcomingEvents.eventDetails,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          'Event Begin Date: ',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          upcomingEvents.from.toIso8601String(),
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Event Ends Date: ',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          upcomingEvents.to.toIso8601String(),
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Event is coming soon, do well to attend! Grace be with you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
