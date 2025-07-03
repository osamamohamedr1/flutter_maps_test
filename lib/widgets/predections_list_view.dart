import 'package:flutter/material.dart';
import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';

class PredictionsListView extends StatelessWidget {
  const PredictionsListView({super.key, required this.places});

  final List<PlaceModel> places;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.pin_drop_rounded),
            title: Text(places[index].description!),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios_rounded),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0);
        },
        itemCount: places.length,
      ),
    );
  }
}
