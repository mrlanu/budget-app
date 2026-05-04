import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants/colors.dart';
import '../utils/theme/budget_theme.dart';
import '../utils/theme/cubit/theme_cubit.dart';

class _DrawerItem {
  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final IconData icon;
  final String routeName;
}

const List<_DrawerItem> _kPrimaryItems = [
  _DrawerItem(
    title: 'Summary',
    icon: FontAwesomeIcons.listUl,
    routeName: 'summary',
  ),
];

const List<_DrawerItem> _kChartItems = [
  _DrawerItem(
    title: 'Trend',
    icon: FontAwesomeIcons.chartSimple,
    routeName: 'trend',
  ),
  _DrawerItem(
    title: 'Sum by Category',
    icon: FontAwesomeIcons.chartPie,
    routeName: 'category-trend',
  ),
  _DrawerItem(
    title: 'Net Worth',
    icon: FontAwesomeIcons.chartLine,
    routeName: 'net-worth',
  ),
];

const List<_DrawerItem> _kTailItems = [
  _DrawerItem(
    title: 'Debt payoff planner',
    icon: FontAwesomeIcons.moneyCheckDollar,
    routeName: 'debt-payoff',
  ),
  _DrawerItem(
    title: 'Backup',
    icon: FontAwesomeIcons.googleDrive,
    routeName: 'backup',
  ),
  _DrawerItem(
    title: 'Settings',
    icon: FontAwesomeIcons.gear,
    routeName: 'settings',
  ),
];

/// Top-level stagger slots: Summary, Charts panel, then each tail item.
int get _kStaggerSlotCount =>
    _kPrimaryItems.length + 1 + _kTailItems.length;

class BudgetDrawer extends StatefulWidget {
  const BudgetDrawer({
    super.key,
    required this.onDrawer,
  });

  final VoidCallback onDrawer;

  @override
  State<BudgetDrawer> createState() => _BudgetDrawerState();
}

