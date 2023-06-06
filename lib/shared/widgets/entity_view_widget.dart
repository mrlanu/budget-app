import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EntityView extends StatelessWidget {
  const EntityView({
    super.key,
    this.icon,
    required this.title,
    required this.routeName,
    this.subtitle,
    this.subtitlePrefix,
    required this.amount,
    this.prefix,
    required this.suffix,
    required this.onTap,
  });

  final Widget? icon;
  final String title;
  final String routeName;
  final String? subtitle;
  final String? subtitlePrefix;
  final String amount;
  final Widget suffix;
  final Widget? prefix;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              height: 220.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  prefix ?? Container() ,
                  Container(
                    margin: EdgeInsets.all(40.w),
                    child: icon,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                          ),
                        ),
                        Row(
                          children: [
                            if (subtitlePrefix != null) Row(
                              children: [
                                Text(
                                  subtitlePrefix!,
                                  style: TextStyle(
                                      fontSize: textTheme.titleSmall!.fontSize),
                                ),
                                SizedBox(width: 20.w,),
                              ],
                            ),
                            if (subtitle != null)  Text(
                              subtitle!,
                              style: TextStyle(
                                  fontSize: textTheme.titleSmall!.fontSize),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$ $amount',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.all(40.w),
                    child: suffix,
                  )
                ],
              ),
            ),
            Divider(
              indent: 100.w,
              endIndent: 100.w,
            ),
          ],
        ));
  }
}
