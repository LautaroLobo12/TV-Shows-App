import 'package:flutter/material.dart';

import 'details.dart';
import 'models/TVShow.dart';
import 'services/TVServices.dart';

void main() {
  runApp(TVShowsApp());
}

class TVShowsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TV Shows App',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.purple[800],
              fontWeight: FontWeight.normal,
            ),
            headline1: TextStyle(
              color: Colors.purple[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
              color: Colors.purple[800],
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: Colors.green[50],
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TVShow> tvShows = [];
  int id = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  void fetchTVShows(int id) async {
    tvShows = await TVServices().showIndex(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchTVShows(0);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'TV Shows App',
            style: TextStyle(color: Colors.purple[800]),
          ),
        ),
        body: Column(
          children: [
            searchController.text == ''
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, right: 20.0, left: 20.0),
                    child: Container(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          id != 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    id -= 1;
                                    setState(() {});
                                    fetchTVShows(id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.purple[800]),
                                )
                              : Container(),
                          ElevatedButton(
                            onPressed: () {
                              id += 1;
                              setState(() {});
                              fetchTVShows(id);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Icon(Icons.arrow_forward,
                                color: Colors.purple[800]),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 120,
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(hintText: 'Search'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () async {
                        tvShows = await TVServices()
                            .searchSeries(searchController.text);
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                      child: Text('Search',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 250,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: tvShows.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(id: tvShows[index].id)),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3,
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(2, 2))
                          ],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              width: 2, color: Colors.purple.withOpacity(.1)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            height: 180,
                            image: tvShows[index].image != ''
                                ? NetworkImage(
                                    tvShows[index].image,
                                  )
                                : AssetImage('assets/image-not-found.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          tvShows[index].name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
