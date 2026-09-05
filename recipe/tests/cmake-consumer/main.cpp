#include <dart/collision/bullet/BulletCollisionDetector.hpp>
#include <dart/collision/ode/OdeCollisionDetector.hpp>

int main()
{
  const auto bullet = dart::collision::BulletCollisionDetector::create();
  const auto ode = dart::collision::OdeCollisionDetector::create();

  const auto bulletGroup = bullet->createCollisionGroup();
  const auto odeGroup = ode->createCollisionGroup();

  return bulletGroup && odeGroup ? 0 : 1;
}
