import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants/colors.dart';
import '../utils/theme/budget_theme.dart';
import '../utils/theme/cubit/theme_cubit.dart';

class BudgetDrawer extends StatefulWidget {
  const BudgetDrawer({
    super.key,
    required this.onDrawer,
  });

  final Function() onDrawer;

  @override
  State<BudgetDrawer> createState() => _BudgetDrawerState();
}

class _BudgetDrawerState extends State<BudgetDrawer>
    with SingleTickerProviderStateMixin {
  static const _menuLength = 6;
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);

  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuLength) +
      _buttonDelayTime +
      _buttonTime;
  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuLength; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuLength * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.read<ThemeCubit>().state.primaryColor;
    return Container(
      color: BudgetTheme.isDarkMode(context) ? Color(0xFF272727) : color[100],
      child: Stack(
        fit: StackFit.expand,
        children: [_buildLogo(), _buildContent()],
      ),
    );
  }

  Widget _buildLogo() {
    return Positioned(
      bottom: 70,
      left: 50.w,
      child: Opacity(
        opacity: 0.2,
        child: Image.asset(
          'assets/images/piggy_bank.png', // Replace with your image path
          width: 400.w, // Adjust size as needed
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildCloseButton(context),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final menuTiles = _createMenuTiles();
    final listItems = <Widget>[];
    for (var i = 0; i < _menuLength; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5.h),
            child: menuTiles[i],
          ),
        ),
      );
    }
    return listItems;
  }

  List<ListTile> _createMenuTiles() => [
        _buildMenuItem(
          title: 'Summary',
          icon: FaIcon(
            color: _getColor(),
            FontAwesomeIcons.listUl,
          ),
          routeName: 'summary',
        ),
        _buildMenuItem(
            title: 'Trend',
            icon: FaIcon(
              color: _getColor(),
              FontAwesomeIcons.chartSimple,
            ),
            routeName: 'trend'),
        _buildMenuItem(
            title: 'Sum by Category',
            icon: FaIcon(
              color: _getColor(),
              FontAwesomeIcons.chartPie,
            ),
            routeName: 'category-trend'),
        _buildMenuItem(
            title: 'Debt payoff planner',
            icon: FaIcon(
              color: _getColor(),
              FontAwesomeIcons.moneyCheckDollar,
            ),
            routeName: 'debt-payoff'),
        _buildMenuItem(
            title: 'Backup',
            icon: FaIcon(
              color: _getColor(),
              FontAwesomeIcons.googleDrive,
            ),
            routeName: 'backup'),
        _buildMenuItem(
            title: 'Settings',
            icon: FaIcon(
              color: _getColor(),
              FontAwesomeIcons.gear,
            ),
            routeName: 'settings'),
      ];

  Widget _buildCloseButton(BuildContext context) {
    final colors = context.read<ThemeCubit>().state;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          bottom: 35.h,
        ),
        child: AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
              _buttonInterval.transform(_staggeredController.value),
            );
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: colors.secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: widget.onDrawer,
            child: Text(
              'Close',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp),
            ),
          ),
        ),
      ),
    );
  }

  ListTile _buildMenuItem(
      {required String title,
      required Widget? icon,
      required String routeName}) {
    return ListTile(
        leading: icon,
        title: Text(title,
            style: TextStyle(
                color: _getColor(),
                fontSize: 24.sp,
                fontWeight: FontWeight.bold)),
        subtitle: Divider(
          color: _getColor(),
        ),
        onTap: () {
          widget.onDrawer();
          context.push('/$routeName');
        });
  }

  Color _getColor() {
    final themeState = context.read<ThemeCubit>().state;
    return BudgetTheme.isDarkMode(context)
        ? BudgetColors.lightContainer
        : themeState.primaryColor[900]!;
  }
}
