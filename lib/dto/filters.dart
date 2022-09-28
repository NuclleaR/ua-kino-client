class Filters {
  final YearsFilter years;
  final String sort;
  final String sortDirection;
  final int? page;
  final ImdbFilter? imdb;

  Filters({
    YearsFilter? years,
    this.sort = "date",
    this.sortDirection = "desc",
    this.page,
    this.imdb,
  }) : years = years ?? YearsFilter();

  Filters copyWith({
    YearsFilter? years,
    String? sort,
    String? sortDirection,
    int? page,
    ImdbFilter? imdb,
  }) {
    return Filters(
      years: years ?? this.years,
      sort: sort ?? this.sort,
      sortDirection: sortDirection ?? this.sortDirection,
      page: page ?? this.page,
      imdb: imdb ?? this.imdb,
    );
  }

  @override
  String toString() {
    // c.year=1921,2022/sort=date;desc/page/2
    var str = "$years/sort=$sort;$sortDirection";
    if (imdb != null) {
      str += "/$imdb";
    }
    if (page != null) {
      str += "/page/$page";
    }
    return str;
  }

// There is the same as page /films/fantasy
// late final String? genre;

// Need to login
// try to hardcode
// late final int? translation;
}

class ImdbFilter {
  final double from;
  final double to;

  ImdbFilter(this.from, this.to);

  @override
  String toString() {
    // r.imdb=4.7;10
    return 'r.imdb=$from;$to';
  }
}

class YearsFilter {
  final int from;
  final int to;

  YearsFilter([this.from = 1921, int? to]) : to = to ?? DateTime.now().year;

  @override
  String toString() {
    // c.year=1921,2022
    return 'c.year=$from,$to';
  }
}
