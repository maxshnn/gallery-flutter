import 'dart:async';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../../domain/new/bloc/new_bloc.dart';
import '../widgets/error_list.dart';
import '../widgets/image_tile.dart';
import '../widgets/loading_list.dart';
import '../widgets/view_image.dart';

class NewTab extends StatefulWidget {
  const NewTab({super.key});

  @override
  State<NewTab> createState() => _NewTabState();
}

class _NewTabState extends State<NewTab> with SingleTickerProviderStateMixin {
  final _listController = ScrollController();
  late AnimationController _draggableController;

  late StreamController<bool> loadingController = StreamController.broadcast();
  @override
  void initState() {
    _draggableController = BottomSheet.createAnimationController(this)
      ..duration = const Duration(milliseconds: 500)
      ..animationBehavior;
    _listController.addListener(() {
      if (_listController.position.maxScrollExtent == _listController.offset) {
        context.read<NewBloc>().add(const GetNewPost());
        loadingController.add(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }
/*   callDescription(posts.Post post, User? user) async {
    return 
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<NewBloc>().add(const RefreshNewPost());
        },
        builder: (context, child, controller) =>
            _refresh(context, child, controller),
        child: BlocBuilder<NewBloc, NewState>(
          buildWhen: (previous, current) {
            if (previous != current) {
              loadingController.add(false);
              return true;
            }

            return previous != current;
          },
          builder: (context, state) {
            if (state is NewLoading) {
              return const Center(
                  child: LoadingAnimation(
                colorIcon: Colors.pink,
              ));
            }

            if (state is NewLoading) {
              return const Center(
                  child: LoadingAnimation(
                colorIcon: Colors.pink,
              ));
            }
            if (state is NewError) {
              return ErrorList(
                error: state.error,
                controller: _listController,
              );
            }
            if (state is NewLoaded && state.posts != null ||
                state is NewCache && state.posts != null) {
              return Stack(children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: MasonryGridView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 9,
                    padding: const EdgeInsets.all(8),
                    controller: state is NewLoaded ? _listController : null,
                    itemCount: state.posts!.length + 2,
                    itemBuilder: (context, index) {
                      if (index < state.posts!.length) {
                        return GestureDetector(
                          onTap: () async {
                            context
                                .read<NewBloc>()
                                .add(GetUserData(id: state.posts![index].user));

                            showModalBottomSheet(
                                useSafeArea: true,
                                transitionAnimationController:
                                    _draggableController,
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (context) => ViewImage(
                                      post: state.posts![index],
                                      user: state.user,
                                    ));
                          },
                          child: ImageTile(index: index, state: state),
                        );
                      } else {
                        return const SizedBox(
                          height: 100,
                        );
                      }
                    },
                  ),
                ),
                StreamBuilder<bool>(
                    stream: loadingController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data ?? false) {
                        return Positioned(
                            bottom: 30,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: LoadingAnimation(),
                              ),
                            ));
                      }
                      return Container();
                    }),
              ]);
            }
            return ErrorList(
              error: '',
              controller: _listController,
            );
          },
        ),
      ),
    );
  }
}

Widget _refresh(context, child, controller) {
  return Stack(
    alignment: Alignment.topCenter,
    children: <Widget>[
      if (!controller.isIdle)
        Positioned(
          top: 35.0 * controller.value,
          child: SizedBox(
            height: 30,
            width: 30,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Transform.rotate(
                  angle: controller.value * 2 * math.pi, child: child),
              child: SvgPicture.asset(
                'assets/svg/loading.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.red, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      Transform.translate(
        offset: Offset(0, 100.0 * controller.value),
        child: child,
      ),
    ],
  );
}
