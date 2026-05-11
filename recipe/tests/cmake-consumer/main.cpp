#include <dart/common/VersionCounter.hpp>

#include <cstddef>

int main()
{
  dart::common::VersionCounter counter;
  counter.incrementVersion();
  return counter.getVersion() == std::size_t{1} ? 0 : 1;
}
