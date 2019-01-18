import 'package:exchange_app/widgets/common/navigation_icon.dart';
import 'package:exchange_app/pages/market/main_tab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: Icon(Icons.insert_chart),
        title: Text("Markets"),
        vsync: this,
      ),
      NavigationIconView(
        icon: Icon(Icons.monetization_on),
        title: Text("Trade"),
        vsync: this,
      ),
      NavigationIconView(
        icon: Icon(Icons.add_alert),
        title: Text("Discover"),
        vsync: this,
      ),
      NavigationIconView(
        icon: Icon(Icons.account_balance_wallet),
        title: Text("Assets"),
        vsync: this,
      ),
      NavigationIconView(
        icon: Icon(Icons.perm_identity),
        title: Text("Account"),
        vsync: this,
      ),
    ];
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
      MarketTabPage(),
      MarketTabPage(),
      MarketTabPage(),
      MarketTabPage(),
    ];
    _currentPage = _pageList[_currentIndex];
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBar = BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) =>
                navigationIconView.item)
            .toList(),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = index;
            _navigationViews[_currentIndex].controller.forward();
            _currentPage = _pageList[_currentIndex];
          });
        });

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/bg_app.png'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          body: _currentPage,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color.fromRGBO(172, 51, 51, 1.00),
                primaryColor: Colors.white,
                textTheme: Theme.of(context).textTheme.copyWith(
                    // sets the inactive color of the `BottomNavigationBar`
                    caption:
                        TextStyle(color: Color.fromRGBO(192, 141, 141, 1.00))),
              ),
              child: bottomNavigationBar),
        ));
  }
}
