import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'episodeScreen.dart';
import 'models/TVShow.dart';
import 'models/episode.dart';
import 'personScreen.dart';
import 'services/TVServices.dart';

class Details extends StatefulWidget {
  const Details({Key? key, this.id}) : super(key: key);

  final id;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TVShow data = TVShow(
      image: '',
      summary: '',
      id: 0,
      name: '',
      genres: [''],
      status: '',
      schedule: {},
      premiered: '',
      cast: [],
      episodes: [
        Episode(
            id: 0,
            name: '',
            number: 0,
            season: 0,
            airdate: '',
            summary: '',
            image: '')
      ]);

  void fetchSeriesDetails() async {
    data = await TVServices().getSeriesData(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchSeriesDetails();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.purple[800],
          ),
          title: Text(
            'TV Shows App',
            style: TextStyle(color: Colors.purple[800]),
          ),
        ),
        body: data.name == ''
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple[800],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: Container(
                              height: 240,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: Offset(2, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.purple.withOpacity(.1),
                                    width: 4),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                    height: 240,
                                    image: data.image != ''
                                        ? NetworkImage(
                                            data.image,
                                          )
                                        : AssetImage(
                                                'assets/image-not-found.png')
                                            as ImageProvider,
                                  ))),
                        )
                      ],
                    ),
                    Container(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * .05),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data.genres.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                      ),
                                      child: Text('${data.genres[index]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)),
                                )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          data.name,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Html(data: data.summary, style: {
                        "p": Style(
                            textAlign: TextAlign.center,
                            color: Colors.purple[800])
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Container(
                        height: 130,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.cast.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonDetails(
                                      id: data.cast[index]['person']['id']),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: data.cast[index]['person']
                                                  ['image'] !=
                                              null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  data.cast[index]['person']
                                                      ['image']['medium']),
                                              fit: BoxFit.fitWidth)
                                          : DecorationImage(
                                              image: AssetImage(
                                                  'assets/person.png'),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '${data.cast[index]['person']['name']}',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Schedule',
                              style: Theme.of(context).textTheme.headline1),
                        ],
                      ),
                    ),
                    data.schedule['time'] == ''
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Days: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Container(
                                        height: 16,
                                        width: 60,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              data.schedule['days'].length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              Text(data.schedule['days'][index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                        ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Time: ${data.schedule['time']} hs.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                )
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 19.0, bottom: 10.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Episodes',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headline1),
                        ],
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.episodes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final episode = data.episodes[index];
                          if (index != 0 &&
                              data.episodes[index - 1].season !=
                                  episode.season) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EpisodeScreen(id: episode.id),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 8.0, left: 20.0),
                                child: Text(
                                  'Season ${episode.season}: ${episode.name}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EpisodeScreen(id: episode.id),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 20.0),
                              child: Text(
                                'Season ${episode.season}: ${episode.name}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
      );
}
