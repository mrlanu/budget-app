import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.semanticsLabel,
    required this.amount,
    required this.suffix,
  });

  final Widget? icon;
  final String title;
  final String? subtitle;
  final String semanticsLabel;
  final String amount;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        button: true,
        enabled: true,
      ),
      excludeSemantics: true,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 350),
        transitionType: ContainerTransitionType.fade,
        openBuilder: (context, openContainer) => Scaffold(
          appBar: AppBar(title: Text('Hello'),),
        ),
        openColor: theme.background,
        closedColor: theme.background,
        closedElevation: 0,
        closedBuilder: (context, openContainer) {
          return GestureDetector(
              onTap: openContainer,
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
                                          fontSize: textTheme.titleLarge!.fontSize,),
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
                                            .fontSize, fontWeight: FontWeight.bold),
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
                    indent: 20.w,
                    endIndent: 20.w,
                  ),
                ],
              ));
        },
      ),
    );
  }
}
