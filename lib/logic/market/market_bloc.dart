import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:exchange_app/logic/market/market_model.dart';
import 'package:http/http.dart' as http;

const PRICE_MARKETS = {
  'FAV': [],
  'USDT': [
    'BTC',
    'ETH',
    'ADA',
    'BCH',
    'EOS',
    'VEN',
    'LTC',
    'ZEC',
    'NANO',
    'XVG',
    'XRP',
  ],
  'BTC': ['ETH', 'ADA', 'ETC', 'USDT'],
  'ETH': ['XRP', 'ADA', 'CMT', 'SNT', 'NEO']
};

class MarketBloc {
  final _markets = Map<String, BehaviorSubject<List<MarketItem>>>();

  final MarketItem _currentPair = null;
  final _countChange = ReplaySubject<int>();
  var _selectedMarket = 'USDT';

  Map<String, Stream<List<MarketItem>>> get markets => _markets;
  String get selectedMarket => _selectedMarket;
  int get selectedMarketIndex =>
      PRICE_MARKETS.keys.toList().indexOf(_selectedMarket);

  StreamSink get countChanger => _countChange.sink;
  Stream<int> get getCount => _countChange.stream;

  MarketBloc() {
    updateMarketData();
  }

  void dispose() {
    _markets.forEach((_, value) => value.close());
    _countChange.close();
  }

  void setCurrentMarket(String market) {
    _selectedMarket = market;
  }

  void sortMarketsBy(sortType) async {
    List<MarketItem> sortedExchangeData = await _markets[_selectedMarket].first;

    var field = sortType[0];
    var isAsc = sortType[1];

    if (field == 'MARKET') {
      if (isAsc) {
        sortedExchangeData.sort((a, b) => b.tradeCoin.compareTo(a.tradeCoin));
      } else {
        sortedExchangeData.sort((a, b) => a.tradeCoin.compareTo(b.tradeCoin));
      }
    }

    if (field == 'VOLUME') {
      if (isAsc) {
        sortedExchangeData.sort((a, b) => b.volume.compareTo(a.volume));
      } else {
        sortedExchangeData.sort((a, b) => a.volume.compareTo(b.volume));
      }
    }

    if (field == 'PRICE') {
      if (isAsc) {
        sortedExchangeData.sort((a, b) => b.price.compareTo(a.price));
      } else {
        sortedExchangeData.sort((a, b) => a.price.compareTo(b.price));
      }
    }

    if (field == 'CHANGE') {
      if (isAsc) {
        sortedExchangeData.sort((a, b) => b.increase.compareTo(a.increase));
      } else {
        sortedExchangeData.sort((a, b) => a.increase.compareTo(b.increase));
      }
    }

    _markets[_selectedMarket].add(sortedExchangeData);
  }

  Future<Null> updateMarketData() async {
    // await getApplicationDocumentsDirectory().then((Directory directory) async {
    //   File jsonFile = new File(directory.path + "/marketLocal.json");
    //   if (jsonFile.existsSync()) {
    //     marketListData = json.decode(jsonFile.readAsStringSync());
    //   } else {
    //     jsonFile.createSync();
    //     jsonFile.writeAsStringSync("[]");
    //     marketListData = Map();
    //   }
    // });

    Future<Null> _pullData(String marketCoin, tradeCoins) async {
      Map marketListData = Map();
      marketListData[marketCoin] = [];
      _markets[marketCoin] = BehaviorSubject(seedValue: []);

      if (marketCoin == 'FAV') {
        return Future.value();
      }

      var response = await http.get(
          Uri.encodeFull(
              "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" +
                  tradeCoins.join(',') +
                  "&tsyms=" +
                  marketCoin),
          headers: {"Accept": "application/json"});

      Map rawMarketListData = JsonDecoder().convert(response.body)["RAW"];

      List<MarketItem> items = [];
      rawMarketListData.forEach((key, value) {
        MarketItem item = MarketItem()
          ..marketCoin = marketCoin
          ..tradeCoin = key
          ..volume = value[marketCoin]['VOLUME24HOUR'] as num
          ..increase = value[marketCoin]['CHANGEPCT24HOUR'] as num
          ..price = value[marketCoin]['PRICE'] as num
          ..fiatPrice = value[marketCoin]['PRICE'] as num;
        items.add(item);
      });
      items.sort((a, b) => a.tradeCoin.compareTo(b.tradeCoin));
      marketListData[marketCoin].add(items);
      _markets[marketCoin].add(items);
    }

    List<Future> futures = [];
    PRICE_MARKETS.forEach((key, values) {
      futures.add(_pullData(key, values));
    });

    try {
      await Future.wait(futures);
    } catch (e) {
      // TODO: handle error
      throw e;
    }

    // getApplicationDocumentsDirectory().then((Directory directory) async {
    //   File jsonFile = new File(directory.path + "/marketLocal.json");
    //   jsonFile.writeAsStringSync(json.encode(marketListData));
    // });
  }
}
