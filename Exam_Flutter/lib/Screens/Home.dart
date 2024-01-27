import 'package:flutter/material.dart';

import '../model/Place.dart';
import '../serivce/PlaceService.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Place>> futurePlaces;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futurePlaces = fetchPlaces();
  }
  Widget promoCard(image, title, rating, tymIcon) {
    return AspectRatio(
      aspectRatio: 2.62 / 4, // Adjust the aspect ratio for the added icon and text
      child: Container(
        margin: EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                  colors: [
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.1),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5), // Add spacing between the rating and tymIcon

                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hi Guy! ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Where are you going next? ',
                        style: TextStyle(
                            color: Colors.black87, fontSize: 25),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(244, 243, 243, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black87,
                              ),
                              hintText: "Search you're looking for",
                              hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Popular Deslination',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyFont'),
                ),
                // Use GridView to display a 2x2 grid of promo cards
                SizedBox(
                  height: 20, // Adjust the spacing between the text and the grid
                ),
                FutureBuilder<List<Place>>(
                  future: futurePlaces,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No data available.'),
                      );
                    } else {
                      List<Place> places = snapshot.data!;

                      return GridView.count(
                        crossAxisCount: 2, // Number of columns in the grid
                        shrinkWrap: true, // Allow the grid to be scrollable
                        physics: NeverScrollableScrollPhysics(), // Disable scrolling of the grid
                        mainAxisSpacing: 20.0, // Add spacing between rows
                        children: <Widget>[
                          for (final place in places) // Use the fetched data
                            promoCard(
                              place.imageUrl,
                              place.name,
                              4.5, // Example rating (replace with actual data)
                              Icons.favorite, // Example icon (replace with actual data)
                            ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 20, // Adjust the spacing between the grid and the container
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Define the items for the BottomNavigationBar
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.blue : Colors.black12,
              size: 40,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _currentIndex == 1 ? Colors.blue : Colors.black12),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _currentIndex == 2 ? Colors.blue : Colors.black12),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _currentIndex == 3 ? Colors.blue : Colors.black12),
            label: 'Personnel',
          ),
        ],
        // Set the current index based on the selected tab
        currentIndex: _currentIndex,
        // Define the callback when a tab is tapped
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

