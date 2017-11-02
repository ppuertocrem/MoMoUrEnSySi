within MoMoUrEnSySi.Base;

model buffer "stratified thermal storage / buffer"

	// Parameters
	parameter Real volume=3;  // [m3]

	parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_prod_in;
	Modelica.Thermal.Interfaces.FlowPort_a port_cons_in;

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_prod_out;
	Modelica.Thermal.Interfaces.FlowPort_b port_cons_out;
	Modelica.Blocks.Interfaces.RealOutput t_top;

end buffer;