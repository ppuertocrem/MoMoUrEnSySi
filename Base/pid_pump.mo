within MoMoUrEnSySi.Base;

model pid_pump "circulation ideal pump controlled (PID) by a fixed delta T (4 ports)"

	// Parameters
	// https://www.engineeringtoolbox.com/pumps-power-d_505.html
	parameter Real conso_spec_pump=250;  // [kW/(m3/s)]

	parameter Real dt_set=5;  // [deg.C]
	parameter Real volumeFlow_max=1  // [m3/s]

	parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();

	// Input
	Modelica.Thermal.Interfaces.FlowPort_a port_hot_in;
	Modelica.Thermal.Interfaces.FlowPort_a port_cold_in;

	Modelica.Blocks.Interfaces.BooleanInput io;

	// Output
	Modelica.Thermal.Interfaces.FlowPort_b port_hot_out;
	Modelica.Thermal.Interfaces.FlowPort_b port_cold_out;

	Modelica.Blocks.Interfaces.RealOutput p_elec;

	// Nodes
	Modelica.Blocks.Continuous.LimPID pid(yMax=volumeFlow_max, yMin=0);
	Modelica.Blocks.Logical.Switch switch;
	Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow ideal_pump(
		medium=medium,
		m=0,
		TO=293.5 
		useVolumeFlowInput=true);
	Modelica.Thermal.FluidHeatFlow.Sensors.RelTemperatureSensor sensor(
		medium=medium);

equation

	// Controller
	pid.u_s = dt_set;
	connect(pid.u_m, sensor.y);

	// Master SWITCH
	connect(switch.u1, pid.y);
	switch.u2 = io;
	switch.u3 = 0.0;

	// Ideal pump
	connect(switch.y, ideal_pump.volumeFlow);

	// Pipes
	connect(port_hot_in, ideal_pump.flowPort_a);
	connect(ideal_pump.flowPort_b, port_hot_out);
	connect(port_cold_in, port_cold_out);

	// Sensor
	connect(port_hot_in, sensor.flowPort_a);
	connect(port_cold_in, sensor.flowPort_b);

	// Power consumption
	p_elec = conso_spec_p_el_pump * switch.y;

end pid_pump;