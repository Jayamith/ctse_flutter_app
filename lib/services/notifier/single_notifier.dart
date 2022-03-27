import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/notifier_model.dart';

class SingleNoifier extends StatelessWidget {
  final Notifier? notifier;
  SingleNoifier(this.notifier);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black12,
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Minimum Battery Level : ${notifier?.level.toString()}%",
                  style: GoogleFonts.poppins(
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
          Icon(
            notifier!.isCompleted == 1 ? Icons.done_all : Icons.pending_actions,
            size: 30,
            color: notifier!.isCompleted == 1
                ? Colors.green[800]
                : Colors.orange[800],
          )
        ]),
      ),
    );
  }
}