class _BudgetDrawerState extends State<BudgetDrawer>
    with SingleTickerProviderStateMixin {
  static final int _menuLength = _kStaggerSlotCount;
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 260);
  static const _staggerTime = Duration(milliseconds: 45);
  static const _buttonDelayTime = Duration(milliseconds: 140);
  static const _buttonTime = Duration(milliseconds: 420);

  late final Duration _animationDuration = _initialDelayTime +
      (_staggerTime * _menuLength) +
      _buttonDelayTime +
      _buttonTime;
  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  bool _chartsExpanded = false;

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
        Duration(milliseconds: (_menuLength * 45)) + _buttonDelayTime;
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = BudgetTheme.isDarkMode(context);
    final primarySwatch = context.read<ThemeCubit>().state.primaryColor;
    final secondary = context.read<ThemeCubit>().state.secondaryColor;

    final panelBg = isDark
        ? const Color(0xFF151821)
        : Color.lerp(primarySwatch[50], scheme.surface, 0.35)!;
    final accent = isDark ? secondary : primarySwatch[700]!;

    return Material(
      color: panelBg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildAmbientGradient(isDark, scheme, primarySwatch),
          _buildWatermark(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, scheme, isDark, accent),
                Expanded(child: _buildScrollableMenu(accent, isDark, scheme)),
                _buildCloseButton(context, scheme, secondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGradient(
    bool isDark,
    ColorScheme scheme,
    MaterialColor primarySwatch,
  ) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? [
                    scheme.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                    scheme.secondary.withValues(alpha: 0.06),
                  ]
                : [
                    primarySwatch[100]!.withValues(alpha: 0.55),
                    Colors.transparent,
                    scheme.primaryContainer.withValues(alpha: 0.25),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildWatermark() {
    return Positioned(
      bottom: 48,
      right: -28.w,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.07,
          child: Image.asset(
            'assets/images/piggy_bank.png',
            width: 220.w,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme scheme,
    bool isDark,
    Color accent,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? scheme.onSurface : scheme.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Insights, tools & preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 14.h),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.0),
                  accent.withValues(alpha: 0.35),
                  accent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableMenu(
    Color accent,
    bool isDark,
    ColorScheme scheme,
  ) {
    var slot = 0;

    Widget staggered(int index, Widget child) {
      return AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.easeOutCubic.transform(
            _itemSlideIntervals[index].transform(_staggeredController.value),
          );
          final opacity = animationPercent;
          final slide = (1.0 - animationPercent) * 36;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, slide),
              child: child,
            ),
          );
        },
        child: child,
      );
    }

    final children = <Widget>[
      ..._kPrimaryItems.map((item) {
        final i = slot++;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: staggered(
            i,
            _buildNavTile(item, accent, isDark, scheme),
          ),
        );
      }),
      Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: staggered(
          slot++,
          _buildChartsExpansionPanel(accent, isDark, scheme),
        ),
      ),
      ..._kTailItems.map((item) {
        final i = slot++;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: staggered(
            i,
            _buildNavTile(item, accent, isDark, scheme),
          ),
        );
      }),
    ];

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      children: children,
    );
  }

  Widget _buildChartsExpansionPanel(
    Color accent,
    bool isDark,
    ColorScheme scheme,
  ) {
    final tileBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : scheme.surface.withValues(alpha: 0.92);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : scheme.outline.withValues(alpha: 0.22);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: tileBg,
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ExpansionPanelList(
              elevation: 0,
              materialGapSize: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (index, isExpanded) {
                // Second arg is the *new* expanded state for this panel (Flutter sample pattern).
                setState(() => _chartsExpanded = isExpanded);
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: _chartsExpanded,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, _) {
                    // Match [_buildNavTile] (non-nested): same padding + 44 icon so collapsed height aligns.
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: accent.withValues(alpha: 0.14),
                            ),
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.chartSimple,
                              size: 19,
                              color: accent,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Charts',
                              style: TextStyle(
                                color: isDark
                                    ? BudgetColors.lightContainer
                                    : scheme.onSurface,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
                    child: Column(
                      children: [
                        for (final e in _kChartItems.asMap().entries) ...[
                          if (e.key > 0) SizedBox(height: 8.h),
                          _buildNavTile(
                            e.value,
                            accent,
                            isDark,
                            scheme,
                            nested: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavTile(
    _DrawerItem item,
    Color accent,
    bool isDark,
    ColorScheme scheme, {
    bool nested = false,
  }) {
    final tileBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : scheme.surface.withValues(alpha: 0.92);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : scheme.outline.withValues(alpha: 0.22);

    final iconBox = nested ? 40.0 : 44.0;
    final vPad = nested ? 12.h : 14.h;
    final titleSize = nested ? 16.sp : 17.sp;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onDrawer();
          context.push('/${item.routeName}');
        },
        borderRadius: BorderRadius.circular(nested ? 12 : 16),
        splashColor: accent.withValues(alpha: 0.12),
        highlightColor: accent.withValues(alpha: 0.06),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(nested ? 12 : 16),
            color: nested
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : scheme.surfaceContainerHighest.withValues(alpha: 0.45))
                : tileBg,
            border: Border.all(
              color: nested
                  ? borderColor.withValues(alpha: 0.65)
                  : borderColor,
            ),
            boxShadow: !nested && !isDark
                ? [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: vPad),
            child: Row(
              children: [
                Container(
                  width: iconBox,
                  height: iconBox,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: accent.withValues(alpha: 0.14),
                  ),
                  alignment: Alignment.center,
                  child: FaIcon(
                    item.icon,
                    size: nested ? 17 : 19,
                    color: accent,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: isDark
                          ? BudgetColors.lightContainer
                          : scheme.onSurface,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurface.withValues(alpha: 0.38),
                  size: nested ? 22 : 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(
    BuildContext context,
    ColorScheme scheme,
    Color secondary,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.easeOutBack.transform(
            _buttonInterval.transform(_staggeredController.value),
          );
          final opacity = animationPercent.clamp(0.0, 1.0);
          final scale = (animationPercent * 0.08) + 0.92;

          return Opacity(
            opacity: opacity,
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: secondary.withValues(alpha: 0.22),
            foregroundColor: scheme.onSurface,
          ),
          onPressed: widget.onDrawer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded, size: 22.sp, color: scheme.onSurface),
              SizedBox(width: 10.w),
              Text(
                'Close',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17.sp,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
