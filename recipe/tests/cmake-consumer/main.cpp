#include <dart/dart.hpp>

#include <cstddef>

int main()
{
  auto world = std::make_shared<dart::simulation::World>();
  auto skeleton = dart::dynamics::Skeleton::create("smoke");
  world->addSkeleton(skeleton);
  world->step();
  return world->getNumSkeletons() == std::size_t{1} ? 0 : 1;
}
