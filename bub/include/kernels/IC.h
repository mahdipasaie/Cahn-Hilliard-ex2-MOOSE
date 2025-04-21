#pragma once

#include "InitialCondition.h"

class IC : public InitialCondition
{
public:
  static InputParameters validParams();

  IC(const InputParameters & parameters);

protected:
  virtual Real value(const Point & p) override;

private:
  Real _c0;
  Real _epsilon;
};
