import 'package:flutter/material.dart';
import 'package:coronamap/controllers/covid_api.dart';
import 'package:coronamap/custom_widgets/statistic_card.dart';
import 'package:coronamap/custom_widgets/theme_switch.dart';
import 'package:coronamap/custom_widgets/loader.dart';
import 'package:coronamap/global.dart';
import 'package:coronamap/models/country_model.dart';
import 'package:coronamap/models/global_info_model.dart';
import 'package:coronamap/views/country_detail.dart';

class GlobalInfoPage extends StatefulWidget {
  @override
  _GlobalInfoPageState createState() => _GlobalInfoPageState();
}

class _GlobalInfoPageState extends State<GlobalInfoPage> {
  GlobalInfo _stats;
  double deathPercentage;
  double activePercentage;
  bool _isLoading = false;
  CovidApi api = CovidApi();
  double recoveryPercentage;

  HomeCountry _homeCountry;

  bool value = false;
  @override
  void initState() {
    super.initState();
    _fetchHomeCountry();
    _fetchGlobalStats();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COVID-19 stats',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        leading: Icon(
          Icons.public,
          color: Theme.of(context).accentColor,
        ),
        actions: <Widget>[
          ThemeSwitch(),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Loader()
            : _stats == null
                ? buildErrorMessage()
                : ListView(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            child: Column(
                              children:[CheckboxListTile(
                                title: Text("Contrubute"),
                                value: value,
                                onChanged: (val) {
                                  setState(() {
                                    value = val;
                                    if (val == true) {
                                      value = true;
                                    }
                                  });
                                },
                              )]
                            ),
                          )),
                      if (_homeCountry != null)
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.home,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          title: Text(_homeCountry.name),
                          subtitle: Text(
                            _homeCountry.cases + '--' + _homeCountry.deaths,
                          ),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CountryDetailPage(
                                countryName: _homeCountry.name,
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: Icon(Icons.sentiment_very_dissatisfied),
                            title: Text('Death percentage'),
                            trailing: Text(
                              deathPercentage.toStringAsFixed(2) + ' %',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: Icon(Icons.sentiment_very_satisfied),
                            title: Text('Recovery percentage'),
                            trailing: Text(
                              recoveryPercentage.toStringAsFixed(2) + ' %',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      StatisticCard(
                        color: Colors.blueAccent,
                        text: 'Total cases',
                        icon: Icons.assignment_ind,
                        stats: _stats.cases,
                      ),
                      StatisticCard(
                        color: Colors.green,
                        text: 'Total recovered',
                        icon: Icons.assignment_turned_in,
                        stats: _stats.recovered,
                      ),
                      StatisticCard(
                        color: Colors.red,
                        text: 'Total deaths',
                        icon: Icons.assignment_returned,
                        stats: _stats.deaths,
                      ),

                    ],
                  ),
      ),
    );
  }

  Center buildErrorMessage() {
    return Center(
      child: Text(
        'Unable to fetch data',
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.grey),
      ),
    );
  }

  void _fetchGlobalStats() async {
    setState(() => _isLoading = true);
    try {
      var stats = await api.getGlobalInfo();
      deathPercentage = (stats.deaths / stats.cases) * 100;
      recoveryPercentage = (stats.recovered / stats.cases) * 100;
      activePercentage = 100 - (deathPercentage + recoveryPercentage);

      print(deathPercentage);
      print(recoveryPercentage);
      print(activePercentage);
      setState(() => _stats = stats);
    } catch (ex) {
      setState(() => _stats = null);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fetchHomeCountry() async {
    var list = await mySharedPreferences.fetchHomeCountry();
    if (list != null) {
      setState(() {
        _homeCountry = HomeCountry(
          name: list[0],
          cases: list[1],
          deaths: list[2],
        );
      });
    }
  }
}
