within MoMoUrEnSySi.Base;

model heat_pump "heat pump with fixed power"

	// Parameters
	parameter Real p_nominal;  // [kW]

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_src_in;
	Modelica.Thermal.Interfaces.FlowPort_a port_sink_in;

	Modelica.Blocks.Interfaces.BooleanInput io;

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_src_out;
	Modelica.Thermal.Interfaces.FlowPort_b port_sink_out;
	Modelica.Blocks.Interfaces.RealOutput p_elec;

	// Nodes

equation

end heat_pump;