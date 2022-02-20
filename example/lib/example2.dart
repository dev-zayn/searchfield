import 'package:example/country_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Example2 extends StatefulWidget {
  Example2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Example2State createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countries = data.map((e) => Country.fromMap(e)).toList();
  }

  List<Country> countries = [];
  Country _selectedCountry = Country.init();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    suggestions: countries
                        .map((e) => SearchFieldListItem(e.name))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    controller: _searchController,
                    hint: 'Search by country name',
                    maxSuggestionsInViewPort: 4,
                    itemHeight: 45,
                    onTap: (x) {
                      final country = countries.firstWhere((e) {
                        return e.name == x!.searchKey;
                      });
                      setState(() {
                        _selectedCountry = country;
                      });
                    },
                  ),
                ),
                Expanded(
                    child: Center(
                        child: _selectedCountry.name.isEmpty
                            ? Text('select Country')
                            : CountryDetail(
                                country: _selectedCountry,
                              )))
              ],
            )));
  }
}

class CountryDetail extends StatefulWidget {
  final Country? country;

  CountryDetail({Key? key, required this.country}) : super(key: key);
  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  Widget dataWidget(String key, int value) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$key:"),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Text(
              '$value',
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          child: Text(
            widget.country!.name,
            style: TextStyle(fontSize: 40),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        dataWidget('Population:', widget.country!.population),
        dataWidget('Density', widget.country!.density),
        dataWidget('Land Area (in Km\'s)', widget.country!.landArea)
      ],
    );
  }
}
