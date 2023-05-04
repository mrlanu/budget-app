import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app.dart';

class EntityView extends StatelessWidget {
  const EntityView({
    super.key,
    this.icon,
    required this.title,
    required this.routeName,
    this.subtitle,
    required this.semanticsLabel,
    required this.amount,
    required this.suffix,
  });

  final Widget? icon;
  final String title;
  final String routeName;
  final String? subtitle;
  final String semanticsLabel;
  final String amount;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(routeName);
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              height: 250.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(40.w),
                    child: icon,
                  ),
                  Expanded(
                      child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: textTheme.titleLarge!.fontSize,
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: TextStyle(
                                  fontSize: textTheme.titleSmall!.fontSize),
                            ),
                        ],
                      ),
                      Container(
                        child: Text(
                          '\$ $amount',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
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
