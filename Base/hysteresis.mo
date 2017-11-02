within MoMoUrEnSySi.Base;

model hysteresis "hysteresis with uHigh and uLow as inputs"
	extends Modelica.Blocks.PartialBooleanBlock;

	parameter Boolean pre_y_start=false;

	Modelica.Blocks.Interfaces.RealInput uHigh;
	Modelica.Blocks.Interfaces.RealInput uLow;

	Modelica.Blocks.Interfaces.RealInput u;

	Modelica.Blocks.Interfaces.BooleanOutput y;

initial equation
	pre(y) = pre_y_start;

equation
	assert(uHigh > uLow, "hysteresis limits wrong (uHigh <= uLow)");
	y = not pre(y) and u > uHigh or pre(y) and  u >= uLow;

end hysteresis;