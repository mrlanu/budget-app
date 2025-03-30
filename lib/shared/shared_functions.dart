import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/changelog.dart';
import '../utils/theme/cubit/theme_cubit.dart';

class SharedFunctions {
  static void showSnackbar(
      BuildContext context, bool success, String title, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: success ? ContentType.success : ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showWhatsNewSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final prColor = context.read<ThemeCubit>().state.primaryColor;
        return Container(
          height: 600,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What's New",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...changelog.map((item) {
                        final isTitle =
                            (item['titles'] as List<dynamic>).isNotEmpty;
                        final isAdded =
                            (item['added'] as List<dynamic>).isNotEmpty;
                        final isFixed =
                            (item['fixed'] as List<dynamic>).isNotEmpty;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              // Padding inside the box
                              decoration: BoxDecoration(
                                color: prColor[100], // Background color
                                borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                              ),
                              child: Text(
                                item['version'] as String,
                                // Assuming `item` has a `version` field
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Text(
                              item['date'] as String,
                              // Assuming `item` has a `version` field
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            isTitle
                                ? RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 20,
                                      color: Colors.black),
                                  children:
                                  (item['titles'] as List<String>)
                                      .map<TextSpan>((change) =>
                                      TextSpan(text: '$change\n'))
                                      .toList()),
                            )
                                : Container(),
                            isAdded
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('Added:',
                                    // Assuming `item` has a `version` field
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            height: 1.5),
                                        children: (item['added']
                                        as List<String>)
                                            .map<TextSpan>((change) =>
                                            TextSpan(
                                                text: ' - $change\n'))
                                            .toList())),
                              ],
                            )
                                : Container(),
                            isFixed
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fixed:',
                                  // Assuming `item` has a `version` field
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            height: 1.5,
                                            fontSize: 20,
                                            color: Colors.black),
                                        children: (item['fixed']
                                        as List<String>)
                                            .map<TextSpan>((change) =>
                                            TextSpan(
                                                text: ' - $change\n'))
                                            .toList()))
                              ],
                            )
                                : Container(),
                            Divider(),
                            SizedBox(height: 15),
                          ],
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


