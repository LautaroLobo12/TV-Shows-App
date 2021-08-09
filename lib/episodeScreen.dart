import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'models/episode.dart';
import 'services/TVServices.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({Key? key, required this.id}) : super(key: key);

  final id;
  _EpisodeScreenState createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  Episode data = Episode(
      id: 0,
      name: '',
      number: 0,
      season: 0,
      airdate: '',
      summary: '',
      image: '');

  void fetchEpisodeData() async {
    data = await TVServices().getEpisodeData(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchEpisodeData();
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
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 15),
                          child: Container(
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
                                height: 140,
                                image: data.image != ''
                                    ? NetworkImage(
                                        data.image,
                                      )
                                    : AssetImage('assets/image-not-found.png')
                                        as ImageProvider,
                              ),
                            ),
                          )),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Season ${data.season} - Episode ${data.number}',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ),
                  Center(
                    child: Text('${data.name}',
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Html(data: data.summary, style: {
                        "p": Style(
                            color: Colors.purple[800],
                            textAlign: TextAlign.center)
                      }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Aired: ',
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontWeight: FontWeight.bold)),
                      Text('${data.airdate}',
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ],
              ),
      );
}
