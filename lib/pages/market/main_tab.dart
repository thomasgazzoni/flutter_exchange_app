import 'package:exchange_app/logic/market/market_bloc.dart';
import 'package:exchange_app/logic/market/market_provider.dart';
import 'package:exchange_app/widgets/market/banner.dart';
import 'package:exchange_app/widgets/market/market_item.dart';
import 'package:exchange_app/widgets/market/sort_bar.dart';
import 'package:exchange_app/config/ui.dart';
import 'package:exchange_app/logic/market/market_model.dart';
import 'package:flutter/material.dart';

class MarketTab {
  MarketTab({this.key, this.label});
  final String key;
  final String label;
}

final List<MarketTab> _allPages = PRICE_MARKETS.keys
    .map((label) => MarketTab(key: label, label: label))
    .toList();

class MarketTabPage extends StatefulWidget {
  @override
  _MarketTabPageState createState() => _MarketTabPageState();
}

class _MarketTabPageState extends State<MarketTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    MarketProvider.of(context)
        .marketBloc
        .setCurrentMarket(_allPages[_tabController.index].key);
  }

  Widget buildAppBar() => AppBar(
        title: Text('Markets', style: UiConfig.appBarTextStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.search), iconSize: 25, onPressed: () {})
        ],
      );

  Widget buildSliverContent() => SliverFixedExtentList(
        // Here we need to avoid that the content goes under the Tab/Sort Bar,
        // so we need to controll the height of the remaining space
        itemExtent: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            // TODO: maybe is a Flutter bug, on iPhoneX padding.bottom is 0, I think it should be 34px
            MediaQuery.of(context).padding.bottom -
            40 - // Market TabBar
            40 - // Market SortBar
            20 -
            (-4) - // Add Border Bottom/Shadow
            kToolbarHeight - // AppBar
            kBottomNavigationBarHeight, // Bottom TabBar
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return TabBarView(
                controller: _tabController,
                children: _allPages.map<Widget>(buildTabView).toList());
          },
          childCount: 1,
        ),
      );

  Widget buildTabView(MarketTab marketTab) => Container(
      color: Colors.white,
      child: StreamBuilder<List<MarketItem>>(
          stream: MarketProvider.of(context).marketBloc.markets[marketTab.key],
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error);
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.length == 0) {
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: 50,
                  alignment: Alignment.topCenter,
                  child: Text('No records'));
            }
            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return MarketItemWidget(snapshot.data[index]);
                });
          }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: RefreshIndicator(
            onRefresh: () =>
                MarketProvider.of(context).marketBloc.updateMarketData(),
            child: CustomScrollView(
                primary: true,
                physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                      floating: false,
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      expandedHeight: 140.0,
                      flexibleSpace: MarketBanner()),
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(40),
                        child: MarketSortBar()),
                    flexibleSpace: PreferredSize(
                        preferredSize: Size.fromHeight(40),
                        child: TabBar(
                          indicatorColor: Colors.white,
                          indicatorWeight: 1.00,
                          controller: _tabController,
                          tabs: _allPages
                              .map<Widget>((MarketTab page) =>
                                  Tab(text: page.label.toUpperCase()))
                              .toList(),
                        )),
                  ),
                  buildSliverContent()
                ])));
  }
}
