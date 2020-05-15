import 'package:flutter/material.dart';
import 'package:gentle/components/loading_shimmer_builder.dart';

class ActivityLogListItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingShimmerBuilder(
      builder: (BuildContext context, Color bgColor) {
        return Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: bgColor,
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 16,
                      margin: const EdgeInsets.only(right: 40),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Container(
                height: 16,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: bgColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
