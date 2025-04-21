#include "IC.h"
#include "MooseMesh.h"
#include "libmesh/utility.h"

registerMooseObject("bubApp", IC);

InputParameters
IC::validParams()
{
  InputParameters params = InitialCondition::validParams();
  params.addParam<Real>("c0", 0.5, "Base concentration value");
  params.addParam<Real>("epsilon", 0.01, "Amplitude of deterministic fluctuation");
  return params;
}

IC::IC(const InputParameters & parameters)
  : InitialCondition(parameters),
    _c0(getParam<Real>("c0")),
    _epsilon(getParam<Real>("epsilon"))
{
}

Real
IC::value(const Point & p)
{
  const Real x = p(0);
  const Real y = p(1);

  Real val = _c0 + _epsilon * (
      std::cos(0.105 * x) * std::cos(0.11 * y)
    + std::pow(std::cos(0.13 * x) * std::cos(0.087 * y), 2.0)
    + std::cos(0.025 * x - 0.15 * y) * std::cos(0.07 * x - 0.02 * y)
  );

  return val;
}
