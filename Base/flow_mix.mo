within MoMoUrEnSySi.Base;

model flow_mix "3way valve and circulation pump"

	// Parameters
	parameter Real ref_pump_speed;  // [rad/s]
	parameter Real spec_p_el_pump;  // [W/(rad/s)]

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_src_in;
	Modelica.Thermal.Interfaces.FlowPort_a port_sink_in;

	Modelica.Blocks.Interfaces.RealInput alpha;
	Modelica.Blocks.Interfaces.BooleanInput io;

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_src_out;
	Modelica.Thermal.Interfaces.FlowPort_b port_sink_out;
	Modelica.Blocks.Interfaces.RealOutput p_elec;
	Modelica.Blocks.Interfaces.RealOutput dt_src;

	// Nodes
	Modelica.Thermal.FluidHeatFlow.Components.Valve valve_a;
	Modelica.Thermal.FluidHeatFlow.Components.Valve valve_b;
	Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow ideal_pump;
	Modelica.Thermal.FluidHeatFlow.Sources.Speed pump_speed;
	Modelica.Thermal.FluidHeatFlow.Sensors.RelPressureSensor sensor;

equation

	valve_a.y = alpha
	valve_b.y = 1 - alpha

end flow_mix;