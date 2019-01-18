numCommaParse(numString) {
  String str = num.parse(numString ?? "0").round().toString().replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  List<String> strList = str.split(",");

  if (strList.length > 3) {
    return strList[0] +
        "." +
        strList[1].substring(0, 4 - strList[0].length) +
        "B";
  } else if (strList.length > 2) {
    return strList[0] +
        "." +
        strList[1].substring(0, 4 - strList[0].length) +
        "M";
  } else {
    return num.parse(numString ?? "0").toString().replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  }
}

normalizeNum(num input) {
  if (input == null) {
    input = 0;
  }
  if (input >= 100000) {
    return numCommaParse(input.round().toString());
  } else if (input >= 1000) {
    return numCommaParse(input.toStringAsFixed(2));
  } else {
    return input.toStringAsFixed(6 - input.round().toString().length);
  }
}

class MarketItem {
  String marketCoin;
  String tradeCoin;
  num price;
  num fiatPrice;
  num volume;
  num increase;

  get displayVolume => 'Vol ${normalizeNum(volume)}';
  get displayPrice => '${price.toStringAsFixed(6)}';
  get displayFiatPrice => '\$ ${fiatPrice.toStringAsFixed(3)}';
  get displayIncrease => '${increase.toStringAsFixed(2)}%';
}
