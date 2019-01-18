import 'package:flutter/material.dart';
import 'package:exchange_app/logic/market/market_bloc.dart';

class MarketProvider extends InheritedWidget {
  final MarketBloc marketBloc;
  final Widget child;

  MarketProvider({this.marketBloc, this.child}) : super(child: child);

  static MarketProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MarketProvider);

  @override
  bool updateShouldNotify(MarketProvider oldWidget) =>
      marketBloc != oldWidget.marketBloc;
}
