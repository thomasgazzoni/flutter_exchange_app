import 'package:exchange_app/config/ui.dart';
import 'package:exchange_app/logic/market/market_model.dart';
import 'package:flutter/material.dart';

class MarketItemWidget extends StatelessWidget {
  final MarketItem marketItem;
  double sizeWidth = 10;

  MarketItemWidget(this.marketItem);

  getImage(String symbol) {
    return Image.asset('assets/coins/' + symbol.toLowerCase() + '.png',
        height: 28.0);
  }

  Widget renderCoinInfo(BuildContext context) => Container(
      width: sizeWidth * UiConfig.MARKET_COLUMN_SIZE[0],
      padding: EdgeInsets.only(left: 16.0),
      child: Row(children: [
        Container(
            margin: EdgeInsets.only(right: 16.0),
            child: getImage(marketItem.tradeCoin)),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Text(marketItem.tradeCoin,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(' / ', style: Theme.of(context).textTheme.caption),
                Text(marketItem.marketCoin,
                    style: Theme.of(context).textTheme.caption),
              ]),
              Text(marketItem.displayVolume,
                  style: Theme.of(context).textTheme.caption),
            ])
      ]));

  Widget renderPrice(BuildContext context) => Container(
      width: sizeWidth * UiConfig.MARKET_COLUMN_SIZE[1],
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(marketItem.displayPrice,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(marketItem.displayFiatPrice,
                style: Theme.of(context).textTheme.caption),
          ]));

  Widget renderIncrease(BuildContext context) => Container(
      width: sizeWidth * UiConfig.MARKET_COLUMN_SIZE[2],
      padding: EdgeInsets.only(right: 16.0),
      child: Text(
        (marketItem.increase > 0 ? "+" : "") + marketItem.displayIncrease,
        style: Theme.of(context)
            .textTheme
            .body1
            .apply(color: marketItem.increase > 0 ? Colors.green : Colors.red),
        textAlign: TextAlign.end,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width;

    return Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
        child: Row(
          children: <Widget>[
            renderCoinInfo(context),
            renderPrice(context),
            renderIncrease(context),
          ],
        ));
  }
}
