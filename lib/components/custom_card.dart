import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color lightColor;
  final Color darkColor;
  final String? title; // Optional title parameter
  final double? height; // Optional height parameter
  final String? showAllText; // Optional "Show All" text
  final VoidCallback? onShowAll; // Optional callback function for navigation
  final Color? titleColor; // Optional color for the title text
  final Color? showAllTextColor; // Optional color for the "Show All" text

  const CustomCard(
      {super.key, // Use super parameter for key
      required this.child,
      required this.lightColor,
      required this.darkColor,
      this.title, // Now optional
      this.height,
      this.showAllText,
      this.onShowAll,
      this.titleColor,
      this.showAllTextColor // New optional parameter for the color of "Show All" text
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? lightColor
              : darkColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // Align vertically in the center
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) // Check if title is not null
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    if (showAllText != null && onShowAll != null)
                      InkWell(
                        onTap: onShowAll,
                        child: Text(showAllText!,
                            style: TextStyle(
                                color: showAllTextColor ?? Colors.blue)),
                      ),
                  ],
                ),
              SizedBox(height: title != null ? 10 : 0),
              // Adjust spacing based on the presence of the title
              child,
            ],
          ),
        ),
      ),
    );
  }
}
