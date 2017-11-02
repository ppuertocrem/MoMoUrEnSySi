within MoMoUrEnSySi.Base;

model pid_pump "circulation ideal pump controlled (PID) by a fixed delta T"
	extends MoMoUrEnSySi.Partial.PFPTM_io_pelec;

	// Parameters
	// https://www.engineeringtoolbox.com/pumps-power-d_505.html
	parameter Real conso_spec_pump=250 "Specific electrical power consumed by pump";  // [kW/(m3/s)]
	parameter Real dt_set=5 "Set point for temperature difference";  // [deg.C]
	parameter Real volumeFlow_max=1 "Maximum flow allowed by pump";  // [m3/s]

	// Nodes
	Modelica.Blocks.Continuous.LimPID pid(yMax=volumeFlow_max, yMin=0.0);

	Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow ideal_pump(
		medium=medium1,
		m=0,
		TO=TAmb;
		useVolumeFlowInput=true);

	Modelica.Thermal.FluidHeatFlow.Sensors.RelTemperatureSensor sensor(
		medium=medium1);

equation

	// Controller
	pid.u_s = dt_set;
	connect(pid.u_m, sensor.y);

	// Ideal pump
	connect(switch.y, ideal_pump.volumeFlow);

	// Pipes
	connect(flowPort_a1, ideal_pump.flowPort_a);
	connect(ideal_pump.flowPort_b, flowPort_b1);
	connect(flowPort_a2, flowPort_b2);

	// Sensor
	connect(flowPort_b1, sensor.flowPort_a);
	connect(flowPort_b2, sensor.flowPort_b);

	// Power consumption
	power = if io then conso_spec_p_el_pump * pid.y else 0.0

end pid_pump;