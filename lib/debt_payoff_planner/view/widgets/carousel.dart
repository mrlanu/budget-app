import 'package:budget_app/debt_payoff_planner/cubit/debt_payoff_cubit.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/debt_tile.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebtCarousel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DebtCarouselState();
  }
}

class _DebtCarouselState extends State<DebtCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtPayoffCubit, DebtPayoffState>(
      builder: (context, state) {
        final items = state.debtList.map((debt) => DebtTile(debtModel: debt,)).toList();
        return state.status == DebtPayoffStatus.loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                CarouselSlider(
                  items: items,
                  carouselController: _controller,
                  options: CarouselOptions(
                      height: 270,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ]);
      },
    );
  }
}
