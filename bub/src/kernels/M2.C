#include "M2.h"

registerMooseObject("bubApp", M2);

InputParameters
M2::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription("Kernel to compute  < - df/dc , v > ");
  params.addRequiredCoupledVar("c", "c");
  params.addParam<Real>("S", 5.0, "	Controls double-well height");
  params.addParam<Real>("Calpha", 0.3, "Strength of the anisotropy");
  params.addParam<Real>("Cbeta", 0.7, "Interface width");

  return params;
}

M2::M2(const InputParameters & parameters)
  : ADKernelValue(parameters),
  _c(adCoupledValue("c")),
  _S(getParam<Real>("S")),
  _Calpha(getParam<Real>("Calpha")),
  _Cbeta(getParam<Real>("Cbeta"))
  
{ 
}


ADReal
M2::precomputeQpResidual()
{
    const ADReal c = _c[_qp];
    const ADReal dfdc = 2 * _S * (c - _Calpha) * (c - _Cbeta) * (c - _Cbeta) +
    2 * _S * (c - _Calpha) * (c - _Calpha) * (c - _Cbeta);

    return - dfdc;
}
