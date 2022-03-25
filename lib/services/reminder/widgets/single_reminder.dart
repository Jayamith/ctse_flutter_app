import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/reminder_model.dart';

class SingleReminder extends StatelessWidget {
  final Reminder? reminder;
  SingleReminder(this.reminder);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black45,
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder?.title ?? "",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${reminder!.startTime}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Minimum Battery Level : ${reminder?.remindMe.toString()}%",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[200]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 1,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          /* RotatedBox(
            quarterTurns: 3,
            child: Text(
              reminder!.isCompleted == 1 ? "NOTED" : "WAITING",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),*/
          Icon(
            reminder!.isCompleted == 1 ? Icons.done_all : Icons.pending_actions,
            size: 30,
            color:
                reminder!.isCompleted == 1 ? Colors.green[800] : Colors.orange,
          )
        ]),
      ),
    );
  }
}
