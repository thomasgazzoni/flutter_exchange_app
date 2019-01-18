import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MarketBanner extends StatefulWidget {
  @override
  _MarketBannerState createState() => _MarketBannerState();
}

class _MarketBannerState extends State<MarketBanner> {
  int _current = 0;

  final List<String> imgList = [
    'https://via.placeholder.com/520x200/a53262/222222?text=New+app++has+just+launched',
    'https://via.placeholder.com/520x200/6faa6d/222222?text=NEO/BTC+trade+added',
    'https://via.placeholder.com/520x200/9846aa/222222?text=USDT+marker+Open+for+Trade',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
      CarouselSlider(
        items: imgList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.00, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                            offset: Offset(1.0, 2.0)),
                      ]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        i,
                        fit: BoxFit.cover,
                        width: 1000.0,
                      )));
            },
          );
        }).toList(),
        autoPlay: true,
        distortion: false,
        viewportFraction: 1.0,
        height: 140,
        autoPlayDuration: Duration(milliseconds: 500),
        interval: Duration(seconds: 5),
        updateCallback: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Positioned(
          bottom: 0.0,
          right: 22.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList
                .map<Widget>((index) => Container(
                      width: 6.0,
                      height: 6.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == imgList.indexOf(index)
                              ? Theme.of(context).primaryColor
                              : Color.fromRGBO(255, 255, 255, 0.4)),
                    ))
                .toList(),
          ))
    ]));
  }
}
