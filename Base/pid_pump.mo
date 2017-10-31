within MoMoUrEnSySi.Base;

model flow_mix "3way valve and circulation pump"

	// Parameters
	parameter Real conso_spec_p_el_pump=100;  // [W/(rad/s)]
	parameter Real dt_set=5 ;  // [deg.C]

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_hot_in;
	Modelica.Thermal.Interfaces.FlowPort_a port_cold_in;

	Modelica.Blocks.Interfaces.BooleanInput io;

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_hot_out;
	Modelica.Thermal.Interfaces.FlowPort_b port_cold_out;
	Modelica.Blocks.Interfaces.RealOutput p_elec;

	// Nodes
	Modelica.Blocks.Continuous.LimPID pid;
	Modelica.Blocks.Logical.Switch switch;
	Modelica.Thermal.Mechanics.Rotational.Sources.Speed pump_speed;
	Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow ideal_pump;
	Modelica.Thermal.FluidHeatFlow.Sensors.RelTemperatureSensor sensor;

equation

	pid.u_s = dt_set;
	connect(pid.u_m, sensor.y);

	connect(switch.u1, pid.y);
	switch.u2 = io;
	switch.u3 = 0.0;

	connect(switch.y, pump_speed.w_ref);
	connect(pump_speed.flange, ideal_pump.flange_a);

	connect(port_hot_in, ideal_pump.flowPort_a);
	connect(ideal_pump.flowPort_b, port_hot_out);

	connect(port_cold_in, port_cold_out);

	

	p_elec = conso_spec_p_el_pump * switch.y;

end flow_mix;