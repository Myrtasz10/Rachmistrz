
class Unit {
  String name;
  double value;
  String symbol;

  Unit(this.name, this.value, this.symbol);
}

class MetricPrefix {
  String name;
  String symbol;
  double value;

  MetricPrefix(this.name, this.symbol, this.value);
}

class Prefixes {

  static List<MetricPrefix> prefixesPL = [
    MetricPrefix('brak', '', 1E0),
    //MetricPrefix('jotta', 'Y', 1E24),
    //MetricPrefix('zetta', 'Z', 1E21),
    //MetricPrefix('eksa', 'E', 1E18),
    //MetricPrefix('peta', 'P', 1E15),
    MetricPrefix('tera', 'T', 1E12),
    MetricPrefix('giga', 'G', 1E9),
    MetricPrefix('mega', 'M', 1E6),
    MetricPrefix('kilo', 'k', 1E3),
    MetricPrefix('hekto', 'h', 1E2),
    MetricPrefix('deka', 'da', 1E1),
    MetricPrefix('decy', 'd', 1E-1),
    MetricPrefix('centy', 'c', 1E-2),
    MetricPrefix('mili', 'm', 1E-3),
    MetricPrefix('mikro', 'μ', 1E-6),
    MetricPrefix('nano', 'n', 1E-9),
    //MetricPrefix('piko', 'p', 1E-12),
    //MetricPrefix('femto', 'f', 1E-15),
    //MetricPrefix('atto', 'a', 1E-18),
    //MetricPrefix('zepto', 'z', 1E-24),
    //MetricPrefix('jokto', 'y', 1E-24),
  ];

  static List<MetricPrefix> prefixesEN = [
    MetricPrefix('none', '', 1E0),
    //MetricPrefix('jotta', 'Y', 1E24),
    //MetricPrefix('zetta', 'Z', 1E21),
    //MetricPrefix('eksa', 'E', 1E18),
    //MetricPrefix('peta', 'P', 1E15),
    MetricPrefix('tera', 'T', 1E12),
    MetricPrefix('giga', 'G', 1E9),
    MetricPrefix('mega', 'M', 1E6),
    MetricPrefix('kilo', 'k', 1E3),
    MetricPrefix('hecto', 'h', 1E2),
    MetricPrefix('deca', 'da', 1E1),
    MetricPrefix('deci', 'd', 1E-1),
    MetricPrefix('centi', 'c', 1E-2),
    MetricPrefix('milli', 'm', 1E-3),
    MetricPrefix('micro', 'μ', 1E-6),
    MetricPrefix('nano', 'n', 1E-9),
    //MetricPrefix('piko', 'p', 1E-12),
    //MetricPrefix('femto', 'f', 1E-15),
    //MetricPrefix('atto', 'a', 1E-18),
    //MetricPrefix('zepto', 'z', 1E-24),
    //MetricPrefix('jokto', 'y', 1E-24),
  ];
}

