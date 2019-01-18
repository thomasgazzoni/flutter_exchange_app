import 'package:exchange_app/config/ui.dart';
import 'package:exchange_app/logic/market/market_provider.dart';
import 'package:flutter/material.dart';

class MarketSortBar extends StatefulWidget {
  @override
  _MarketSortBarState createState() => _MarketSortBarState();
}

class _MarketSortBarState extends State<MarketSortBar> {
  double sizeWidth = 10;
  List sortType = ["MARKET", false];

  void sortMarketBy(String columnName) {
    if (sortType[0] == columnName) {
      sortType[1] = !sortType[1];
    } else {
      sortType = [columnName, false];
    }
    setState(() {
      MarketProvider.of(context).marketBloc.sortMarketsBy(sortType);
    });
  }

  Widget sortButton(String columnName, String label,
      {double paddingLeft = 0.00, double paddingRight = 0.00}) {
    return Padding(
        padding: EdgeInsets.only(
            left: paddingLeft, right: paddingRight, top: 8.00, bottom: 8.00),
        child: sortType[0] == columnName
            ? Text(sortType[1] == true ? "$label ⬇" : "$label ⬆",
                style: Theme.of(context).primaryTextTheme.body1)
            : Text("$label",
                style: Theme.of(context)
                    .primaryTextTheme
                    .body1
                    .apply(color: Colors.grey)));
  }

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).dividerColor, width: 1.0))),
      child: Row(
        children: <Widget>[
          Container(
            width: sizeWidth * UiConfig.MARKET_COLUMN_SIZE[0],
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    sortMarketBy('MARKET');
                  },
                  child: sortButton('MARKET', 'Exchange', paddingLeft: 16.00),
                ),
                Text(" / ",
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .apply(color: Colors.grey)),
                InkWell(
                  onTap: () {
                    sortMarketBy('VOLUME');
                  },
                  child: sortButton('VOLUME', 'Vol.'),
                )
              ],
            ),
          ),
          Container(
              width: sizeWidth * UiConfig.MARKET_COLUMN_SIZE[1],
              child: InkWell(
                onTap: () {
                  sortMarketBy('PRICE');
                },
                child: sortButton('PRICE', 'Price'),
              )),
          Container(
              width: sizeWidth * UiConfig.MARKET_COLUMN_SIZE[2],
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  sortMarketBy('CHANGE');
                },
                child: sortButton('CHANGE', 'Change', paddingRight: 16.00),
              )),
        ],
      ),
    );
  }
}
